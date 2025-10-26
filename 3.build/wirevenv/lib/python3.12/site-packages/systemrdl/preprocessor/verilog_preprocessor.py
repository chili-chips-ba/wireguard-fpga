import re
from typing import List, Union, Tuple, TYPE_CHECKING, Optional, Match, Dict

from ..source_ref import SourceRefBase, SegmentedSourceRef
from . import segment_map

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment

class VerilogPreprocessor:
    def __init__(self, env: 'RDLEnvironment', text: str, src_seg_map: Optional[segment_map.SegmentMap]=None, src_ref_override: Optional[SourceRefBase]=None, defines: Optional[Dict[str,str]]=None):
        self.env = env

        # Unprocessed text
        self._text = text

        # Top-level preprocessing pass requires the segment map in order to
        # generate source references.
        # Once the preprocessor recurses during macro expansion, this is not
        # used, and instead the src_ref_override is passed along statically
        self._src_seg_map = src_seg_map

        # Preprocessor macro expansions result in a few recursive calls to the
        # verilog preprocessor. After the first recursion, it is not practical
        # to keep track of character offsets anymore, so instead a blanket
        # src_ref is used for any errors that may occur while recursing.
        # This is the alternate Source Ref to use for this level of recursion
        self._src_ref_override = src_ref_override

        # Current character offset within text
        self._scan_idx = 0

        # Start offset of current segment selection
        self._seg_start_idx = 0

        # Macro namespace
        self._macro_defs: Dict[str, Macro] = {}
        if defines is not None:
            for k, v in defines.items():
                macro = Macro(v, [])
                self._macro_defs[k] = macro

        self._conditional = ConditionalState()
        self._conditional_stack: List[ConditionalState] = []

        # Stack of what macros are currently being processed
        self._active_macro_stack: List[str] = []

        self._output_text_segments: List[str] = []
        self._current_output_idx = 0
        self._output_seg_map = segment_map.SegmentMap()

    def preprocess(self) -> Tuple[str, segment_map.SegmentMap]:
        self.main_scanner()

        if not self._conditional.is_idle or self._conditional_stack:
            self.env.msg.fatal(
                "Incomplete conditional. Missing `endif",
                self.get_err_src_ref(len(self._text), len(self._text))
            )

        output_text = "".join(self._output_text_segments)
        return (output_text, self._output_seg_map)

    def get_err_src_ref(self, start:int, end:int) -> SourceRefBase:
        """
        When emitting an error, return the appropriate src_ref.
        If at the top-level preprocessing pass, creates a unique reference
        against src_seg_map. Otherwise returns src_ref_override
        """
        if self._src_ref_override:
            return self._src_ref_override
        assert isinstance(self._src_seg_map, segment_map.SegmentMap)
        return SegmentedSourceRef(self._src_seg_map, start, end)

    #---------------------------------------------------------------------------
    # Main text scanner
    #---------------------------------------------------------------------------
    def main_scanner(self) -> None:

        queries = [
            # Skip comments
            ('mlc', r'/\*.*?\*/'),
            ('slc', r'//.*?$'),

            # Skip strings
            ('str', r'"(\\"|\\\\|[^\\"])*"'),

            # Conditionals
            ('ifdef', r'^[ \t]*(`ifdef)[ \t]+(\w+)\b'),
            ('ifndef', r'^[ \t]*(`ifndef)[ \t]+(\w+)\b'),
            ('elsif', r'^[ \t]*(`elsif)[ \t]+(\w+)\b'),
            ('else', r'^[ \t]*(`else)\b'),
            ('endif', r'^[ \t]*(`endif)\b'),

            # Define
            ('define', r'^[ \t]*(`define)[ \t]+(\w+)(\()?'),

            # Undefine
            ('undef', r'^[ \t]*(`undef)[ \t]+(\w+)\b'),

            # Line directive (ignored)
            ('line', r'^[ \t]*(`line)[ \t]+\d+[ \t]+"(\\"|\\\\|[^\\"\n])*"[ \t]+\d+\b'),

            # Macro expansion
            # Check for parentheses in parameterized macros is handled later in
            # the arg scanner.
            ('macro', r'`(\w+)'),
        ]
        query_regex = re.compile(
            '|'.join('(?P<%s>%s)' % pair for pair in queries),
            re.DOTALL | re.MULTILINE
        )

        while True:
            m = query_regex.search(self._text, self._scan_idx)
            if not m:
                # Reached EOF
                break

            assert m.lastindex is not None

            # Process directives.
            # process_*() functions will advance the index as appropriate
            check_trailing = False
            if m.lastgroup == "ifdef":
                self.process_ifdef(m)
                check_trailing = True
            elif m.lastgroup == "ifndef":
                self.process_ifndef(m)
                check_trailing = True
            elif m.lastgroup == "elsif":
                self.process_elsif(m)
                check_trailing = True
            elif m.lastgroup == "else":
                self.process_else(m)
                check_trailing = True
            elif m.lastgroup == "endif":
                self.process_endif(m)
                check_trailing = True
            elif m.lastgroup == "macro":
                self.process_macro(m)
            elif m.lastgroup == "define":
                self.process_define(m)
            elif m.lastgroup == "undef":
                self.process_undef(m)
                check_trailing = True
            elif m.lastgroup == "line":
                # Discard this directive
                self.emit_segment(m.start(m.lastindex + 1))
                self._scan_idx = m.end()
                self._seg_start_idx = self._scan_idx
                check_trailing = True
            else:
                self._scan_idx = m.end()

            if check_trailing:
                # Check for trailing text on a macro directive line
                start, end = get_illegal_trailing_text_pos(self._text, self._scan_idx)
                if start is not None and end is not None:
                    self.env.msg.fatal(
                        "Unexpected text after preprocessor directive",
                        self.get_err_src_ref(start, end)
                    )



        # emit any trailing text
        self.emit_segment(len(self._text))

    def process_ifdef(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        identifier = m.group(m.lastindex + 2)

        if not self._conditional.is_idle:
            # push conditional context
            self._conditional_stack.append(self._conditional)
            self._conditional = ConditionalState(self._conditional.is_active)

        self._conditional.do_ifdef(identifier in self._macro_defs)
        self._scan_idx = m.end()
        self._seg_start_idx = self._scan_idx

    def process_ifndef(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        identifier = m.group(m.lastindex + 2)

        if not self._conditional.is_idle:
            # push conditional context
            self._conditional_stack.append(self._conditional)
            self._conditional = ConditionalState(self._conditional.is_active)

        self._conditional.do_ifndef(identifier in self._macro_defs)
        self._scan_idx = m.end()
        self._seg_start_idx = self._scan_idx

    def process_elsif(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        identifier = m.group(m.lastindex + 2)

        if not self._conditional.is_in_if_block or self._conditional.is_in_else_block:
            self.env.msg.fatal(
                "Unexpected `elsif",
                self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
            )

        self._conditional.do_elsif(identifier in self._macro_defs)
        self._scan_idx = m.end()
        self._seg_start_idx = self._scan_idx

    def process_else(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        if not self._conditional.is_in_if_block or self._conditional.is_in_else_block:
            self.env.msg.fatal(
                "Unexpected `else",
                self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
            )
        self._conditional.do_else()
        self._scan_idx = m.end()
        self._seg_start_idx = self._scan_idx

    def process_endif(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        if self._conditional.is_idle and not self._conditional_stack:
            self.env.msg.fatal(
                "Unexpected `endif",
                self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
            )

        self._conditional.do_endif()
        self._scan_idx = m.end()
        self._seg_start_idx = self._scan_idx

        if self._conditional_stack:
            # Pop conditional context
            self._conditional = self._conditional_stack.pop()

    def process_define(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        identifier = m.group(m.lastindex + 2)

        reserved_macro_names = {
            "include", "ifdef", "ifndef", "elsif", "else", "endif", "define",
            "undef", "line", "__LINE__", "__FILE__"
        }
        if identifier in reserved_macro_names:
            self.env.msg.fatal(
                "Macro name '%s' is a reserved keyword" % identifier,
                self.get_err_src_ref(m.start(m.lastindex + 2), m.end(m.lastindex + 2) - 1)
            )

        self._scan_idx = m.end(m.lastindex + 2)
        has_args = bool(m.group(m.lastindex + 3))

        if has_args:
            args = self.define_arg_scanner()
        else:
            args = []

        contents = self.define_contents_scanner()

        # Create macro defintion object
        macro = Macro(contents, args)
        if self._conditional.is_active:
            self._macro_defs[identifier] = macro

        self._seg_start_idx = self._scan_idx

    def process_undef(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start(m.lastindex + 1))

        if self._conditional.is_active:
            identifier = m.group(m.lastindex + 2)
            self._macro_defs.pop(identifier, None)

        self._scan_idx = m.end()
        self._seg_start_idx = self._scan_idx

    def process_macro(self, m: Match) -> None:
        assert m.lastindex is not None

        self.emit_segment(m.start())
        identifier = m.group(m.lastindex + 1)
        self._scan_idx = m.end()

        if not self._conditional.is_active:
            return

        macro_start_idx = m.start()

        if self._src_ref_override:
            macro_src_ref = self._src_ref_override
        else:
            assert isinstance(self._src_seg_map, segment_map.SegmentMap)
            macro_src_ref = SegmentedSourceRef(self._src_seg_map, m.start(), m.end() - 1)

        # Check if macro identifier is not one of the reserved directives
        # Preprocessor can end up here if the user did not provide the expected
        # args to a directive. The parser will instead fall back to thinking it
        # is a macro expansion
        reserved_macro_names = {
            "include", "ifdef", "ifndef", "elsif", "define",
            "undef", "line"
        }
        if identifier in reserved_macro_names:
            self.env.msg.fatal(
                "Preprocessor directive '`%s' is incomplete" % identifier,
                self.get_err_src_ref(m.start(), m.end() - 1)
            )

        # Lookup macro identifier
        if identifier not in self._macro_defs:
            self.env.msg.fatal(
                "Macro '`%s' has not been defined" % identifier,
                self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
            )
        macro = self._macro_defs[identifier]

        # Scan for macro args if necessary
        if macro.args:
            # scan for args
            raw_argv = self.macro_arg_scanner()

            # run each argv through the main scanner
            argv = []
            if self._conditional.is_active:
                for arg_text, arg_src_ref in raw_argv:
                    vpp = VerilogPreprocessor(self.env, arg_text, src_ref_override=arg_src_ref)
                    vpp._macro_defs = self._macro_defs
                    vpp._active_macro_stack = self._active_macro_stack
                    argv.append(vpp.preprocess()[0])
        else:
            argv = []

        macro_end_idx = self._scan_idx - 1

        # Push current macro into active stack
        if identifier in self._active_macro_stack:
            self.env.msg.fatal(
                "Found recursive macro expansion when processing '`%s'" % identifier,
                self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
            )
        self._active_macro_stack.append(identifier)

        # Emit macro text
        text = macro.render_macro(self, argv, macro_src_ref)
        self._output_text_segments.append(text)

        # If this is the top-level preprocessing pass (and therefore it
        # has a src seg map), also create a source tracking segment.
        if self._src_seg_map:
            text_len = len(text)
            segment = segment_map.MacroSegment(
                self._current_output_idx,
                self._current_output_idx + text_len - 1,
                macro_start_idx, macro_end_idx,
                self._src_seg_map
            )
            assert isinstance(self._output_seg_map, segment_map.SegmentMap)
            self._output_seg_map.segments.append(segment)
            self._current_output_idx += text_len

        # Done processing this macro
        self._active_macro_stack.pop()

        self._seg_start_idx = self._scan_idx

    def emit_segment(self, end_idx: int) -> None:
        if self._conditional.is_active:
            if self._seg_start_idx < end_idx:
                # Emit text segment
                seg = self._text[self._seg_start_idx:end_idx]
                self._output_text_segments.append(seg)

                # If this is the top-level preprocessing pass (and therefore it
                # has a src seg map), also create a source tracking segment.
                if self._src_seg_map:
                    segment = segment_map.UnalteredSegment(
                        self._current_output_idx,
                        self._current_output_idx + end_idx - self._seg_start_idx - 1,
                        self._seg_start_idx,
                        end_idx - 1,
                        self._src_seg_map
                    )
                    assert isinstance(self._output_seg_map, segment_map.SegmentMap)
                    self._output_seg_map.segments.append(segment)
                    # Advance the output offset
                    self._current_output_idx += end_idx - self._seg_start_idx

    #---------------------------------------------------------------------------
    # Define scanner
    #---------------------------------------------------------------------------
    def define_arg_scanner(self) -> List[str]:
        """
        Scan in define args starting from the current scan_idx.
        scan_idx is advanced to after the arg list.

        Returns a list of identifier strings
        """
        # Only implementing simple args. Not bothering with defaults for now.

        # Capture contents of parentheses
        arg_regex = re.compile(r'\(([ \t\w,]+)\)')
        m = arg_regex.match(self._text, self._scan_idx)
        if not m:
            self.env.msg.fatal(
                "Syntax error when parsing define args",
                self.get_err_src_ref(self._scan_idx, self._scan_idx)
            )
        current_arg_idx = self._scan_idx + 1
        self._scan_idx = m.end()

        # Extract individual arg identifiers
        raw_args = m.group(1).split(",")
        args = []
        for raw_arg in raw_args:
            m = re.fullmatch(r'\s*(\w+)\s*', raw_arg)
            if not m:
                self.env.msg.fatal(
                    "Syntax error when parsing define args",
                    self.get_err_src_ref(current_arg_idx, current_arg_idx + len(raw_arg) - 1)
                )
            args.append(m.group(1))
            current_arg_idx += len(raw_arg) + 1
        return args

    def define_contents_scanner(self) -> str:
        start_idx = self._scan_idx

        # First, do a rough scan of the text to determine the max extent of the
        # define, solely based on escaped newlines.
        # Find the first newline without a backslash
        unescaped_newline_regex = re.compile(r'[^\\\r]\r?$', re.MULTILINE)
        m = unescaped_newline_regex.search(
            self._text,
            # Intentionally rewind the scan index by 1 character in case it is
            # currently pointing at the terminating newline
            self._scan_idx - 1
        )
        if m:
            max_idx = m.end()
        else:
            # All lines up to EOF have a '\'.
            max_idx = len(self._text)

        # Next, re-scan to find if macro block actually ends earlier due to line
        # or block comment edge-cases. Need to properly hop over string
        # literals in case they contain comment-like characters.
        queries = [
            # Skip over macro-specific quote escapes
            ('esc', r'(?:`"|`\\`")'),
            # Skip over string literals
            ('str', r'"(\\"|\\\\|\\\r?\n|[^\\"])*"'),
            # Skip over block comments that are contained within the same line
            ('slbc', r'/\*[^\n]*?\*/'),

            # Define ends on a line comment, or the start of a multi-line block comment
            ('end1', r'//'),
            ('end2', r'/\*'),
        ]
        query_regex = re.compile(
            '|'.join('(?P<%s>%s)' % pair for pair in queries),
            re.DOTALL
        )
        while True:
            m = query_regex.search(self._text, self._scan_idx, max_idx)
            if not m:
                # Reached end of macro range without running into a comment
                self._scan_idx = max_idx
                break

            if m.lastgroup in {"end1", "end2"}:
                # Reached end of define due to a comment
                self._scan_idx = m.start()
                break

            # Advance index for next iteration
            self._scan_idx = m.end()

        # Strip any newline escapes
        return re.sub(r'\\(\r?\n)', r'\1', self._text[start_idx:self._scan_idx]).strip()

    #---------------------------------------------------------------------------
    # Macro Arg Scanner
    #---------------------------------------------------------------------------
    def macro_arg_scanner(self) -> List[Tuple[str, SourceRefBase]]:
        """
        When a macro is instantiated and has args, this scanner parses them
        and returns the raw extracted arg text

        Returns a list of tuples:
            (arg_text, SourceRefBase)
        """

        # First, skip any whitespace until the open parentheses are reached
        m = re.compile(r'\s*\(').match(self._text, self._scan_idx)
        if not m:
            self.env.msg.fatal(
                "Expected arguments to macro. Got none.",
                self.get_err_src_ref(self._scan_idx, self._scan_idx)
            )
        self._scan_idx = m.end()
        args_start_idx = self._scan_idx - 1

        queries = [
            # Skip over stuff
            ('mlc', r'/\*.*?\*/'),
            ('slc', r'//.*?$'),
            ('str', r'"(\\"|\\\\|[^\\"])*"'),

            # Detect punctuation
            ('punc', r'([\[\]\{\}\(\),])'),
        ]
        query_regex = re.compile(
            '|'.join('(?P<%s>%s)' % pair for pair in queries),
            re.DOTALL | re.MULTILINE
        )

        enclosures_stack: List[str] = []
        argvs = []
        argv_start_idx = self._scan_idx
        punc_pairs = {
            '[':']',
            '{':'}',
            '(':')',
        }

        for m in query_regex.finditer(self._text, self._scan_idx):
            assert m.lastindex is not None

            if m.lastgroup != "punc":
                continue

            punc = m.group(m.lastindex + 1)
            if not enclosures_stack and punc == ',':
                # macro arg separator
                argv = self._text[argv_start_idx:m.start()].strip()
                if self._src_ref_override:
                    argvs.append((argv, self._src_ref_override))
                else:
                    assert isinstance(self._src_seg_map, segment_map.SegmentMap)
                    src_ref = SegmentedSourceRef(self._src_seg_map, argv_start_idx, m.start() - 1)
                    argvs.append((argv, src_ref))
                argv_start_idx = m.end()
            elif not enclosures_stack and punc == ')':
                # Final closing parentheses. End of args!
                argv = self._text[argv_start_idx:m.start()].strip()
                if self._src_ref_override:
                    argvs.append((argv, self._src_ref_override))
                else:
                    assert isinstance(self._src_seg_map, segment_map.SegmentMap)
                    src_ref = SegmentedSourceRef(self._src_seg_map, argv_start_idx, m.start() - 1)
                    argvs.append((argv, src_ref))
                self._scan_idx = m.end()
                break
            elif punc in {'[', '{', '('}:
                enclosures_stack.append(punc)
            elif punc in {']', '}', ')'}:
                if not enclosures_stack:
                    self.env.msg.fatal(
                        "Unexpected '%s' while parsing macro arguments." % punc,
                        self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
                    )
                c = enclosures_stack.pop()
                if punc != punc_pairs[c]:
                    self.env.msg.fatal(
                        "Unexpected '%s' while parsing macro arguments." % punc,
                        self.get_err_src_ref(m.start(m.lastindex + 1), m.end(m.lastindex + 1) - 1)
                    )
        else:
            self.env.msg.fatal(
                "Reached end of text before all macro args could be parsed",
                self.get_err_src_ref(args_start_idx, args_start_idx)
            )

        return argvs

def get_illegal_trailing_text_pos(text: str, idx: int) -> Tuple[Optional[int], Optional[int]]:
    """
    Scan the remainder of a line for illegal text.
    Verilog preprocessor directives require that there be no trailing text,
    except for comments.

    If illegal text is found, return the start/end index of it as a tuple.
    Otherwise return (None, None)
    """

    # First, scan ahead past all block comments
    bc_regex = re.compile(r'(?:[ \t]*/\*.*?\*/)*[ \t]*')
    m = bc_regex.match(text, idx)
    assert m is not None
    idx = m.end()

    # Assert that any remaining text is a comment
    rem_regex = re.compile(r'(:?//.*|/\*.*)?\r?$', re.MULTILINE)
    m = rem_regex.match(text, idx)
    if m:
        return (None, None)
    else:
        # Did not match. Find end of the line
        eol_regex = re.compile(r'.+$', re.MULTILINE)
        m = eol_regex.match(text, idx)
        assert m is not None
        return (m.start(), m.end() - 1)


class ConditionalState:
    def __init__(self, parent_is_active: bool=True):
        self.is_in_if_block = False
        self.is_in_else_block = False

        # Is in a block that will be emitted
        self.is_active = parent_is_active

        # Conditional has been exhausted
        self.is_done = False

        # Parent conditional is in an active state
        self.parent_is_active = parent_is_active

    @property
    def is_idle(self) -> bool:
        return not (self.is_in_else_block or self.is_in_if_block)

    def do_ifdef(self, result: bool) -> None:
        assert self.is_idle
        self.is_in_if_block = True
        self.is_in_else_block = False
        self.is_done = False
        if result:
            self.is_active = self.parent_is_active
        else:
            self.is_active = False

    def do_ifndef(self, result: bool) -> None:
        self.do_ifdef(not result)

    def do_elsif(self, result: bool) -> None:
        assert self.is_in_if_block
        assert not self.is_in_else_block

        if self.is_done:
            return

        if self.is_active:
            # prev block was active
            self.is_active = False
            self.is_done = True
        elif result:
            # success!
            self.is_active = self.parent_is_active

    def do_else(self) -> None:
        assert self.is_in_if_block
        assert not self.is_in_else_block

        self.is_in_if_block = False
        self.is_in_else_block = True

        if self.is_done:
            return

        if self.is_active:
            # prev block was active
            self.is_active = False
            self.is_done = True
        else:
            self.is_active = self.parent_is_active

    def do_endif(self) -> None:
        assert not self.is_idle
        self.is_in_if_block = False
        self.is_in_else_block = False
        self.is_active = self.parent_is_active
        self.is_done = False


class Macro:
    def __init__(self, contents: str, args: List[str]):
        self.args = args
        self.segments = self.prepare_segments(contents)

    def prepare_segments(self, contents: str) -> List[Union[int, str]]:
        """
        Prepares the macro contents:
        - remove macro-specific quote escape sequences
        - remove token paste ``
        - remove comments
        - capture arg tokens

        results in a list of segments:
            If an entry is a string, it gets emitted as-is
            If an entry is an integer, it represents the value of the arg it indexes
        """

        queries = [
            ('esc1', r'`"'),
            ('esc2', r'`\\`"'),
            ('tp', r'``'),
            ('str', r'"(\\"|\\\\|[^\\"])*"'),
            ('slbc', r'/\*.*?\*/'),
        ]
        if self.args:
            queries.append(
                ('arg', r'\b(%s)\b' % '|'.join(self.args))
            )

        query_regex = re.compile(
            '|'.join('(?P<%s>%s)' % pair for pair in queries)
        )

        seg_start_idx = 0
        segments: List[Union[int, str]] = []
        for m in query_regex.finditer(contents):
            assert m.lastindex is not None

            if m.lastgroup == "esc1":
                # replace with unescaped version
                segments.append(contents[seg_start_idx:m.start()])
                seg_start_idx = m.end()
                segments.append('"')
            elif m.lastgroup == "esc2":
                # replace with unescaped version
                segments.append(contents[seg_start_idx:m.start()])
                seg_start_idx = m.end()
                segments.append('\\"')
            elif m.lastgroup in ("tp", "slbc"):
                # discard
                segments.append(contents[seg_start_idx:m.start()])
                seg_start_idx = m.end()
            elif m.lastgroup == "arg":
                # replace with arg index
                segments.append(contents[seg_start_idx:m.start()])
                seg_start_idx = m.end()

                arg_name = m.group(m.lastindex + 1)
                arg_idx = self.args.index(arg_name)
                segments.append(arg_idx)

        segments.append(contents[seg_start_idx:])
        return segments

    def render_macro(self, parent_vpp: VerilogPreprocessor, argv: List[str], src_ref: SourceRefBase) -> str:
        if len(argv) != len(self.args):
            parent_vpp.env.msg.fatal(
                "Macro expansion requires %d arguments. Got %d instead"
                % (len(self.args), len(argv)),
                src_ref
            )

        # Join text segments. Replace arg values along the way
        text_segments = []
        for seg in self.segments:
            if isinstance(seg, int):
                text_segments.append(argv[seg])
            else:
                text_segments.append(seg)
        text = "".join(text_segments)

        # Perform substitutions on macro text before emitting it
        # Copy macro context
        # Intentionally do not pass the conditional state to effectively reset it
        vpp = VerilogPreprocessor(parent_vpp.env, text, src_ref_override=src_ref)
        vpp._macro_defs = parent_vpp._macro_defs
        vpp._active_macro_stack = parent_vpp._active_macro_stack
        text, _ = vpp.preprocess()

        return text
