from typing import TYPE_CHECKING

from antlr4 import InputStream

if TYPE_CHECKING:
    from .segment_map import SegmentMap

class PreprocessedInputStream(InputStream):
    def __init__(self, data: str, seg_map: 'SegmentMap'):
        super().__init__(data)
        self.seg_map = seg_map
