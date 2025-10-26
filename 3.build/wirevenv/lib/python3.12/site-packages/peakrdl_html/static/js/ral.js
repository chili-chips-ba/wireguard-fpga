// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

class RAL {
    static #ral_data_files = new Array(N_RAL_FILES).fill(null);

    static async load_ral_data(){
        this.#init_progressbar();

        // Dispatch all JSON fetch requests in parallel
        var fetches = [];
        for(var i=0; i<N_RAL_FILES; i++){
            var awaitable = this.#load_ral_file(i);
            fetches.push(awaitable);
        }
        await Promise.all(fetches);
    }

    static async #load_ral_file(idx){
        var path = "data/ral-data-" + idx + ".json?ts=" + BUILD_TS;
        var awaitable = fetch(path)
            .then(response => {
                if(!response.ok){
                    throw new Error("fetch failed");
                }
                return response.json();
            })
            .then(data => {
                this.#increment_progressbar();
                this.#ral_data_files[idx] = data;
            })
            .catch(e => {
                this.#destroy_progressbar();
                throw new Error("fetch failed");
            });
        return awaitable;
    }

    static #progress_points = 0;
    static #progressbar = null;
    static #init_progressbar(){
        this.#progressbar = new ProgressBar.Circle("#_ProgressBar", {
            strokeWidth: 10, // forces extra padding
            trailWidth: 3,
            text: {
                value: "Loading..."
            }
        });

        if(N_RAL_FILES == 1){
            // Only one object to load. animate progress as stand-in.
            this.#progressbar.animate(1, {duration:400});
        }
    }
    static #increment_progressbar(){
        this.#progress_points++;
        this.#progressbar.set(this.#progress_points / N_RAL_FILES);
        if(this.#progress_points == N_RAL_FILES) {
            this.#destroy_progressbar();
        }
    }

    static #destroy_progressbar(){
        this.#progressbar.destroy();
        this.#progressbar = null;
    }

    static get_node(id){
        var file_idx = Math.floor(id / N_RAL_NODES_PER_FILE);
        var idx = id % N_RAL_NODES_PER_FILE;
        var node = this.#ral_data_files[file_idx][idx];
        this.#expand_bigint(node);
        return node;
    }

    static #expand_bigint(node){
        // Check if RAL entry has been converted yet
        if(typeof node.offset !== 'string') return;

        // Needs conversion from base-16 string --> BigInt object
        node.offset = BigInt("0x" + node.offset);
        node.size = BigInt("0x" + node.size);
        if('stride' in node) node.stride = BigInt("0x" + node.stride);

        if(RAL.is_register_node(node)) {
            for(var i=0; i<node.fields.length; i++){
                node.fields[i].reset = BigInt("0x" + node.fields[i].reset);
            }
        }
    }

    static number_of_ids(){
        return (
            (this.#ral_data_files.length - 1) * N_RAL_NODES_PER_FILE
            + this.#ral_data_files[this.#ral_data_files.length - 1].length
        );
    }

    static is_register(id) {
        return(this.is_register_node(this.get_node(id)));
    }

    static is_register_node(node) {
        return("fields" in node);
    }

    static is_array(id) {
        return("dims" in this.get_node(id));
    }

    static get_common_ancestor(id1, id2) {
        var lineage1;
        var lineage2;

        lineage1 = this.get_ancestors(id1);
        lineage1.push(id1);

        lineage2 = this.get_ancestors(id2);
        lineage2.push(id2);

        var id = 0;
        while(lineage1.length && lineage2.length && lineage1[0] == lineage2[0]) {
            id = lineage1[0];
            lineage1.shift();
            lineage2.shift();
        }
        return(id);
    }

    static get_ancestors(id) {
        // Returns a list of id's ancestors
        // first in list is root of the tree
        var ancestors = [];
        while(this.get_node(id).parent !== null) {
            id = this.get_node(id).parent;
            ancestors.unshift(id);
        }
        return(ancestors);
    }

    static get_child_by_name(id, name){
        // get child of id that matches name
        // returns null if not found
        var node = this.get_node(id);
        for(var i=0; i<node.children.length; i++){
            var cid = node.children[i];
            if(this.get_node(cid).name == name){
                return(cid);
            }
        }
        return(null);
    }

    static reset_indexes(from_id, to_id){
        // Reset array indexes of all nodes in range.
        // from_id is the one closest to the root
        // Does not reset the index of from_id
        var id = to_id;
        var node = this.get_node(id);
        while(node.parent !== null) {
            if(id == from_id) break;
            if(this.is_array(id)){
                // reset idxs to all 0s
                node.idxs = node.dims.slice();
                for(var i=0; i<node.idxs.length; i++){
                    node.idxs[i] = 0;
                }
            }

            id = node.parent;
            node = this.get_node(id);
        }
    }

    static reset_indexes_to_next(id){
        // When switching pages, make sure any array nodes that are new to the hier
        // path get their indexes reset
        var common_anc = this.get_common_ancestor(id, CurrentID);
        this.reset_indexes(common_anc, id);
    }

    static parse_path(path){
        // Parses the given path
        // If the path is invalid, null is returned
        // Otherwise, the following two values are returned as an array:
        //  [id, idx_stack]
        // Any invalid indexes in the path are fixed silently

        if(path == null){
            return null;
        }

        // Decompose the path
        var pathparts = path.split(".");
        var segments = [];
        var segment_idxs = [];
        for(var i=0; i<pathparts.length; i++){
            if(pathparts[i] == "") return(null);
            var idxs = [];
            var split_element = pathparts[i].split("[");
            segments.push(split_element.shift());
            for(var dim=0; dim<split_element.length; dim++){
                if(!split_element[dim].endsWith("]")) return(null);
                var n = Number(split_element[dim].slice(0, -1));
                if(!isPositiveInteger(n)) return(null);
                if(n<0) return(null);
                idxs.push(n);
            }
            segment_idxs.push(idxs);
        }

        // Validate first node in path
        var id = null;
        for(var i=0; i<RootNodeIds.length; i++){
            if(segments[0] == this.get_node(RootNodeIds[i]).name) {
                id = RootNodeIds[i];
                break;
            }
        }
        if(id == null) return(null);

        if(this.is_array(id)){
            var sanitized_idxs = [];
            for(var dim=0; dim<this.get_node(id).dims.length; dim++){
                if(dim >= segment_idxs[0].length){
                    sanitized_idxs.push(0);
                } else {
                    sanitized_idxs.push(Math.min(segment_idxs[0][dim], this.get_node(id).dims[dim]-1));
                }
            }
            segment_idxs[0] = sanitized_idxs;
        } else {
            if(segment_idxs[0].length != 0) segment_idxs[0] = [];
        }

        // Validate the path and find the end ID
        for(var i=1; i<segments.length; i++){
            // try to get the child by name
            var next_id = this.get_child_by_name(id, segments[i]);
            if(next_id == null) return(null);
            id = next_id;

            // sanitize indexes
            if(this.is_array(id)){
                var sanitized_idxs = [];
                for(var dim=0; dim<this.get_node(id).dims.length; dim++){
                    if(dim >= segment_idxs[i].length){
                        sanitized_idxs.push(0);
                    } else {
                        sanitized_idxs.push(Math.min(segment_idxs[i][dim], this.get_node(id).dims[dim]-1));
                    }
                }
                segment_idxs[i] = sanitized_idxs;
            } else {
                if(segment_idxs[i].length != 0) segment_idxs[i] = [];
            }
        }

        return([id, segment_idxs]);
    }

    static apply_idx_stack(id, idx_stack){
        // Applies the given index stack onto the RAL
        // Assumes the indexes are valid
        for(var i=idx_stack.length-1; i>=0; i--){
            if(idx_stack[i].length){
                this.get_node(id).idxs = idx_stack[i];
            }
            id = this.get_node(id).parent;
        }
    }

    static get_path(id, idx_stack, show_idx){
        if(typeof idx_stack === "undefined") idx_stack = null;
        if(typeof show_idx === "undefined") show_idx = true;

        // Get string representation of the hierarchical path
        if(show_idx && (idx_stack == null)){
            idx_stack = this.get_current_idx_stack(id);
        }
        var ids = this.get_ids_in_path(id);
        var pathparts = [];
        for(var i=0; i<ids.length; i++){
            var segment = this.get_node(ids[i]).name;
            if(show_idx && idx_stack[i].length){
                for(var dim=0; dim<idx_stack[i].length; dim++){
                    segment += "[" + idx_stack[i][dim] + "]";
                }
            }
            pathparts.push(segment);
        }

        return(pathparts.join("."));
    }

    static get_ids_in_path(id){
        // Get a list of ids that represent the path
        var ids = [];
        while(id !== null) {
            ids.unshift(id);
            id = this.get_node(id).parent;
        }
        return(ids);
    }

    static get_current_idx_stack(id){
        var idx_stack = [];
        while(id !== null) {
            if(this.is_array(id)){
                idx_stack.unshift(this.get_node(id).idxs);
            } else {
                idx_stack.unshift([]);
            }
            id = this.get_node(id).parent;
        }
        return(idx_stack);
    }

    static get_addr_offset(id){
        var node = this.get_node(id);
        if(this.is_array(id)){
            var flat_idx = 0;
            for(var i=0; i<node.idxs.length; i++){
                var sz = 1;
                for(var j=i+1; j<node.dims.length; j++){
                    sz *= node.dims[j];
                }
                flat_idx += sz * node.idxs[i];
            }
            return(node.offset + node.stride * BigInt(flat_idx));
        } else {
            return(node.offset);
        }
    }

    static get_absolute_addr(id){
        var node = this.get_node(id);
        if(node.parent != null){
            return(this.get_absolute_addr(node.parent) + this.get_addr_offset(id));
        } else {
            return(this.get_addr_offset(id));
        }
    }

    static get_total_size(id){
        var node = this.get_node(id);
        // Total size of entire array of this node
        if(this.is_array(id)){
            var num_elements = 1;
            for(var i=0; i<node.dims.length; i++){
                num_elements *= node.dims[i];
            }
            return(node.stride * BigInt(num_elements - 1) + node.size);
        }else{
            return(node.size);
        }
    }

    static lookup_by_address(addr, root_id){
        // Finds the deepest RAL node that contains addr
        // If found, returns:
        //  [id, idx_stack]
        // Otherwise, returns null
        if(typeof root_id === "undefined") root_id = 0;
        var id=root_id;
        var idx_stack = [];
        var iter_count = 0;

        if(addr < this.get_node(id).offset) return(null);
        if(addr >= (this.get_node(id).offset + this.get_total_size(id))) return(null);

        while(iter_count < 100){
            iter_count++;
            // addr is definitely inside this node

            // Adjust addr to be relative to this node
            addr = addr - this.get_node(id).offset;

            // Determine index stack entry for this node
            if(this.is_array(id)){
                var idxs = [];

                // First check if address lands between sparse array entries
                if((addr % this.get_node(id).stride) >= this.get_node(id).size) {
                    // missed! Give up and just return the parent node
                    if(this.get_node(id).parent == null){
                        return(null);
                    }else{
                        return([this.get_node(id).parent, idx_stack]);
                    }
                }

                // index of the flattened array
                var flat_idx = Number(addr / this.get_node(id).stride);

                // Re-construct dimensions
                for(var dim=this.get_node(id).dims.length-1; dim>=0; dim--){
                    var idx;
                    idx = flat_idx % this.get_node(id).dims[dim];
                    flat_idx = Math.floor(flat_idx / this.get_node(id).dims[dim]);
                    idxs.unshift(idx);
                }
                idx_stack.push(idxs);

                // Adjust addr offset to be relative to this index
                addr = addr % this.get_node(id).stride;
            } else {
                idx_stack.push([]);
            }

            // Search this node's children to see which child 'addr' is in
            var found_match = false;
            for(var i=0; i<this.get_node(id).children.length; i++) {
                var child = this.get_node(id).children[i];
                if((addr >= this.get_node(child).offset) && (addr < (this.get_node(child).offset + this.get_total_size(child)))){
                    // hit!
                    id = child;
                    found_match = true;
                    break;
                }
            }
            if(!found_match){
                // No further match. Current node is the result
                return([id, idx_stack]);
            }
        }

        // Hit iteration limit. Something is wrong :-(
        throw "Agh! iteration limit reached while looking up by address";
    }

    static lookup_field_idx(name) {
        var node = this.get_node(CurrentID);
        for(var i=0; i<node.fields.length; i++){
            if(name == node.fields[i].name){
                return(i);
            }
        }
        return(-1);
    }

    static get_node_uid(id) {
        var path = this.get_path(id, null, false);
        var uid = SHA1(path);
        return uid;
    }
}
