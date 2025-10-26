from typing import Tuple, Union, Dict, Any, Optional

from antlr4.Token import CommonToken
from antlr4 import ParserRuleContext
from antlr4.tree.Tree import TerminalNodeImpl

from .preprocessor.stream import PreprocessedInputStream
from .preprocessor.segment_map import SegmentMap

#-------------------------------------------------------------------------------
# Generic Base Classes
#-------------------------------------------------------------------------------
class SourceRefBase:
    """
    Base class for all source references
    """

    def derive_coordinates(self) -> None:
        """
        DEPRECATED
        Some dependents may call this if using the old SourceRef API
        """

    def __deepcopy__(self, memo: Dict[int, Any]) -> 'SourceRefBase':
        # Don't deepcopy source refs
        return self


class FileSourceRef(SourceRefBase):
    """
    Simple file source reference that is only capable of providing the path to
    the originating file.

    Some register model importers may only be able to provide limited source context.
    """
    def __init__(self, path: str) -> None:
        super().__init__()
        self._path = path

    @property
    def path(self) -> str:
        """
        Path of the originating file
        """
        return self._path

    @property
    def filename(self) -> str:
        """
        DEPRECATED
        Alias to ``path``.
        Some dependents may call this if using the old SourceRef API
        """
        return self.path

class DetailedFileSourceRef(FileSourceRef):
    """
    Detailed source reference that is capable of providing a context snippet
    from the originating source.
    """

    @property
    def path(self) -> str:
        """
        Path of the originating file
        """
        raise NotImplementedError

    @property
    def line(self) -> int:
        """
        Line number within the originating file
        """
        raise NotImplementedError

    @property
    def line_text(self) -> str:
        """
        Source text of the originating line
        """
        raise NotImplementedError

    @property
    def line_selection(self) -> Tuple[int, int]:
        """
        Start/end coordinates of the selection within line_text.
        If the actual selection spans multiple lines, it is clamped to the end
        of this line.
        """
        raise NotImplementedError

#-------------------------------------------------------------------------------
class DirectSourceRef(DetailedFileSourceRef):
    """
    Source reference that points directly to a file's coordinates.
    """
    def __init__(self, path: str, start_idx: int, end_idx: int) -> None:
        super().__init__(path)
        self._start_idx: int = start_idx
        self._end_idx: int = end_idx

        self._line: Optional[int] = None
        self._line_text: Optional[str] = None
        self._line_selection: Optional[Tuple[int, int]] = None

    def _extract_line_info(self) -> None:
        idx = 0
        lineno = 1
        line_start_idx = 0

        with open(self.path, 'r', newline='', encoding='utf_8') as fp:
            while True:
                line_text = fp.readline()
                assert line_text != ""

                idx += len(line_text)

                # This line contains the start_idx
                if self._start_idx < idx:
                    line_text = line_text.rstrip("\n").rstrip("\r")
                    self._line = lineno
                    self._line_text = line_text
                    start_column = self._start_idx - line_start_idx

                    # Get the end of the selection
                    end_column = self._end_idx - line_start_idx
                    # Clamp it to the end of the current line
                    if end_column >= len(line_text):
                        end_column = len(line_text) - 1

                    self._line_selection = (start_column, end_column)

                    break

                lineno += 1
                line_start_idx = idx

    @property
    def path(self) -> str:
        return self._path

    @property
    def line(self) -> int:
        if self._line is None:
            self._extract_line_info()
            assert self._line is not None
        return self._line

    @property
    def line_text(self) -> str:
        if self._line_text is None:
            self._extract_line_info()
            assert self._line_text is not None
        return self._line_text

    @property
    def line_selection(self) -> Tuple[int, int]:
        if self._line_selection is None:
            self._extract_line_info()
            assert self._line_selection is not None
        return self._line_selection



class SegmentedSourceRef(DirectSourceRef):
    """
    Source reference that requires coordinate transformation through one or more
    segment maps
    """
    _path: Optional[str] # type: ignore # overriding this to be optional

    def __init__(self, seg_map: SegmentMap, start_idx: int, end_idx: int):
        super().__init__(None, None, None) # type: ignore # overriding this to be optional

        self._seg_map = seg_map
        self._seg_start_idx = start_idx
        self._seg_end_idx = end_idx

    @property
    def path(self) -> str:
        if self._path is None:
            self._resolve_seg_map()
            assert self._path is not None
        return self._path

    def _resolve_seg_map(self) -> None:
        self._start_idx, self._end_idx, self._path = self._seg_map.get_selection(
            self._seg_start_idx, self._seg_end_idx
        )


#-------------------------------------------------------------------------------
def src_ref_from_antlr(antlr_ref: Union[CommonToken, TerminalNodeImpl, ParserRuleContext]) -> Optional[SourceRefBase]:
    # Normalize to pair of CommonToken objects
    if isinstance(antlr_ref, CommonToken):
        token = antlr_ref
        end_token = None
    elif isinstance(antlr_ref, TerminalNodeImpl):
        token = antlr_ref.symbol
        end_token = None
    elif isinstance(antlr_ref, ParserRuleContext):
        # antlr_ref is an entire context (token range)
        token = antlr_ref.start
        end_token = antlr_ref.stop
    else:
        print(antlr_ref)
        raise NotImplementedError

    # Extract selection coordinates
    start = token.start
    if end_token is None:
        end = token.stop
    else:
        end = end_token.stop

    inputStream = token.getInputStream()
    if not isinstance(inputStream, PreprocessedInputStream):
        # This originated from a non-file, so the full src_ref is not known
        # TODO: Eventually extend this to a stream source ref
        return None

    return SegmentedSourceRef(inputStream.seg_map, start, end)
