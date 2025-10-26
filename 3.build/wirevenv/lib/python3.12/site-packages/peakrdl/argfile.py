import sys
import os
import shlex
import re
from typing import List, Optional, Set, Match

def expand_tokens(argv: List[str], path: str) -> List[str]:
    """
    Expand environment variables in args
    """
    token_queries = [
        ("cwd", r"\$\{\{this_dir\}\}"), # ${{this_dir}}
        ("env1", r"\$(\w+)"),           # $ENV_VAR
        ("env2", r"\$\{(\w+)\}"),       # ${ENV_VAR}
    ]
    token_regex = re.compile(
        '|'.join('(?P<%s>%s)' % pair for pair in token_queries)
    )

    def repl(m: Match) -> str:
        if m.lastgroup in {"env1", "env2"}:
            assert m.lastindex is not None
            k = m.group(m.lastindex + 1)
            v = os.environ.get(k)
            if v is None:
                print(f"warning: environment variable '{k}' is not set", file=sys.stderr)
                v = ""
            return v
        elif m.lastgroup == "cwd":
            this_dir = os.path.normpath(os.path.dirname(path))
            return this_dir
        else:
            raise RuntimeError

    return [token_regex.sub(repl, arg) for arg in argv]


def parse_argfile(path: str) -> List[str]:
    if not os.path.exists(path):
        print(f"error: file not found: {path}", file=sys.stderr)
        sys.exit(1)

    with open(path, "r", encoding='utf-8') as f:
        args = shlex.split(f.read(), comments=True)
        args = expand_tokens(args, path)
        return args


def expand_argfile(argv: List[str], _pathlist: Optional[Set[str]] = None) -> List[str]:
    if _pathlist is None:
        _pathlist = set()

    new_argv = []
    argv_iter = iter(argv)
    for arg in argv_iter:
        if arg == "-f":
            try:
                path = next(argv_iter)
            except StopIteration:
                print("error: argument -f: expected FILE", file=sys.stderr)
                sys.exit(1)

            if path in _pathlist:
                print(f"error: circular reference in -f files: '{path}' was already opened", file=sys.stderr)
                sys.exit(1)
            _pathlist.add(path)
            file_args = parse_argfile(path)
            file_args = expand_argfile(file_args, _pathlist)
            _pathlist.remove(path)
            new_argv.extend(file_args)
        else:
            new_argv.append(arg)
    return new_argv
