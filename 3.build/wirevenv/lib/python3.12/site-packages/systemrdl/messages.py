import sys
import enum
from typing import List, Optional, Union, overload, NoReturn
from typing_extensions import Literal

from antlr4.Token import CommonToken
from antlr4 import ParserRuleContext, InputStream
from antlr4.tree.Tree import TerminalNodeImpl

import colorama
from colorama import Fore, Style

from .preprocessor.stream import PreprocessedInputStream
from .parser.sa_systemrdl import SA_ErrorListener

from .source_ref import SourceRefBase, src_ref_from_antlr, SegmentedSourceRef
from .source_ref import DetailedFileSourceRef, FileSourceRef

# Colorama needs to be initialized to properly work in Windows
# This is a no-op in other OSes
colorama.init()

#===============================================================================
class RDLCompileError(Exception):
    """
    Base class for all SystemRDL compiler exceptions
    """

#===============================================================================
class Severity(enum.IntEnum):
    NONE = 0
    DEBUG = 1
    INFO = 2
    WARNING = 3
    ERROR = 4
    FATAL = 5

#===============================================================================
class MessagePrinter:
    """
    Printer class that handles formatting and emitting compiler messages

    This class can be extended in order to provide custom compiler message
    formatting or logging
    """

    def print_message(self, severity: Severity, text: str, src_ref: Optional[SourceRefBase]) -> None:
        lines = self.format_message(severity, text, src_ref)
        self.emit_message(lines)

    def format_message(self, severity: Severity, text: str, src_ref: Optional[SourceRefBase]) -> List[str]:
        """
        Formats the message prior to emitting it.

        Parameters
        ----------
        severity: :class:`Severity`
            Message severity.
        text: str
            Body of message
        src_ref: :class:`SourceRefBase`
            Reference to source context object

        Returns
        -------
        list
            List of strings for each line of the message
        """
        lines = []

        if severity >= Severity.ERROR:
            color = Fore.RED
        elif severity >= Severity.WARNING:
            color = Fore.YELLOW
        else:
            color = Fore.GREEN

        if src_ref is None:
            # No message context available
            lines.append(
                color + Style.BRIGHT + severity.name.lower() + ": " + Style.RESET_ALL + text
            )
            return lines


        if isinstance(src_ref, DetailedFileSourceRef):
            # Detailed message selection context is available
            lines.append(
                Style.BRIGHT
                + f"{src_ref.path}:{src_ref.line}:{src_ref.line_selection[0]+1}: "
                + color + severity.name.lower() + ": "
                + Style.RESET_ALL
                + text
            )
            lines.extend(self.get_selection_context(src_ref, color))
        elif isinstance(src_ref, FileSourceRef):
            # Only the file path is known
            lines.append(
                Style.BRIGHT
                + f"{src_ref.path}: "
                + color + severity.name.lower() + ": "
                + Style.RESET_ALL
                + text
            )
        else:
            raise RuntimeError

        return lines

    def get_selection_context(self, src_ref: DetailedFileSourceRef, color_code: str) -> List[str]:
        """
        Generates the message context lines
        """
        line_text = src_ref.line_text
        start_col, end_col = src_ref.line_selection

        # Normalize whitespace in line snippet (convert tabs to spaces)
        TPS = 4
        new_line_text = ""
        i = 0
        for char in line_text:
            if char == "\t":
                new_line_text += " " * TPS
                if i < start_col:
                    start_col += TPS-1
                if i < end_col:
                    end_col += TPS-1
                i += TPS-1
            else:
                new_line_text += char
            i += 1
        line_text = new_line_text

        # Build the context string
        width = end_col - start_col + 1
        lines = []
        lines.append(
            line_text[:start_col]
            + color_code + Style.BRIGHT
            + line_text[start_col : end_col+1]
            + Style.RESET_ALL
            + line_text[end_col+1:]
        )
        lines.append(
            " "*start_col
            + color_code + Style.BRIGHT
            + "^"*width
            + Style.RESET_ALL
        )
        return lines


    def emit_message(self, lines: List[str]) -> None:
        """
        Emit message.
        Default printer emits messages to stderr

        Parameters
        ----------
        lines: List[str]
            List of strings containing each line of the message
        """

        for line in lines:
            print(line, file=sys.stderr)

#===============================================================================
class MessageHandler:
    def __init__(self, printer: MessagePrinter, min_verbosity: Severity=Severity.WARNING):
        self.printer = printer
        self.min_verbosity = min_verbosity

        #: Set to True if an error message was ever emitted
        self.had_error = False

    @overload
    def message(self, severity: Literal[Severity.FATAL], text: str, src_ref: Optional[SourceRefBase]=None) -> NoReturn:
        ...

    @overload
    def message(self, severity: Severity, text: str, src_ref: Optional[SourceRefBase]=None) -> None:
        ...

    def message(self, severity: Severity, text: str, src_ref: Optional[SourceRefBase]=None) -> None:
        if severity == Severity.NONE:
            return

        if severity >= Severity.ERROR:
            self.had_error = True

        if severity < self.min_verbosity:
            return

        self.printer.print_message(severity, text, src_ref)

        if severity >= Severity.FATAL:
            raise RDLCompileError(text)

    def debug(self, text: str) -> None:
        self.message(Severity.DEBUG, text)

    def info(self, text: str) -> None:
        self.message(Severity.INFO, text)

    def warning(self, text: str, src_ref: Optional[SourceRefBase]=None) -> None:
        """
        Print a warning message.

        Parameters
        ----------
        text: str
            Message text
        src_ref: SourceRefBase
            Optional source reference object to provide message context
        """
        self.message(Severity.WARNING, text, src_ref)

    def error(self, text: str, src_ref: Optional[SourceRefBase]=None) -> None:
        """
        Print an error message.
        Sets ``had_error`` to True.

        Parameters
        ----------
        text: str
            Message text
        src_ref: SourceRefBase
            Optional source reference object to provide message context
        """
        self.message(Severity.ERROR, text, src_ref)

    def fatal(self, text: str, src_ref: Optional[SourceRefBase]=None) -> NoReturn:
        """
        Print a fatal message.

        Parameters
        ----------
        text: str
            Message text
        src_ref: SourceRefBase
            Optional source reference object to provide message context

        Raises
        ------
        RDLCompileError
            Always raises this exception
        """
        self.message(Severity.FATAL, text, src_ref)


class MessageExceptionRaiser(MessagePrinter):
    def print_message(self, severity: Severity, text: str, src_ref: Optional[SourceRefBase]) -> None:
        if severity >= Severity.ERROR:
            raise ValueError(text)

#===============================================================================
# Speedy-Antlr error listener
#===============================================================================
OffendingAntlrSymbol = Union[CommonToken, TerminalNodeImpl, ParserRuleContext]
class RdlSaErrorListener(SA_ErrorListener):
    def __init__(self, msg_handler: MessageHandler):
        self.msg = msg_handler

    def syntaxError(self, input_stream: InputStream, offendingSymbol: OffendingAntlrSymbol, char_index: int, line: int, column: int, msg: str) -> None:
        if offendingSymbol is not None:
            src_ref = src_ref_from_antlr(offendingSymbol)
        else:
            # If a offendingSymbol is not provided, then the next-best option is
            # to use the input stream's current state
            if isinstance(input_stream, PreprocessedInputStream):
                src_ref = SegmentedSourceRef(
                    input_stream.seg_map,
                    char_index, char_index
                )
            else:
                # This originated from a non-file, so the full src_ref is not known
                # TODO: Eventually extend this to a stream source ref
                src_ref = None

        self.msg.error(msg, src_ref)


#===============================================================================
def SourceRef(filename: str) -> FileSourceRef:
    """
    Deprecated callable that provides a compatible stand-in for the old-style
    SourceRef class constructor
    """
    return FileSourceRef(filename)
