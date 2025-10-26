from typing import TYPE_CHECKING, List, Set, Tuple, Optional, Dict

from .perl_preprocessor import PerlPreprocessor
from .verilog_preprocessor import VerilogPreprocessor
from .stream import PreprocessedInputStream
#from . import segment_map

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment

def preprocess_file(
    env: 'RDLEnvironment',
    path: str,
    search_paths: List[str],
    defines: Optional[Dict[str, str]]=None
) -> Tuple[PreprocessedInputStream, Set[str]]:

    # Run file through Perl preprocessor
    ppp = PerlPreprocessor(env, path, search_paths)
    preprocessed_text, seg_map = ppp.preprocess()
    included_files = ppp.included_files

    # ... then through the Verilog preprocessor
    vpp = VerilogPreprocessor(env, preprocessed_text, seg_map, defines=defines)
    preprocessed_text, seg_map = vpp.preprocess()

    #segment_map.print_segment_debug(preprocessed_text, seg_map)

    # Encapsulate into an Antlr-like input stream object
    input_stream = PreprocessedInputStream(preprocessed_text, seg_map)
    return input_stream, included_files
