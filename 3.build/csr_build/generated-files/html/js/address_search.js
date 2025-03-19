// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

class AddressSearch {
    static start(query){
        query = query.slice(1, query.length);
        if(query == "") return;

        var addr;
        try {
            addr = BigInt(query);
        } catch(error) {
            addr = -1n;
        }

        if(addr < 0) return;

        RootNodeIds.forEach(function(id) {
            var result = RAL.lookup_by_address(addr, id);
            if(result != null) {
                var result_id = result[0];
                var idx_stack = result[1];
                var text_segments = [RAL.get_path(result_id, idx_stack)];

                add_search_result(
                    text_segments,
                    result_id,
                    idx_stack
                );
            }
        });
    }
}
