from typing import TYPE_CHECKING, List, Dict, Any

from .config import schema
from .config.loader import AppConfig

if TYPE_CHECKING:
    import argparse
    from systemrdl import RDLCompiler

class Importer:
    # Importer name
    name: str

    #: A list of one or more file extensions the importer expects to support.
    #: This is used as a rough first-pass method to identify which
    #: importer is appropriate for a given file type.
    file_extensions: List[str] = []

    #: Schema for additional organization-specific configuration options
    #: specified by a 'peakrdl.toml' file loaded at startup
    #:
    #: For more details, see :ref:`cfg_schema`
    cfg_schema: Dict[str, Any] = {}

    def __init__(self) -> None:
        #: Resolved configuration data that was extracted from the PeakRDL TOML,
        #: and validated.
        self.cfg: Dict[str, Any] = {}

    def _load_cfg(self, cfg: AppConfig) -> None:
        self.cfg = cfg.get_namespace(self.name, schema.normalize(self.cfg_schema))

    def is_compatible(self, path: str) -> bool:
        """
        This function is used to further determine if this importer is capable of
        processing the given input file.

        If the file extension was not enough to determine which importer to use,
        this function is called and shall determine if the file is compatible
        with this importer to a high degree of confidence.

        .. note::

            This should not attempt to exhaustively validate the file's
            correctness.

            Instead, it is recommended to open the file, and perform a low-cost
            scan of the contents to quickly determine if the file's format
            appears to be compatible with this importer.
            This can be as simple as a quick keyword search.

        Parameters
        ----------
        path: str
            Path to the input file
        """
        raise NotImplementedError


    def add_importer_arguments(self, arg_group: 'argparse._ActionsContainer') -> None:
        """
        Override this function to define additional command line arguments by
        using the ``arg_group.add_argument()`` method.
        See Python's `argparse module <https://docs.python.org/3/library/argparse.html#the-add-argument-method>`_
        for more details on how to use this.

        .. note::

            Not all exporter configuration options are appropriate as command-line arguments.
            For options that will likely remain static for a given user/organization,
            consider using the PeakRDL TOML configuration mechanism via the
            ``cfg_schema`` and ``cfg`` class members.

        Parameters
        ----------
        arg_group: ``argparse.ArgumentParser``
            Add more command line arguments via this object.
        """


    def do_import(self, rdlc: 'RDLCompiler', options: 'argparse.Namespace', path: str) -> None:
        """
        Defines the implementation of your importer.

        Parameters
        ----------
        rdlc: ``systemrdl.RDLCompiler``
            Reference to the SystemRDL ``RDLCompiler`` object.
        options: ``argparse.Namespace``
            Argparse Namespace object containing all the command line argument values
        path: str
            Path to the input file
        """
        raise NotImplementedError
