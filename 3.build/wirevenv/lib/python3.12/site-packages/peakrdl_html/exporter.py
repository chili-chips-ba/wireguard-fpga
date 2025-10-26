import os
import re
import time
import json
import math
import shutil
import hashlib
import xml.dom.minidom
from collections import OrderedDict
from typing import TYPE_CHECKING

import jinja2 as jj
import markdown
from gitmetheurl import GitMeTheURL

from systemrdl.node import FieldNode, Node, RootNode, AddressableNode, RegNode
from systemrdl.node import RegfileNode, AddrmapNode, MemNode, SignalNode
from systemrdl import rdltypes
from systemrdl.source_ref import FileSourceRef, DetailedFileSourceRef

from .stringify import stringify_rdl_value
from .search_indexer import SearchIndexer
from .__about__ import __version__

if TYPE_CHECKING:
    from typing import Any, Optional, Tuple, List, Dict, Union
    from systemrdl.source_ref import SourceRefBase

class HTMLExporter:
    def __init__(self, **kwargs: 'Any') -> None:
        """
        Constructor for the HTML exporter class

        Parameters
        ----------
        markdown_inst: ``markdown.Markdown``
            Override the class instance of the Markdown processor.
            See the `Markdown module <https://python-markdown.github.io/reference/#Markdown>`_
            for more details.
        user_template_dir: str
            Path to a directory where user-defined template overrides are stored.
        user_static_dir: str
            Path to user-defined static content to copy to output directory.
        user_context: dict
            Additional context variables to load into the template namespace.
        show_signals: bool
            Show signal components. Default is False
        extra_doc_properties: List[str]
            List of properties to explicitly document.
            Nodes that have a property explicitly set will show its value in a
            table in the node's description.
            Use this to bring forward user-defined properties, or other built-in
            properties in your documentation.
        """
        self.output_dir = "" # type: str
        self.RALData = [] # type: List[Dict[str, Any]]
        self.RootNodeIds = [] # type: List[int]
        self.current_id = -1
        self.footer = "" # type: str
        self.title = "" # type: str
        self.home_url = None # type: Optional[str]
        self.skip_not_present = True
        self.current_top_node = None # type: AddrmapNode

        self.user_static_dir = kwargs.pop("user_static_dir", None) # type: Optional[str]
        self.show_signals = kwargs.pop("show_signals", False)
        self.user_context = kwargs.pop("user_context", {})
        markdown_inst = kwargs.pop("markdown_inst", None) # type: Optional[markdown.Markdown]
        self.extra_properties = kwargs.pop("extra_doc_properties", []) # type: List[str]
        self.generate_source_links = kwargs.pop("generate_source_links", True)
        gmtu_translators = kwargs.pop("gitmetheurl_translators", None)
        user_template_dir = kwargs.pop("user_template_dir", None)

        # Check for stray kwargs
        if kwargs:
            raise TypeError("got an unexpected keyword argument '%s'" % list(kwargs.keys())[0])

        if markdown_inst is None:
            self.markdown_inst = markdown.Markdown(
                extensions = [
                    'extra',
                    'admonition',
                    'mdx_math',
                ],
                extension_configs={
                    'mdx_math':{
                        'add_preview': True,
                        'enable_dollar_delimiter': True,
                    }
                }
            )
        else:
            self.markdown_inst = markdown_inst

        if user_template_dir:
            loader = jj.ChoiceLoader([
                jj.FileSystemLoader(user_template_dir),
                jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates"))
            ]) # type: jj.BaseLoader
        else:
            loader = jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates"))

        self.jj_env = jj.Environment(
            loader=loader,
            autoescape=jj.select_autoescape(['html']),
            undefined=jj.StrictUndefined
        )

        self.gmtu = GitMeTheURL(gmtu_translators)

        self.indexer = None # type: SearchIndexer


    def export(self, nodes: 'Union[Node, List[Node]]', output_dir: str, **kwargs: 'Dict[str, Any]') -> None:
        """
        Perform the export!

        Parameters
        ----------
        nodes: systemrdl.Node
            Top-level node to export. Can be the top-level `RootNode` or any
            internal `AddrmapNode`. Can also be a list of `RootNode` and any
            internal `AddrmapNode`.
        output_dir: str
            HTML output directory.
        footer: str
            (optional) Override footer text.
        title: str
            (optional) Override title text.
        home_url: str
            (optional) If a URL is specified, adds a home button to return to a
            parent home page.
        skip_not_present: bool
            (optional) Control whether nodes with ispresent=false are generated.
            Default is True
        """

        # if not a list
        if not isinstance(nodes, list):
            nodes = [nodes]

        # If it is the root node, skip to top addrmap
        for i, node in enumerate(nodes):
            if isinstance(node, RootNode):
                nodes[i] = node.top

        self.footer = kwargs.pop("footer", "Generated by PeakRDL-html v%s" % __version__) # type: ignore
        self.title = kwargs.pop("title", "%s Reference" % nodes[0].get_property("name")) # type: ignore
        self.home_url = kwargs.pop("home_url", None) # type: ignore
        self.skip_not_present = kwargs.pop("skip_not_present", True) # type: ignore

        # Check for stray kwargs
        if kwargs:
            raise TypeError("got an unexpected keyword argument '%s'" % list(kwargs.keys())[0])

        self.output_dir = output_dir
        self.RALData = []
        self.current_id = -1
        self.indexer = SearchIndexer()

        # Copy static files
        static_dir = os.path.join(os.path.dirname(__file__), "static")
        copy_recursive(static_dir, self.output_dir)
        if self.user_static_dir:
            copy_recursive(self.user_static_dir, self.output_dir)

        # Make sure output directory structure exists
        os.makedirs(self.output_dir, exist_ok=True)
        os.makedirs(os.path.join(self.output_dir, "content"), exist_ok=True)
        os.makedirs(os.path.join(self.output_dir, "search"), exist_ok=True)
        os.makedirs(os.path.join(self.output_dir, "data"), exist_ok=True)

        # Traverse trees
        for node in nodes:
            self.current_top_node = node
            if node.get_property('bridge'):
                node.env.msg.warning(
                    "HTML generator does not have proper support for bridge addmaps yet. The 'bridge' property will be ignored.",
                    node.inst.property_src_ref.get('bridge', node.inst.inst_src_ref)
                )
            self.visit_addressable_node(node)

        # Write out RALData and other data
        self.write_ral_data()

        # Write main index.html
        self.write_index_page()

        # Write search index
        self.indexer.write_index_js(os.path.join(output_dir, "search"))


    def visit_addressable_node(self, node: Node, parent_id: 'Optional[int]'=None) -> int:
        self.current_id += 1
        this_id = self.current_id
        child_ids = [] # type: List[int]

        self.indexer.add_node(node, this_id)

        ral_entry = {
            'parent'    : parent_id,
            'children'  : child_ids,
            'name'      : node.inst.inst_name,
            'offset'    : BigInt(node.inst.addr_offset),
            'size'      : BigInt(node.size),
        }
        if node.inst.is_array:
            ral_entry['dims'] = node.inst.array_dimensions
            ral_entry['stride'] = BigInt(node.inst.array_stride)
            ral_entry['idxs'] = [0] * len(node.inst.array_dimensions)

        if isinstance(node, RegNode):
            ral_fields = []
            for i, field in enumerate(node.fields(skip_not_present=self.skip_not_present)):
                self.indexer.add_node(field, this_id, i)

                field_reset = field.get_property("reset", default=0)
                if isinstance(field_reset, Node):
                    # Reset value is a reference. Dynamic RAL data does not
                    # support this, so stuff a 0 in its place
                    field_reset = 0

                ral_field = {
                    'name' : field.inst.inst_name,
                    'lsb'  : field.inst.lsb,
                    'msb'  : field.inst.msb,
                    'reset': BigInt(field_reset),
                    'disp' : 'H'
                }

                field_enum = field.get_property("encode")
                if field_enum is not None:
                    ral_field['encode'] = True
                    ral_field['disp'] = 'E'

                ral_fields.append(ral_field)

            ral_entry['fields'] = ral_fields

        # Insert entry now to ensure proper position in list
        self.RALData.append(ral_entry)

        # Insert root nodes to list
        if parent_id is None:
            self.RootNodeIds.append(this_id)

        # Recurse to children
        children = OrderedDict()
        for child in node.children(skip_not_present=self.skip_not_present):
            if not isinstance(child, AddressableNode):
                continue
            child_id = self.visit_addressable_node(child, this_id)
            child_ids.append(child_id)
            children[child_id] = child

        # Generate page for this node
        self.write_page(this_id, node, children)

        return this_id


    def write_ral_data(self) -> None:
        N_RAL_NODES_PER_FILE = 16384
        n_files = math.ceil(len(self.RALData)/N_RAL_NODES_PER_FILE)

        # Write data index
        PageInfo = {
            "title" : self.title
        }
        path = os.path.join(self.output_dir, "data/data_index.js")
        with open(path, 'w', encoding='utf-8') as f:
            f.write("var N_RAL_FILES = %d;\n" % n_files)
            f.write("var N_RAL_NODES_PER_FILE = %d;\n" % N_RAL_NODES_PER_FILE)

            f.write("var RootNodeIds = ")
            f.write(PeakRDLJSEncoder(separators=(',', ':')).encode(self.RootNodeIds))
            f.write(";\n")

            f.write("var PageInfo = ")
            f.write(PeakRDLJSEncoder(separators=(',', ':')).encode(PageInfo))
            f.write(";\n")

        # Write RALData files
        for file_idx in range(n_files):
            start = file_idx * N_RAL_NODES_PER_FILE
            end = min((file_idx + 1) * N_RAL_NODES_PER_FILE, len(self.RALData))
            path = os.path.join(self.output_dir, "data/ral-data-%d.json" % file_idx)
            with open(path, 'w', encoding='utf-8') as f:
                f.write(PeakRDLJSEncoder(separators=(',', ':')).encode(self.RALData[start:end]))


    _template_map = {
        AddrmapNode : "addrmap.html",
        RegfileNode : "regfile.html",
        MemNode     : "mem.html",
        RegNode     : "reg.html",
    }

    def write_page(self, this_id: int, node: Node, children: 'Dict[int, Node]') -> None:

        view_source_url, view_source_filename= self.get_view_source_info(node)
        context = {
            'this_id': this_id,
            'node' : node,
            'children' : children,
            'has_description' : has_description,
            'friendly_access' : friendly_access,
            'has_enum_encoding' : has_enum_encoding,
            'get_enum_desc': self.get_enum_html_desc,
            'get_node_desc': self.get_node_html_desc,
            'get_child_addr_digits': self.get_child_addr_digits,
            'show_signals': self.show_signals,
            'has_extra_property_doc': self.has_extra_property_doc,
            'extra_properties': self.extra_properties,
            'stringify_rdl_value': stringify_rdl_value,
            'SignalNode' : SignalNode,
            'FieldNode': FieldNode,
            'AddressableNode': AddressableNode,
            'PropertyReference': rdltypes.PropertyReference,
            'reversed': reversed,
            'isinstance': isinstance,
            'list': list,
            'view_source_url': view_source_url,
            'view_source_filename': view_source_filename,
            'reg_fields_are_low_to_high': reg_fields_are_low_to_high,
            'skip_not_present': self.skip_not_present
        }
        context.update(self.user_context)

        uid = self.get_node_uid(node)

        template = self.jj_env.get_template(self._template_map[type(node)])
        stream = template.stream(context)
        output_path = os.path.join(self.output_dir, "content", "%s.html" % uid)
        stream.dump(output_path)


    def write_index_page(self) -> None:
        context = {
            'title': self.title,
            'footer_text': self.footer,
            'home_url': self.home_url,
            # propagate build timestamp to some URLs to force cache invalidation when rebuilt
            'build_ts': int(time.time()),
            'version': __version__,
        }
        context.update(self.user_context)

        template = self.jj_env.get_template("index.html")
        stream = template.stream(context)
        output_path = os.path.join(self.output_dir, "index.html")
        stream.dump(output_path)


    def get_child_addr_digits(self, node: AddressableNode) -> int:
        return math.ceil(math.log2(node.size) / 4)


    def get_node_html_desc(self, node: Node, increment_heading: int=0) -> 'Optional[str]':
        """
        Wrapper function to get HTML description
        If no description, returns None

        Performs the following transformations on top of the built-in HTML desc
        output:
        - Increment any heading tags
        - Transform img paths that point to local files. Copy referenced image to output
        """

        desc = node.get_html_desc(self.markdown_inst)
        if desc is None:
            return desc

        # Keep HTML semantically correct by promoting heading tags if desc ends
        # up as a child of existing headings.
        if increment_heading > 0:
            def heading_replace_callback(m: 're.Match') -> str:
                new_heading = "<%sh%d>" % (
                    m.group(1),
                    min(int(m.group(2)) + increment_heading, 6)
                )
                return new_heading
            desc = re.sub(r'<(/?)[hH](\d)>', heading_replace_callback, desc)

        # Transform image references
        # If an img reference points to a file on the local filesystem, then
        # copy it to the output and transform the reference
        if increment_heading > 0:
            def img_transform_callback(m: 're.Match') -> str:
                dom = xml.dom.minidom.parseString(m.group(0))
                img_src = dom.childNodes[0].attributes["src"].value

                if os.path.isabs(img_src):
                    # Absolute local path, or root URL
                    pass
                elif re.match(r'(https?|file)://', img_src):
                    # Absolute URL
                    pass
                else:
                    # Looks like a relative path
                    # See if it points to something relative to the source file
                    path = self.try_resolve_rel_path(node.inst.def_src_ref, img_src)
                    if path is not None:
                        img_src = path

                if os.path.exists(img_src):
                    with open(img_src, 'rb') as f:
                        md5 = hashlib.md5(f.read()).hexdigest()
                    new_path = os.path.join(
                        self.output_dir, "content",
                        "%s_%s" % (md5[0:8], os.path.basename(img_src))
                    )
                    shutil.copyfile(img_src, new_path)
                    dom.childNodes[0].attributes["src"].value = os.path.join(
                        "content",
                        "%s_%s" % (md5[0:8], os.path.basename(img_src))
                    )
                    return dom.childNodes[0].toxml()

                return m.group(0)

            desc = re.sub(r'<\s*img.*/>', img_transform_callback, desc)
        return desc


    def get_enum_html_desc(self, enum_member) -> str: # type: ignore
        s = enum_member.get_html_desc(self.markdown_inst)
        if s:
            return s
        else:
            return ""


    def try_resolve_rel_path(self, src_ref: 'Optional[SourceRefBase]', relpath: str) -> 'Optional[str]':
        """
        Test if the source reference's base path + the relpath points to a file
        If it works, returns the new path.
        If not, return None
        """

        if not isinstance(src_ref, FileSourceRef):
            return None

        path = os.path.join(os.path.dirname(src_ref.path), relpath)
        if not os.path.exists(path):
            return None

        return path


    def has_extra_property_doc(self, node: Node) -> bool:
        """
        Returns True if node has a property set that is to be explicitly
        documented.
        """
        for prop in self.extra_properties:
            if prop in node.list_properties():
                return True
        return False

    def get_view_source_info(self, node: Node) -> 'Tuple[Optional[str], Optional[str]]':
        """
        Attempt to derive the node definition's source code sharelink using
        GitMeTheURL.

        Returns None if not found
        """
        if not self.generate_source_links:
            return None, None

        src_ref = node.inst.def_src_ref or node.inst.inst_src_ref
        if isinstance(src_ref, DetailedFileSourceRef):
            path = src_ref.path
            line = src_ref.line
        elif isinstance(src_ref, FileSourceRef):
            path = src_ref.path
            line = None
        else:
            return None, None

        # resolve any symlinks to ensure true git path
        path = os.path.realpath(path)

        try:
            return (self.gmtu.get_source_url(path, line), os.path.basename(path))
        except Exception: # pylint: disable=broad-except
            return None, None

    def get_node_uid(self, node: Node) -> str:
        """
        Returns the node's UID string
        """
        node_path = node.get_rel_path(self.current_top_node.parent, array_suffix="", empty_array_suffix="")
        path_hash = hashlib.sha1(node_path.encode('utf-8')).hexdigest()
        return path_hash


def has_description(node: Node) -> bool:
    """
    Test if node has a description defined
    """
    return "desc" in node.list_properties()

def friendly_access(obj: 'Any') -> str:
    """
    Convert access types into a human-friendly string
    """
    lut = {
        rdltypes.AccessType.na      : "Not Accessible",
        rdltypes.AccessType.rw      : "Readable and Writable",
        rdltypes.AccessType.r       : "Read-only",
        rdltypes.AccessType.w       : "Write-only",
        rdltypes.AccessType.rw1     : "Readable. Writable once.",
        rdltypes.AccessType.w1      : "Writable once",
        rdltypes.OnReadType.rclr    : "Clear on read",
        rdltypes.OnReadType.rset    : "Set on read",
        rdltypes.OnWriteType.woset  : "Bitwise write 1 to set",
        rdltypes.OnWriteType.woclr  : "Bitwise write 1 to clear",
        rdltypes.OnWriteType.wot    : "Bitwise write 1 to toggle",
        rdltypes.OnWriteType.wzs    : "Bitwise write 0 to set",
        rdltypes.OnWriteType.wzc    : "Bitwise write 0 to clear",
        rdltypes.OnWriteType.wzt    : "Bitwise write 0 to toggle",
        rdltypes.OnWriteType.wclr   : "Clear on write",
        rdltypes.OnWriteType.wset   : "Set on write",
    }
    return lut.get(obj, "")


def has_enum_encoding(field: FieldNode) -> bool:
    """
    Test if field is encoded with an enum
    """
    return "encode" in field.list_properties()


def reg_fields_are_low_to_high(node: RegNode) -> bool:
    for field in node.fields():
        if field.msb < field.lsb:
            return True
    return False

def copy_recursive(src: str, dst: str) -> None:
    """
    distutils.dir_util.copy_tree is deprecated, and shutil.copytree does not have
    the dirs_exist_ok option until py3.8.
    Implement an equivalent
    """
    os.makedirs(dst, exist_ok=True)

    for entry in os.listdir(src):
        spath = os.path.join(src, entry)
        dpath = os.path.join(dst, entry)
        if os.path.isdir(spath):
            copy_recursive(spath, dpath)
        else:
            shutil.copyfile(spath, dpath)


class BigInt:
    def __init__(self, v: int):
        self.v = v

class PeakRDLJSEncoder(json.JSONEncoder):
    def default(self, o: 'Any') -> str: # pylint: disable=method-hidden
        if isinstance(o, BigInt):
            # store bigInt integers as hex string. JS will convert to bigInt objects post-load.
            return "%x" % o.v
        else:
            return super().default(o)
