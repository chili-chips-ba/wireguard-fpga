// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

var SearchState = {};
SearchState.active = false;
SearchState.results = [];
SearchState.selected_result = null;
SearchState.abortController = null;


function onSearchButtonClick() {
    if(SearchState.active){
        // Close search
        close_search();
    } else {
        // Open search
        open_search();
    }
}

function open_search(query_text){
    if(typeof query_text === "undefined") query_text = "";
    document.getElementById("_SearchBar").style.display = "block";
    document.getElementById("_Search").style.display = "flex";
    document.getElementById("_Content").style.display = "none";
    document.getElementById("_SBSearchButton").classList.add("close-button");
    document.getElementById("_SBSearchButton").classList.remove("search-button");
    document.getElementById("_MobiSearchButton").classList.add("close-button");
    document.getElementById("_MobiSearchButton").classList.remove("search-button");
    SearchState.active = true;

    clear_search_results();

    var input_el = document.getElementById('_SearchInput');
    input_el.onkeydown = onSearchInputKeypress;
    input_el.oninput = onSearchInputUpdate;
    input_el.value = query_text;
    input_el.focus();

    if(query_text != "") {
        start_search(query_text);
    }
}

function close_search(){
    clear_search_results();
    document.getElementById("_SearchBar").style.display = "none";
    document.getElementById("_Search").style.display = "none";
    document.getElementById("_Content").style.display = "block";
    document.getElementById("_SBSearchButton").classList.add("search-button");
    document.getElementById("_SBSearchButton").classList.remove("close-button");
    document.getElementById("_MobiSearchButton").classList.add("search-button");
    document.getElementById("_MobiSearchButton").classList.remove("close-button");
    SearchState.active = false;
    if(SearchState.abortController) {
        SearchState.abortController.abort();
        SearchState.abortController = null;
    }
}

function onKeyDownSearch(ev) {
    // return True if event was not handled here
    if(!SearchState.active && ev.key == "/" && !ev.ctrlKey){
        open_search();
        return false;
    }

    if(!SearchState.active && ev.key == "/" && ev.ctrlKey){
        open_search(RAL.get_path(CurrentID, undefined, false) + " ");
        return false;
    }

    if(SearchState.active){
        if(ev.key == "Escape"){
            close_search();
            return false;
        }
    }

    return true;
}

function onSearchInputKeypress(ev){
    if(!ev) ev = window.event;

    if(ev.key == "Enter"){
        // Open current selection
        if(SearchState.selected_result != null){
            open_search_result(SearchState.selected_result);
        } else if(SearchState.results.length == 1){
            open_search_result(0);
        }
        return false;
    } else if(ev.key == "ArrowUp"){
        // Move selection up
        if((SearchState.selected_result != null) && (SearchState.selected_result != 0)){
            SearchState.results[SearchState.selected_result].el.classList.remove("selected");
            SearchState.selected_result--;
            SearchState.results[SearchState.selected_result].el.classList.add("selected");
        }

        return false;
    } else if(ev.key == "ArrowDown"){
        // Move selection down
        if(SearchState.selected_result != null){
            // Selection already active
            if(SearchState.selected_result < SearchState.results.length-1){
                SearchState.results[SearchState.selected_result].el.classList.remove("selected");
                SearchState.selected_result++;
                SearchState.results[SearchState.selected_result].el.classList.add("selected");
            }
        } else if(SearchState.results.length){
            // Select first
            SearchState.selected_result = 0;
            SearchState.results[0].el.classList.add("selected");
        }

        return false;
    }
}

function onSearchInputUpdate(ev){
    var query = ev.target.value.trim().toLowerCase();

    clear_search_results();

    start_search(query);
}

function clear_search_results(){
    var results_el = document.getElementById("_SearchResults");

    var range = document.createRange();
    range.selectNodeContents(results_el);
    range.deleteContents();

    SearchState.results = [];
    SearchState.selected_result = null;
}

async function start_search(query) {

    // Abort any prior search
    if(SearchState.abortController){
        SearchState.abortController.abort();
    }
    SearchState.abortController = new AbortController();
    var abortSignal = SearchState.abortController.signal;

    if(query.length == 0) return;

    if(query.startsWith("@")){
        AddressSearch.start(query);
    } else {
        await PathSearch.start(query, abortSignal);
        if(abortSignal.aborted) return;

        // Start a content search if path search completed successfully
        await ContentSearch.start(query, abortSignal);
    }
}

function add_search_result(text_segments, node_id, idx_stack=null, anchor="", content_preview=null){
    // text_segments is an array of segments that should/shouldn't be highlighted
    // All odd segments are highlighted via <mark> tag.
    // text_segments[0] --> not highlighted
    // text_segments[1] --> highlighted

    var result_idx = SearchState.results.length;
    var result_el = document.createElement("li");
    result_el.onmousemove = function() {
        onSearchResultMousemove(result_idx)
    };

    // wrap in clickable link
    result_link = document.createElement("a");
    result_link.href = "?p=" + RAL.get_path(node_id, idx_stack);
    if(anchor != ""){
        result_link.href += "#" + anchor;
    }
    result_link.onclick = function(ev) {
        open_search_result(result_idx);
        return(false);
    };
    result_el.appendChild(result_link);

    var path_div_el = document.createElement("div");
    result_link.appendChild(path_div_el);

    // Build highlighted path crumbtrail
    for(var i=0; i<text_segments.length; i++){
        var el;
        if(i%2){
            el = document.createElement("mark");
        }else{
            el = document.createElement("span");
        }
        el.innerHTML = text_segments[i];
        path_div_el.appendChild(el);
    }

    if(content_preview != null){
        var content_preview_el = document.createElement("div");
        content_preview_el.classList.add("search-content-preview");
        result_link.appendChild(content_preview_el);
        content_preview_el.innerHTML = content_preview;
    }

    var result = {
        "node_id": node_id,
        "idx_stack": idx_stack,
        "el": result_el,
        "anchor": anchor
    };
    document.getElementById("_SearchResults").appendChild(result_el);
    SearchState.results.push(result);
}

function onSearchResultMousemove(result_idx){
    if(SearchState.selected_result == result_idx) return;

    if(SearchState.selected_result != null){
        SearchState.results[SearchState.selected_result].el.classList.remove("selected");
    }
    SearchState.selected_result = result_idx;
    SearchState.results[result_idx].el.classList.add("selected");
}

function open_search_result(result_idx){
    var result = SearchState.results[result_idx];
    if(result.idx_stack == null){
        RAL.reset_indexes(0, result.node_id);
    }else{
        RAL.apply_idx_stack(result.node_id, result.idx_stack);
    }

    var url_hash = "";
    if(result.anchor != ""){
        url_hash = "#" + result.anchor;
    }

    close_search();

    load_page(result.node_id).then(() => {
        Sidebar.expand_to_id(result.node_id);
        Sidebar.select_node(result.node_id);
        Sidebar.scroll_into_view(result.node_id);
        refresh_url(url_hash);
        refresh_title();
        refresh_target_scroll();
    });
}
