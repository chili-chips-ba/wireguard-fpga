// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

class PathSearch {
    static #MAX_RESULTS = 100;
    static #SEARCH_CHOMP_SIZE = 100;

    static async start(query, abortSignal){
        if(query.length < 2) return;

        // Sanitize query
        var sp_query = query.split(" ");
        var keywords = [];
        for(var i=0; i<sp_query.length; i++){
            if(sp_query[i] == "") continue;
            keywords.push(sp_query[i]);
        }

        var match_count = 0;
        for(var id=0; id<RAL.number_of_ids(); id++){
            var path = RAL.get_path(id, null, false);

            if(id % this.#SEARCH_CHOMP_SIZE == (this.#SEARCH_CHOMP_SIZE-1)){
                // Occasionally insert break to allow other events to continue
                await take_a_break();
                if(abortSignal.aborted) return;
            }

            // Search regular path
            var text_segments = this.#test_path(path, keywords);
            if(text_segments != null){
                // direct node path matched
                add_search_result(text_segments, id);
                match_count++;
            } else {
                // No match yet. If this node has fields, add them to the path and try that
                if(RAL.is_register(id)){
                    var node = RAL.get_node(id);
                    for(var i=0; i<node.fields.length; i++){
                        var path_with_field = path + "." + node.fields[i].name;
                        text_segments = this.#test_path(path_with_field, keywords);
                        if(text_segments != null){
                            add_search_result(text_segments, id, null, node.fields[i].name);
                            match_count++;
                        }
                    }
                }
            }

            if(match_count >= this.#MAX_RESULTS) {
                break;
            }
        }
    }

    static #test_path(path, keywords){
        // If match, returns text_segments.
        // Otherwise, null
        var path_lc = path.toLowerCase();
        var text_segments = [];
        var start = 0;

        // Scan path to see if all keywords match
        for(var i=0; i<keywords.length; i++){
            var result = path_lc.indexOf(keywords[i], start);
            if(result < 0){
                // Did not match
                return(null);
            }

            // matched!
            // extract non-highlighted text before
            text_segments.push(path.slice(start, result));
            // highlighted text
            text_segments.push(path.slice(result, result + keywords[i].length));

            // move search start for next keyword
            start = result + keywords[i].length;
        }

        text_segments.push(path.slice(start, path.length));
        return(text_segments);
    }
}
