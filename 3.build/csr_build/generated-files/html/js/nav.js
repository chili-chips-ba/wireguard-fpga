// This file is part of PeakRDL-html <https://github.com/SystemRDL/PeakRDL-html>.
// and can be redistributed under the terms of GNU GPL v3 <https://www.gnu.org/licenses/>.

async function load_page(id) {
    var awaitable = fetch_page_content(id);
    awaitable.then(text => {
        // Page loaded successfully
        CurrentID = id;
        update_crumbtrail();

        var main_el = document.getElementById("_ContentContainer");
        main_el.innerHTML = text;
        update_absolute_addr();
        update_rdlfc_indexes();
        if(RAL.is_register(id)) {
            init_reg_value();
            init_radix_buttons();
        }
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        userHooks.onContentLoad();
    });

    return awaitable;
}

async function fetch_page_content(id){
    var path = "content/" + RAL.get_node_uid(id) + ".html?ts=" + BUILD_TS;
    var awaitable = fetch(path)
        .then(response => {
            if(!response.ok){
                throw new Error("page fetch failed");
            }
            return response.text();
        });
    return awaitable;
}

async function load_page_via_url(){
    // An event triggered such that the page should be loaded based on the URL
    var prev_id = CurrentID;

    var url = new URL(window.location.href);
    var path = url.searchParams.get("p", path);
    var parsed_path = RAL.parse_path(path);
    var new_path;
    if(parsed_path == null) {
        // Bad path. Discard it
        new_path = "";
        CurrentID = 0;
    } else {
        // Path is good.
        var id, idx_stack;
        id = parsed_path[0];
        idx_stack = parsed_path[1];
        RAL.apply_idx_stack(id, idx_stack);

        // Recompute the path in case it needs to be cleaned up
        new_path = RAL.get_path(id);
        CurrentID = id;
    }

    if(path != new_path){
        // Path was sanitized. Patch URL
        url.searchParams.set("p", new_path);
        window.history.replaceState({}, "", url.toString())
    }

    if(prev_id != CurrentID) {
        await load_page(CurrentID).then(() => {
            Sidebar.expand_to_id(CurrentID);
            Sidebar.select_node(CurrentID);
            Sidebar.scroll_into_view(CurrentID);
            refresh_title();
            refresh_target_scroll();
        });
    } else {
        refresh_target_scroll();
    }
}

function load_page_via_path(path, url_hash){
    if(typeof url_hash === "undefined") url_hash = "";
    var prev_path = RAL.get_path(CurrentID);
    var prev_url_hash = window.location.hash;
    var parsed_path = RAL.parse_path(path);
    var new_path;
    if(parsed_path == null) {
        // Bad path. Give up
        return
    } else {
        // Path is good.
        var id, idx_stack;
        id = parsed_path[0];
        idx_stack = parsed_path[1];
        RAL.apply_idx_stack(id, idx_stack);

        // Recompute the path in case it needs to be cleaned up
        new_path = RAL.get_path(id);
        RAL.reset_indexes_to_next(id);
        CurrentID = id;
    }

    if(prev_path != new_path) {
        load_page(CurrentID).then(() => {
            Sidebar.expand_to_id(CurrentID);
            Sidebar.select_node(CurrentID);
            Sidebar.scroll_into_view(CurrentID);
            refresh_url(url_hash);
            refresh_title();
            refresh_target_scroll();
        });
    } else if (prev_url_hash != url_hash){
        refresh_url(url_hash);
        refresh_target_scroll();
    }
}


function onClickNodeLink(ev) {
    var el = ev.target;
    var id = parseInt(el.dataset.id);
    if(id == CurrentID) return(false);

    RAL.reset_indexes_to_next(id);
    load_page(id).then(() => {
        Sidebar.expand_to_id(id);
        Sidebar.select_node(id);
        Sidebar.scroll_into_view(id);
        refresh_url();
        refresh_title();
        refresh_target_scroll();
    });

    return(false);
}

function onClickPathLink(ev) {
    var el = ev.target;
    var path = el.dataset.path;
    var url_hash = el.dataset.url_hash;

    load_page_via_path(path, url_hash);

    return(false);
}

function load_parent_page(){
    var id = RAL.get_node(CurrentID).parent;
    if(id == null) return;
    load_page(id).then(() => {
        Sidebar.expand_to_id(id);
        Sidebar.select_node(id);
        Sidebar.scroll_into_view(id);
        refresh_url();
        refresh_title();
        refresh_target_scroll();
    });
}

function refresh_url(url_hash) {
    // Given current state, refresh the URL
    if(typeof url_hash === "undefined") url_hash = "";
    var path = RAL.get_path(CurrentID);

    var url = new URL(window.location.href);
    url.searchParams.set("p", path);
    url.hash = url_hash;
    window.history.pushState({}, "", url.toString())
}

function patch_url_path() {
    // refresh only the URL's hier path without affecting history
    var path = RAL.get_path(CurrentID);
    var url = new URL(window.location.href);
    url.searchParams.set("p", path);
    window.history.replaceState({}, "", url.toString())
}

function refresh_title() {
    // Given current state, refresh the page title text
    document.title = RAL.get_node(CurrentID).name + " \u2014 " + PageInfo.title;
}

function onPopState(event) {
    load_page_via_url();
}

function refresh_target_scroll() {
    // Manually implement scroll to hash targets since AJAX-based page loads
    // make the normal mechanism a little unreliable

    // Clear any target-highlight elements
    var target_els = document.getElementsByClassName("target-highlight");
    for(var i=target_els.length-1; i>=0; i--){
        target_els[i].classList.remove("target-highlight");
    }

    if(window.location.hash){
        // URL has hash! Scroll to it and apply highlight class
        var el = document.getElementById(window.location.hash.slice(1));
        if(el){
            el.scrollIntoView();
            el.classList.add("target-highlight");
        }

    } else {
        document.getElementById("_Content").parentElement.scrollTop = 0;
    }
}
