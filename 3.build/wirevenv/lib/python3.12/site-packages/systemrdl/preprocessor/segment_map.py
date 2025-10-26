from typing import Tuple, List, Union, Optional

import colorama

class Segment:
    """
    Base class for various segment map segments.
    Not to be used directly
    """
    def __init__(self, start: int, end: int, src_start: int, src_end: int, src: Union[str, 'SegmentMap'], incl_ref: Optional['IncludeRef']=None):

        # start/end offset of resulting text
        self.start = start
        self.end = end

        # start/end offset of original text
        # Offsets are relative to src
        self.src_start = src_start
        self.src_end = src_end

        # where the original text came from
        # If str, then this is a file path
        # otherwise this is another SegmentMap
        self.src = src

        # IncludeRef object that describes from where this segment was included
        self.incl_ref = incl_ref

class UnalteredSegment(Segment):
    """
    Segment of unaltered text
    """

class MacroSegment(Segment):
    """
    Segment of text that was the result of a macro transformation
    """

class IncludeRef:
    def __init__(self, start: int, end: int, path: str, parent: Optional['IncludeRef']=None):
        # Location of the `include statement
        self.start = start
        self.end = end
        self.path = path

        # Reference to parent IncludeRef if nested include
        self.parent = parent


class SegmentMap:

    def __init__(self) -> None:
        self.segments: List[Segment] = []

    def translate_offset(self, offset: int, round_up: bool) -> Tuple[int, str]:
        # Scan through segments
        for segment in self.segments:
            if offset <= segment.end:
                if isinstance(segment, MacroSegment):
                    if round_up:
                        new_offset = segment.src_end
                    else:
                        new_offset = segment.src_start
                    new_src = segment.src
                else:
                    new_offset = segment.src_start + (offset - segment.start)
                    new_src = segment.src
                break
        else:
            # Reached end without finding a segment
            # Clamp to the end of the last segment
            new_offset = self.segments[-1].src_end
            new_src = self.segments[-1].src

        if isinstance(new_src, SegmentMap):
            # Got nested segment map. Peel back the next layer
            new_offset, new_src = new_src.translate_offset(new_offset, round_up)

        return (
            new_offset,
            new_src,
        )

    def get_selection(self, start: int, end: int) -> Tuple[int, int, str]:
        """
        Given post-processed start/end character offsets, derives the coordinates
        within the original source file.

        If the selection spans two files, the end coordinate is discarded and is
        instead pinned to the start coordinate
        """
        start, path = self.translate_offset(start, round_up=False)
        end, end_path = self.translate_offset(end, round_up=True)

        # Do not allow selections that span multiple files
        if path != end_path:
            end = start

        return (start, end, path)


def print_segment_debug(text: str, smap: SegmentMap) -> None: # pragma: no cover
    colors = (
        colorama.Back.RED,
        colorama.Back.GREEN,
        colorama.Back.YELLOW,
        colorama.Back.BLUE,
        colorama.Back.MAGENTA,
        colorama.Back.CYAN,
        colorama.Back.WHITE,
    )

    color_idx = 0
    out_str_parts = []
    for seg in smap.segments:
        out_str_parts.append(colors[color_idx] + text[seg.start:seg.end+1])
        color_idx = (color_idx+1) % len(colors)
    out_str_parts.append(colorama.Back.RESET)

    print("".join(out_str_parts))
