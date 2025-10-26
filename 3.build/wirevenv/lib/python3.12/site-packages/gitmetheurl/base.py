import os
from typing import TYPE_CHECKING
import functools

import git

from .translators import GitHub
from .translators import GitLab
from .translators import Bitbucket
from .plugin_loader import get_translator_plugins

if TYPE_CHECKING:
    from typing import Optional, List, Type, Union, Tuple, Dict
    from .translators.translator import TranslatorSpec

    InfoDict = Dict[str, Union[str, bool]]

class GitMeTheURL:

    def __init__(self, translators: "Optional[List[Type[TranslatorSpec]]]"=None):
        if translators:
            # Use user-specified translators
            self.translators = translators
        else:
            # Use plugin translators & built-in
            self.translators = get_translator_plugins()
            self.translators.extend([
                GitHub,
                GitLab,
                Bitbucket,
            ])

    def get_source_url(self, path: str, line: "Optional[Union[int, Tuple[int, int]]]" = None, exact_commit: bool = False) -> str:
        """
        Convert a path to a file into a URL to the file in the service's source
        browser.

        Parameters
        ----------
        path: str
            Path to file.
        line: int or tuple
            Line(s) to highlight if the service supports it.
            If integer, selects a single line.
            If 2-tuple, selects the line range.
        exact_commit: bool
            If overridden to ``True``, will attempt to generate a URL that
            points to the source file at the same commit as it is currently.
        """
        remote, info = self._get_target_info(path, exact_commit)

        # Stuff line number(s) into info
        if isinstance(line, int):
            info['line'] = line
        elif isinstance(line, tuple) and len(line) == 2:
            info['start_line'], info['end_line'] = line

        # Lookup translator
        translator = self._lookup_translator(remote)
        if translator is None:
            raise GMTUException("Unable to convert remote: %s" % remote)

        # Construct the URL!
        return translator.get_source_url(remote, info)


    @functools.lru_cache(maxsize=None)
    def _get_target_info(self, path:str, exact_commit: bool = False) -> 'Tuple[str, dict]':
        """
        Collects relevant Git information about the target path.

        Returns a dictionary of entries to be used by the translator to form a URL

        keys:
        - is_folder
        - path
        - commit_hash
        - branch_name
        """
        repo = git.Repo(path, search_parent_directories=True)
        remote = self._get_remote(repo)

        info = {} # type: InfoDict

        info['is_folder'] = os.path.isdir(path)

        # File path within the repo
        root_path = repo.git.rev_parse("--show-toplevel")
        relpath = os.path.relpath(path, root_path)
        if relpath == ".":
            relpath = ""
        info['path'] = relpath

        # Get branch/commit reference as appropriate
        commit = None
        branch = None
        if exact_commit:
            # Unconditionally pointing to exact commit.
            commit = repo.head.object.hexsha
        else:
            # Attempt to determine current branch
            branch = self._get_branch(repo)

            if branch is None:
                # failed to get remote branch. Fall back to commit
                commit = repo.head.object.hexsha
        if commit is not None:
            info['commit_hash'] = commit
        if branch is not None:
            info['branch_name'] = branch

        return remote, info

    @functools.lru_cache(maxsize=None)
    def _lookup_translator(self, remote:str) -> 'Optional[Type[TranslatorSpec]]':
        for t in self.translators:
            if t.is_match(remote):
                return t
        return None

    @staticmethod
    def _get_remote(repo: git.Repo) -> str:
        try:
            urls = repo.remote().urls # raises ValueError if there is no origin
        except ValueError as e:
            raise GMTUException("Repository does not have any remotes") from e

        for url in urls:
            return url

        raise ValueError("Repository does not have a remote URL set")


    @staticmethod
    def _get_branch(repo: git.Repo) -> "Optional[str]":
        try:
            return repo.active_branch.name
        except TypeError:
            # Likely detached head
            pass

        # Find remote branch that contains this commit
        for ref in repo.remotes.origin.refs:
            if ref.name == "origin/HEAD":
                # Skip origin/HEAD. Not a branch!
                continue
            if repo.is_ancestor(repo.head.object, ref.object):
                # Return branch name but strip "origin/" prefix
                return ref.name[len("origin/"):]
        return None


class GMTUException(Exception):
    pass
