import re
import os
import subprocess
import json
import shutil
from typing import TYPE_CHECKING, List, Optional, Tuple, Dict, Any

from . import segment_map
from .verilog_preprocessor import get_illegal_trailing_text_pos
from ..source_ref import DirectSourceRef, FileSourceRef

if TYPE_CHECKING:
    from typing import Set
    from ..compiler import RDLEnvironment

class PerlPreprocessor:

    def __init__(self, env: 'RDLEnvironment', path: str, search_paths: List[str], incl_ref: Optional[segment_map.IncludeRef]=None):
        self.env = env
        self.path = path
        self.search_paths = search_paths
        self.incl_ref = incl_ref

        with open(path, 'r', newline='', encoding='utf_8') as f:
            self.text = f.read()

        self.included_files: Set[str] = set()

    #---------------------------------------------------------------------------
    def preprocess(self) -> Tuple[str, segment_map.SegmentMap]:
        """
        Run preprocessor on a top-level file.

        Performs the following preprocess steps:

        - Expand `include directives
        - Perl Preprocessor

        Returns
        -------
        tuple
            (preprocessed_text, SegmentMap)
        """
        tokens = self.tokenize()
        pl_segments, has_perl_tags = self.get_perl_segments(tokens)

        # Generate flattened output
        str_parts = []
        smap = segment_map.SegmentMap()
        offset = 0

        if has_perl_tags:
            # Needs to be processed through perl interpreter
            emit_list = self.run_perl_miniscript(pl_segments)

            for entry in emit_list:
                if entry['type'] == "ref":
                    pl_seg = pl_segments[entry['ref']]
                    emit_text = pl_seg.get_text()

                    ref_seg = segment_map.UnalteredSegment(
                        offset, offset + len(emit_text) - 1,
                        pl_seg.start, pl_seg.end, pl_seg.file_pp.path,
                        pl_seg.file_pp.incl_ref
                    )
                    offset += len(emit_text)
                    smap.segments.append(ref_seg)
                    str_parts.append(emit_text)

                elif entry['type'] == "text":
                    pl_seg = pl_segments[entry['ref']]
                    emit_text = entry['text']

                    macro_seg = segment_map.MacroSegment(
                        offset, offset + len(emit_text) - 1,
                        pl_seg.start, pl_seg.end, pl_seg.file_pp.path,
                        pl_seg.file_pp.incl_ref
                    )
                    offset += len(emit_text)
                    smap.segments.append(macro_seg)
                    str_parts.append(emit_text)
        else:
            # OK to bypass perl interpreter
            for pl_seg in pl_segments:
                emit_text = pl_seg.get_text()
                map_seg = segment_map.UnalteredSegment(
                    offset, offset + len(emit_text) - 1,
                    pl_seg.start, pl_seg.end, pl_seg.file_pp.path,
                    pl_seg.file_pp.incl_ref
                )
                offset += len(emit_text)
                smap.segments.append(map_seg)
                str_parts.append(emit_text)

        return ("".join(str_parts), smap)

    #---------------------------------------------------------------------------
    def tokenize(self) -> List[Tuple[str, int, int]]:
        """
        Tokenize the input text

        Scans for instances of perl tags and include directives.
        Tokenization skips line and block comments.

        Returns
        -------
        list
            List of tuples: (typ, start, end)

            Where:

            - typ is "perl" or "incl"
            - start/end mark the first/last char offset of the token
        """
        tokens = []
        token_spec = [
            ('mlc', r'/\*.*?\*/'),
            ('slc', r'//.*?$'),
            ('perl', r'<%.*?%>'),
            ('incl', r'`include'),
        ]
        tok_regex = '|'.join('(?P<%s>%s)' % pair for pair in token_spec)
        for m in re.finditer(tok_regex, self.text, re.DOTALL | re.MULTILINE):
            if m.lastgroup in ("incl", "perl"):
                tokens.append((m.lastgroup, m.start(0), m.end(0)-1))
        return tokens

    #---------------------------------------------------------------------------
    def parse_include(self, start: int) -> Tuple[int, str]:
        """
        Extract include from text based on start position of token

        Returns
        -------
        (end, incl_path)
            - end: last char in include
            - incl_path: Resolved path to include
        """
        # Seek back to start of line
        i = start
        while i:
            if self.text[i] == '\n':
                i += 1
                break
            i -= 1
        line_start = i

        # check that there is no unexpected text before the include
        if not (self.text[line_start:start] == "" or self.text[line_start:start].isspace()):
            self.env.msg.fatal(
                "Unexpected text before include",
                DirectSourceRef(self.path, line_start, start-1)
            )

        # Capture include contents
        inc_regex = re.compile(r'`include\s+("([^\r\n]+)"|<([^\r\n]+)>)')
        m_inc = inc_regex.match(self.text, start)
        if m_inc is None:
            self.env.msg.fatal(
                "Invalid usage of include directive",
                DirectSourceRef(self.path, start, start+7)
            )
        incl_path_raw = m_inc.group(2) or m_inc.group(3)
        end = m_inc.end(0)-1
        path_start = m_inc.start(1)

        # Check that only comments follow
        cruft_start, cruft_end = get_illegal_trailing_text_pos(self.text, end+1)
        if cruft_start is not None and cruft_end is not None:
            self.env.msg.fatal(
                "Unexpected text after include",
                DirectSourceRef(self.path, cruft_start, cruft_end)
            )

        # Resolve include path.
        if os.path.isabs(incl_path_raw):
            incl_path = incl_path_raw
        else:
            # Search include paths first.
            for search_path in self.search_paths:
                incl_path = os.path.join(search_path, incl_path_raw)
                if os.path.isfile(incl_path):
                    # found match!
                    break
            else:
                # Otherwise, assume it is relative to the current file
                incl_path = os.path.join(os.path.dirname(self.path), incl_path_raw)
        if not os.path.isfile(incl_path):
            self.env.msg.fatal(
                "Could not find '%s' in include search paths" % incl_path_raw,
                DirectSourceRef(self.path, path_start, end)
            )

        # Check if path has already been referenced before
        incl_ref = self.incl_ref
        while incl_ref:
            if os.path.samefile(incl_path, incl_ref.path):
                self.env.msg.fatal(
                    "Include of '%s' results in a circular reference" % incl_path_raw,
                    DirectSourceRef(self.path, path_start, end)
                )
            incl_ref = incl_ref.parent

        return(end, incl_path)

    #---------------------------------------------------------------------------
    def get_perl_segments(self, tokens: List[Tuple[str, int, int]]) -> Tuple[List['PPPSegment'], bool]:
        """
        Build a list of perl preprocessor segments:
            PPPUnalteredSegment
            PPPPerlSegment
            PPPMacroSegment
        returns:
            (pl_segments, has_perl_tags)
        """
        pl_segments: List[PPPSegment] = []
        has_perl_tags = False
        pos = 0

        for typ, start, end in tokens:

            # Capture any leading text
            if start != pos:
                pl_seg: PPPSegment = PPPUnalteredSegment(self, pos, start - 1)
                pl_segments.append(pl_seg)

            if typ == "incl":
                # Got an `include ...

                # Extract the path and actual end position
                end, incl_path = self.parse_include(start)

                # create a reference that captures the location where the include occurred
                incl_ref = segment_map.IncludeRef(start, end, self.path, self.incl_ref)


                # Recurse and extract perl segments from included file
                incl_file_pp = PerlPreprocessor(self.env, incl_path, self.search_paths, incl_ref)
                incl_tokens = incl_file_pp.tokenize()
                incl_pl_segments, incl_has_pl_tags = incl_file_pp.get_perl_segments(incl_tokens)

                self.included_files.add(incl_path)
                self.included_files.update(incl_file_pp.included_files)
                pl_segments.extend(incl_pl_segments)
                has_perl_tags = has_perl_tags or incl_has_pl_tags

            else:
                # Got a Perl tag <% ... %>
                if self.text[start+2] == "=":
                    pl_seg = PPPMacroSegment(self, start, end)
                else:
                    pl_seg = PPPPerlSegment(self, start, end)
                pl_segments.append(pl_seg)
                has_perl_tags = True

            pos = end+1

        # Capture any trailing text
        text_len = len(self.text)
        if text_len > pos:
            pl_seg = PPPUnalteredSegment(self, pos, text_len-1)
            pl_segments.append(pl_seg)

        return (pl_segments, has_perl_tags)

    #---------------------------------------------------------------------------
    def run_perl_miniscript(self, segments: List['PPPSegment']) -> List[Dict[str, Any]]:
        """
        Generates and runs a perl miniscript that derives the text that will be
        emitted from the preprocessor

        returns the resulting emit list
        """

        # Check if perl is installed
        if shutil.which("perl") is None:
            self.env.msg.fatal(
                "Input contains Perl preprocessor tags, but an installation of Perl could not be found"
            )

        # Generate minimal perl script that captures activities described in the source file
        lines = []
        for i, pp_seg in enumerate(segments):
            if isinstance(pp_seg, PPPUnalteredSegment):
                # Text outside preprocessor tags that should remain unaltered
                # Insert command to emit reference to this text segment
                lines.append("rdlppp_utils::emit_ref(%d);" % i)

            elif isinstance(pp_seg, PPPPerlSegment):
                # Perl code snippet. Insert directly
                lines.append(pp_seg.get_text())

            elif isinstance(pp_seg, PPPMacroSegment):
                # Preprocessor macro print tag
                # Insert command to store resulting text
                var = pp_seg.get_text()

                # Check for any illegal characters
                if re.match(r'[\s;]', var):
                    self.env.msg.fatal(
                        "Invalid text found in Perl macro expansion",
                        DirectSourceRef(self.path, pp_seg.start, pp_seg.end)
                    )

                lines.append("rdlppp_utils::emit_text(%d, %s);" % (i, var))
        miniscript = '\n'.join(lines)

        # Run miniscript
        runner_path = os.path.join(os.path.dirname(__file__), "ppp_runner.pl")
        result = subprocess.run(
            ["perl", runner_path, ",".join(self.env.perl_safe_opcodes)],
            input=miniscript.encode("utf-8"),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            timeout=5, check=False
        )
        if result.returncode:
            self.env.msg.fatal(
                "Encountered a Perl syntax error while executing embedded Perl preprocessor commands:\n"
                + result.stderr.decode("utf-8"),
                # TODO: Fix useless context somehow
                FileSourceRef(self.path)
            )

        # miniscript returns the emit list in JSON format. Convert it
        emit_list = json.loads(result.stdout.decode('utf-8'))

        return emit_list

#-------------------------------------------------------------------------------

class PPPSegment:
    def __init__(self, file_pp: PerlPreprocessor, start: int, end: int):
        self.file_pp = file_pp
        self.start = start
        self.end = end

    def get_text(self) -> str:
        return self.file_pp.text[self.start:self.end+1]

class PPPUnalteredSegment(PPPSegment):
    pass

class PPPPerlSegment(PPPSegment):
    def get_text(self) -> str:
        return self.file_pp.text[self.start+2:self.end-1]

class PPPMacroSegment(PPPSegment):
    def get_text(self) -> str:
        return self.file_pp.text[self.start+3:self.end-1]
