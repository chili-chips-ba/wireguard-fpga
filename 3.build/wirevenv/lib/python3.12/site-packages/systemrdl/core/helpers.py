import textwrap
from typing import Union, TYPE_CHECKING, Type, List

from antlr4.Token import CommonToken
from antlr4.tree.Tree import TerminalNodeImpl

from ..parser.SystemRDLParser import SystemRDLParser
from .. import component as comp

if TYPE_CHECKING:
    from typing import TypeVar
    T = TypeVar('T')

def is_pow2(x: int) -> bool:
    return (x > 0) and ((x & (x - 1)) == 0)


def roundup_pow2(x: int) -> int:
    return 1<<(x-1).bit_length()

def roundup_to(x: int, n: int) -> int:
    if x % n:
        return (x//n + 1) * n
    else:
        return (x//n) * n

def get_ID_text(token: Union[CommonToken, TerminalNodeImpl]) -> str:
    """
    Get the text from the ID token.
    Strips off leading slash escape if present
    """
    if isinstance(token, CommonToken):
        text = token.text
    else:
        text = token.getText()

    text = text.lstrip('\\')
    return text

def truncate_int(v: int, width: int) -> int:
    mask = (1 << width) - 1
    return v & mask

def dedent_text(s: str) -> str:
    """
    Remove any common indentation, ignoring indentation state of the first
    line of text.
    """
    s = s.strip()
    linelist = s.splitlines()
    if len(linelist) >= 2:
        s = (
            linelist[0]
            + "\n"
            + textwrap.dedent("\n".join(linelist[1:]))
        )
    return s

def get_all_subclasses(cls: Type['T']) -> List[Type['T']]:
    return cls.__subclasses__() + [
        g for s in cls.__subclasses__()
        for g in get_all_subclasses(s)
    ]

KW_TO_COMPONENT_MAP = {
    SystemRDLParser.FIELD_kw    : comp.Field,
    SystemRDLParser.REG_kw      : comp.Reg,
    SystemRDLParser.REGFILE_kw  : comp.Regfile,
    SystemRDLParser.ADDRMAP_kw  : comp.Addrmap,
    SystemRDLParser.SIGNAL_kw   : comp.Signal,
    SystemRDLParser.MEM_kw      : comp.Mem,
}
