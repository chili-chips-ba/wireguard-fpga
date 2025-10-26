// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

class ContentSearch {
    static #MAX_RESULTS = 25;
    static #ITER_BREAK_INTERVAL = 1000;
    static #PREVIEW_MAX_RUN_LENGTH = 200;
    static #bucket_files = new Array(SearchBucketIndex.length).fill(null);

    static async start(query, abortSignal){
        var keywords = this.#get_query_words(query);

        // determine which bucket files need to be fetched, if any
        // Discard any keywords definitely not in the index
        var bidxs_to_fetch = new Set();
        var filtered_keywords = [];
        for(var i=0; i<keywords.length; i++) {
            var prefix = keywords[i].slice(0,3);
            var bidx = this.#get_bucket_file_idx(prefix);
            if(bidx == null) {
                // keyword is definitely not in the index.
                continue;
            }
            filtered_keywords.push(keywords[i]);
            if(this.#bucket_files[bidx] == null) bidxs_to_fetch.add(bidx);
        }
        if(filtered_keywords.length == 0) return;
        bidxs_to_fetch = Array.from(bidxs_to_fetch);

        // Launch all fetches in parallel and wait for them to return
        var fetches = [];
        for(var i=0; i<bidxs_to_fetch.length; i++) {
            fetches.push(this.#fetch_bucket_file(bidxs_to_fetch[i]));
        }
        await Promise.all(fetches);
        if(abortSignal.aborted) return;

        var matches = await this.#get_matches(filtered_keywords, abortSignal);
        if(abortSignal.aborted) return;

        // Fetch preview text for top matches
        var preview_text_fetches = [];
        for(var i=0; i<matches.length && i<this.#MAX_RESULTS; i++) {
            // Launch fetch operation and store awaitable for later
            preview_text_fetches.push(this.#fetch_match_preview_text(matches[i]));
        }

        // Display matches.
        for(var i=0; i<preview_text_fetches.length; i++){
            // wait for preview text fetch to complete
            var preview_text = await preview_text_fetches[i];
            if(abortSignal.aborted) return;

            // Prepare result entry
            var result_id = matches[i].page_id;
            var path = RAL.get_path(result_id, null, false);
            var anchor = "";
            if(matches[i].is_field){
                path = path + "." + matches[i].field_name;

                if(matches[i].is_name){
                    anchor = matches[i].field_name;
                } else {
                    anchor = matches[i].field_name + ".desc";
                }
            }
            var text_segments = [path];

            add_search_result(
                text_segments,
                result_id,
                null,
                anchor,
                preview_text
            );
        }
    }


    static #get_query_words(query){
        // Normalize query to lowercase
        query = query.toLowerCase();

        // Replace non-word characters w spaces
        query = query.replace(/[^\w]/g, " ");

        // Split words
        var words = query.split(" ");

        // sanitize
        var keywords = new Set();
        for(var i=0; i<words.length; i++){
            if(words[i].length < 3) continue;
            keywords.add(words[i]);

            // If a word contains underscores, submit the individual segments too
            var subwords = words[i].split("_");
            if(subwords.length >= 2){
                for(var j=0; j<subwords.length; j++){
                    if(subwords[j].length < 3) continue;
                    keywords.add(subwords[j]);
                }
            }
        }

        return(Array.from(keywords));
    }


    static #get_bucket_file_idx(prefix) {
        var shorthash = parseInt("0x" + SHA1(prefix).slice(-7))

        for(var i=0; i<SearchBucketIndex.length; i++){
            if(shorthash <= SearchBucketIndex[i]) {
                return(i);
            }
        }
        return(null);
    }

    static async #fetch_bucket_file(bidx) {
        var path = "search/bkt-" + bidx + ".json?ts=" + BUILD_TS;

        var awaitable = fetch(path)
            .then(response => {
                if(!response.ok){
                    throw new Error("fetch failed");
                }
                return response.json();
            })
            .then(data => {
                this.#bucket_files[bidx] = data;
            });
        return awaitable;
    }


    static async #get_matches(keywords, abortSignal){

        // Find locations of matching keywords
        var match_list = [];
        var match_hashtable = {};
        var itercount = 0;
        for(var i=0; i<keywords.length; i++){
            itercount++;

            // Get word bucket from index
            var prefix = keywords[i].slice(0,3);
            var bidx = this.#get_bucket_file_idx(prefix);
            var words = this.#bucket_files[bidx][prefix];
            if(words == undefined){
                // Prefix is not in the index. No match
                continue;
            }

            // Linear search through candidate words in bucket
            for(var widx=0; widx<words.length; widx++){
                itercount++;

                var word = words[widx][0];
                var locations = words[widx][1];

                if(word.startsWith(keywords[i])) {
                    // Found keyword match!
                    var is_exact_match = (word == keywords[i]);

                    // Update matches list with all the locations associated with this word
                    for(var lidx = 0; lidx < locations.length; lidx++) {
                        itercount++;
                        if(itercount % this.#ITER_BREAK_INTERVAL == (this.#ITER_BREAK_INTERVAL-1)){
                            // Occasionally insert break to allow other events to continue
                            await take_a_break();
                            if(abortSignal.aborted) return;
                        }

                        var m = new ContentSearchMatch(locations[lidx]);

                        // Try to merge with existing match
                        var loc_key = m.get_location_key();
                        if(loc_key in match_hashtable){
                            if(is_exact_match) {
                                match_hashtable[loc_key].full_match_keywords.add(keywords[i]);
                            } else {
                                match_hashtable[loc_key].partial_match_keywords.add(keywords[i]);
                            }

                            // favor non-name matches
                            if(!m.is_name) match_hashtable[loc_key].is_name = false;
                        } else {
                            // nope. new match location
                            if(is_exact_match) {
                                m.full_match_keywords.add(keywords[i]);
                            } else {
                                m.partial_match_keywords.add(keywords[i]);
                            }
                            match_hashtable[loc_key] = m;
                            match_list.push(m);
                        }
                    }
                }
            }
        }
        await take_a_break();
        if(abortSignal.aborted) return;

        // Filter out matches that did not succeed in matching ALL keywords
        var filtered_match_list = [];
        for(var midx=0; midx<match_list.length; midx++){
            var kw_set = new Set(keywords);
            if(difference(kw_set, match_list[midx].get_matched_keywords()).size == 0){
                filtered_match_list.push(match_list[midx]);
            }
        }
        match_list = filtered_match_list;

        // Sort results by match score
        match_list.sort((a, b) => {
            return a.compare_rank_to(b);
        });

        return match_list;
    }


    static async #fetch_match_preview_text(match){
        return fetch_page_content(match.page_id).then(text => {
            var dp = new DOMParser();
            var doc = dp.parseFromString(text, "text/html");

            // Prune out the element that is most relevant to the content match
            var el;
            var el_id;
            if(match.is_field) {
                if(match.is_name) {
                    // use field's row in table, since it contains the name
                    el_id = match.field_name;
                } else {
                    // field's description block
                    el_id = "_Content." + match.field_name + ".desc";
                }
            } else {
                // Not a field
                if(match.is_name) {
                    // Use page title
                    el_id = "_Content.name";
                } else {
                    // main description block
                    el_id = "_Content.desc";
                }
            }
            var el = doc.getElementById(el_id);

            // strip HTML tags
            text = el.textContent;

            // Reduce excess whitespace
            text = text.replace(/\s+/g, " ");

            // Mark all keywords in content
            var keywords = Array.from(new Set([...match.full_match_keywords, ...match.partial_match_keywords]));
            var regex = new RegExp("(?:\\b|_)(" + keywords.join("|") + ")", "ig");
            var marked_text = "";
            var prev_idx = 0;
            for (const m of text.matchAll(regex)) {
                var m_idx = m.index;

                // advance match past underscore if it is in match
                if(text[m_idx] == "_") m_idx += 1;

                // Pass through prior segment
                if(prev_idx < m_idx) {
                    var unmarked_segment = text.slice(prev_idx, m_idx);
                    if(unmarked_segment.length > this.#PREVIEW_MAX_RUN_LENGTH) {
                        // shorten the segment
                        if(marked_text == ""){
                            // is first
                            unmarked_segment = this.#shorten_text_first(unmarked_segment);
                        } else {
                            // is middle
                            unmarked_segment = this.#shorten_text_middle(unmarked_segment);
                        }
                    }
                    marked_text += unmarked_segment;
                }

                // highlight segment
                marked_text += "<mark>" + m[1] + "</mark>";
                prev_idx = m_idx + m[1].length;
            }

            if(prev_idx < text.length){
                // pass through last unmarked segment
                var unmarked_segment = text.slice(prev_idx, text.index);
                if(unmarked_segment.length > this.#PREVIEW_MAX_RUN_LENGTH) {
                    // shorten the segment
                    unmarked_segment = this.#shorten_text_last(unmarked_segment);
                }
                marked_text += unmarked_segment;
            }

            return marked_text;
        });
    }

    static #shorten_text_first(text){
        var L = this.#PREVIEW_MAX_RUN_LENGTH;
        return "\u22ef" + text.slice(text.length - L, text.length);
    }

    static #shorten_text_middle(text){
        var L = this.#PREVIEW_MAX_RUN_LENGTH;
        return text.slice(0, L/2) + "\u22ef \u22ef" + text.slice(text.length - L/2, text.length);
    }

    static #shorten_text_last(text){
        var L = this.#PREVIEW_MAX_RUN_LENGTH;
        return text.slice(0, L) + "\u22ef";
    }
}


class ContentSearchMatch {
    constructor(location_entry){
        this.full_match_keywords = new Set();
        this.partial_match_keywords = new Set();
        this.page_id = location_entry[0];

        var location_code = location_entry[1];
        this.is_name = Boolean(location_code & 0x1);
        this.is_enum = Boolean(location_code & 0x4);
        this.is_field = Boolean(location_code & 0x2);
        if(this.is_field){
            var field_idx = (location_code >> 3);
            this.field_name = RAL.get_node(this.page_id).fields[field_idx].name;
        } else {
            this.field_name = null;
        }
    }

    get_location_key(){
        // unique key that represents mergeable match location
        return String([this.page_id, this.field_name]);
    }

    get_matched_keywords(){
        return new Set([...this.full_match_keywords, ...this.partial_match_keywords]);
    }

    compare_rank_to(other){
        // +1: other has higher rank than this
        // -1: other has lower rank than this
        // 0: Other is the same rank
        var this_merged_keywords = this.get_matched_keywords();
        var other_merged_keywords = other.get_matched_keywords();

        // Total number of matching keywords is most important
        if(this_merged_keywords.size < other_merged_keywords.size) return 1;
        if(this_merged_keywords.size > other_merged_keywords.size) return -1;

        // then whichever has more full matches
        if(this.full_match_keywords.size < other.full_match_keywords.size) return 1;
        if(this.full_match_keywords.size > other.full_match_keywords.size) return -1;

        // then whichever has more partial matches
        if(this.partial_match_keywords.size < other.partial_match_keywords.size) return 1;
        if(this.partial_match_keywords.size > other.partial_match_keywords.size) return -1;

        return 0;
    }
}
