// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

var IndexEditState = {};
IndexEditState.active = false;
IndexEditState.id = 0;
IndexEditState.dim = 0;
IndexEditState.span_idx = 0;

function init_index_edit(){

    // Register index edit modal events:
    // ... close if clicking off of it
    window.onclick = function(ev) {
        var modal_el = document.getElementById('_IdxEditModal');
        if(!(isDescendant(modal_el, ev.target) || modal_el==ev.target)){
            exitIndexEditModal();
        }
    };
    // ... close if press enter in input. Cancel if esc
    document.getElementById('_IdxEditInput').onkeypress = onIndexEditKeypress;
}

function onIndexEditKeypress(ev){
    if(!ev) ev = window.event;
    var keyCode = ev.keyCode || ev.which;

    if(keyCode == 13){ // Enter key
        exitIndexEditModal();
        return false;
    } else if(keyCode == 27){ // ESC
        // Exit and cancel modal
        exitIndexEditModal(true);
        return false;
    }
}

function exitIndexEditModal(cancel) {
    if(typeof cancel === "undefined") cancel = false;

    var modal_el = document.getElementById('_IdxEditModal');
    var input_el = document.getElementById('_IdxEditInput');

    if(IndexEditState.active){
        modal_el.style.display = "none";
        IndexEditState.active = false;

        if(!cancel){
            // Commit modal input value
            var val = Number(input_el.value);
            if(!isPositiveInteger(val)) return;
            if((val < 0) || (val >= RAL.get_node(IndexEditState.id).dims[IndexEditState.dim])) return;
            RAL.get_node(IndexEditState.id).idxs[IndexEditState.dim] = val;

            update_crumbtrail();
            update_rdlfc_indexes();
            patch_url_path();
            update_absolute_addr();
            if(RAL.is_register(CurrentID)){
                init_reg_value();
            }
            userHooks.onAddressUpdate();
        }
    }
}

function showIndexEditModal(idx){
    var span_el = document.getElementById('_CrumbIdxSpan' + idx);
    var modal_el = document.getElementById('_IdxEditModal');
    var input_el = document.getElementById('_IdxEditInput');
    var range_el = document.getElementById('_IdxEditRange');

    if(span_el == null) return;

    // Show Modal
    modal_el.style.display = "block";
    var rect = span_el.getBoundingClientRect();
    modal_el.style.left = (rect.left + rect.right)/2 - modal_el.offsetWidth/2 + "px";
    modal_el.style.top = rect.bottom + 10 + "px";

    // Initialize modal
    IndexEditState.active = true;
    IndexEditState.id = parseInt(span_el.dataset.id);
    IndexEditState.dim = parseInt(span_el.dataset.dim);
    IndexEditState.span_idx = idx;
    input_el.value = RAL.get_node(IndexEditState.id).idxs[IndexEditState.dim];
    range_el.innerHTML = "0-" + (RAL.get_node(IndexEditState.id).dims[IndexEditState.dim]-1);

    input_el.focus();
    input_el.select();
}

function onClickCrumbtrailIdx(ev) {
    ev.stopPropagation();

    // Get index of span that was clicked
    // Need to save it in case crumbtrail get re-constructed
    var span_idx = ev.target.dataset.span_idx;

    if(IndexEditState.active){
        // Exit previous modal box
        exitIndexEditModal();
    }
    showIndexEditModal(span_idx);

    return(false);
}

function onKeyDownIdxEdit(ev) {
    // return True if event was not handled here
    if(ev.ctrlKey && ev.key == "["){
        switch_to_prev_idx_edit();
        return false;
    }

    if(ev.ctrlKey && ev.key == "]"){
        switch_to_next_idx_edit();
        return false;
    }

    if(IndexEditState.active) {
        if(ev.key == "Escape"){
            exitIndexEditModal(true);
            return false;
        }
    }

    return true;
}


function switch_to_prev_idx_edit() {
    var span_idx;
    if(IndexEditState.active){
        // Close current modal and flip to next index to the left
        if(IndexEditState.span_idx == 0) return;
        span_idx = IndexEditState.span_idx - 1;
        exitIndexEditModal();
    } else {
        // Open first index
        span_idx = 0;
    }
    showIndexEditModal(span_idx);
}

function switch_to_next_idx_edit() {
    var span_idx;

    // Determine max idx allowed
    var n_idx_spans = document.getElementsByClassName("crumb-idx").length;

    if(IndexEditState.active){
        // Close current modal and flip to next index to the right
        if(IndexEditState.span_idx == n_idx_spans-1) return;
        span_idx = IndexEditState.span_idx + 1;
        exitIndexEditModal();
    } else {
        // Open last index
        span_idx = n_idx_spans-1;
    }
    showIndexEditModal(span_idx);
}
