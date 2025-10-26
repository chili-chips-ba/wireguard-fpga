// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

class Sidebar {
    static #selected_node_id = null;
    static #resizer_old_width = 0;
    static #resizer_start_x = 0;

    static #mousemove_cb = null;
    static #mouseup_cb = null;

    static init(first_id){
        var el;
        // Initialize the sidebar

        // Bind event to resizer
        this.#mousemove_cb = this.#onResizeMouseMove.bind(this);
        this.#mouseup_cb = this.#onResizeMouseUp.bind(this);
        el = document.getElementById("_SBResizer")
        el.addEventListener("mousedown", this.#onResizeMouseDown.bind(this));

        // create the root node(s). Do not recurse
        el = document.getElementById("_SBTree");
        for(var i=0; i<RootNodeIds.length; i++){
            this.#create_node(el, RootNodeIds[i]);
        };

        // Create and expand nodes up to the current selected ID
        this.expand_to_id(first_id);

        // restore sidebar width from previous session
        var sb_width = localStorage.getItem(page_specific_key("sb_width"));
        if(sb_width != null){
            var sb_el = document.getElementById("_SBContents");
            sb_el.style.width = sb_width;
        }
    }

    static expand_to_id(id){
        // Create sidebar elements as needed up to the given ID

        // array of required ID lineage
        var id_chain = RAL.get_ancestors(id);
        id_chain.push(id);


        // Find the innermost element that already exists and all the ids that
        // still need to have their children created
        var node_ids_to_expand = [];
        for(var i=id_chain.length-1; i>=0; i--){
            var current_id = id_chain[i];
            var el = this.#get_node_el(current_id);
            if(el == null){
                // doesnt exist. it will get expanded once created
                node_ids_to_expand.unshift(current_id);
            } else {
                // reached node that exists already
                if(el.classList.contains("closed")){
                    // .. but it is still closed
                    node_ids_to_expand.unshift(current_id);
                }
                break;
            }
        }

        // Create missing elements
        for(var i=0; i<node_ids_to_expand.length; i++){
            this.expand_node(node_ids_to_expand[i]);
        }
    }

    static #get_node_el(id){
        // Get the sidebar node by ID
        return document.getElementById("_SBNode" + id);
    }

    static expand_node(id){
        var el = this.#get_node_el(id);
        var node = RAL.get_node(id);
        if(node.children.length > 0){
            if(el.classList.contains("open")){
                return; // already open
            }

            var cdiv;
            cdiv = document.createElement("div");
            cdiv.className = "node-children";
            el.after(cdiv);

            for(var i=0; i<node.children.length; i++){
                var cid = node.children[i];
                this.#create_node(cdiv, cid);
            }

            // children created. mark as open
            el.classList.add("open")
            el.classList.remove("closed")
        }
    }

    static collapse_node(id){
        var el = this.#get_node_el(id);
        var node = RAL.get_node(id);
        if(node.children.length > 0){
            if(el.classList.contains("closed")){
                return; // already closed
            }
            var cdiv = el.nextElementSibling;
            if(cdiv.classList.contains('node-children')){
                cdiv.remove();
            } else {
                console.error("OOPS");
            }
            el.classList.add("closed")
            el.classList.remove("open")
        }
    }

    static collapse_all(){
        for(var i=0; i<RootNodeIds.length; i++){
            var id = RootNodeIds[i];
            this.collapse_node(id);
        }
    }

    static #create_node(parent_el, id){
        // Creates a single tree node element
        var node = RAL.get_node(id);

        var div;
        div = document.createElement("div");
        div.id = "_SBNode" + id;
        div.dataset.id = id;
        div.className = "node";
        parent_el.appendChild(div);

        var icon;
        icon = document.createElement("div");
        icon.className = "node-icon";
        icon.onclick = onClickTreeFold;
        div.appendChild(icon);

        var link = document.createElement("a");
        link.href = "?p=" + RAL.get_path(id, null, false);
        link.className = "node-link";
        link.onclick = onClickTreeLink;
        if(RAL.is_array(id)){
            var txt = node.name;
            for(var i=0; i<node.dims.length; i++) {
                txt += "[]";
            }
            link.innerHTML = txt;
        } else {
            link.innerHTML = node.name;
        }
        div.appendChild(link);

        if(node.children.length > 0){
            // has children
            div.classList.add("closed");

            var cdiv;
            cdiv = document.createElement("div");
            cdiv.className = "node-children";
            parent_el.appendChild(cdiv);
        } else {
            // is leaf node
            div.classList.add("leaf");
        }
    }

    static select_node(id) {
        // Changes the selected tree node
        var el;
        if(this.#selected_node_id != null){
            el = this.#get_node_el(this.#selected_node_id)
            if(el != null){ // element might have already been deleted
                el.classList.remove("selected");
            }
        }

        el = this.#get_node_el(id);
        el.classList.add("selected");
        this.#selected_node_id = id;
    }

    static #onResizeMouseDown(e) {
        var sb_el = document.getElementById("_SBContents");
        this.#resizer_old_width = sb_el.getBoundingClientRect().width;
        this.#resizer_start_x = e.clientX;
        window.addEventListener('mousemove', this.#mousemove_cb);
        window.addEventListener('mouseup', this.#mouseup_cb);
        e.preventDefault();
    }

    static #onResizeMouseMove(e) {
        var sb_el = document.getElementById("_SBContents");
        var new_width;
        new_width = this.#resizer_old_width + e.clientX - this.#resizer_start_x;
        sb_el.style.width = new_width + "px";
    }

    static #onResizeMouseUp(e) {
        window.removeEventListener('mousemove', this.#mousemove_cb);
        window.removeEventListener('mouseup', this.#mouseup_cb);

        // remember sidebar width
        var sb_el = document.getElementById("_SBContents");
        localStorage.setItem(page_specific_key("sb_width"), sb_el.style.width);
    }

    static show() {
        document.getElementById("_Sidebar").style.display = "flex";
        document.getElementById("_Overlay").style.display = "block";
    }

    static hide() {
        document.getElementById("_Sidebar").style.display = "none";
        document.getElementById("_Overlay").style.display = "none";
    }

    static scroll_into_view(id){
        var node_el = this.#get_node_el(id);
        var tree_el = document.getElementById("_SBTreeContainer");

        var node_rect = node_el.getBoundingClientRect();
        var tree_rect = tree_el.getBoundingClientRect();

        if(
            (node_rect.top < tree_rect.top)
            || (node_rect.bottom > tree_rect.bottom)
            || (node_rect.left < tree_rect.left)
            || (node_rect.right > tree_rect.right)
        ) {
            node_el.scrollIntoView({
                block: "nearest",
                inline: "start"
            });
        }
    }
}

function onClickTreeFold(ev) {
    var el = ev.target.parentNode;
    var id = parseInt(el.dataset.id);
    if(el.classList.contains("leaf")) return;

    if(el.classList.contains("closed")){
        // Open this node
        Sidebar.expand_node(id);

        // may need to re-select current
        Sidebar.select_node(CurrentID);
    }else{
        // Close this node
        Sidebar.collapse_node(id);
    }
}

function onClickTreeLink(ev) {
    var el = ev.target.parentNode;
    var id = parseInt(el.dataset.id);

    close_search();
    Sidebar.hide();

    if(id == CurrentID) return(false);

    if(!el.classList.contains("leaf")){
        Sidebar.expand_node(id);
    }

    RAL.reset_indexes_to_next(id);

    load_page(id).then(() => {
        Sidebar.expand_to_id(id);
        Sidebar.select_node(id);
        refresh_url();
        refresh_title();
        refresh_target_scroll();
    });
    return(false);
}

function onClickTreeCollapseAll() {
    Sidebar.collapse_all()
}
