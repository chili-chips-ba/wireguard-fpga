import argparse
import re
import sys
from typing import TYPE_CHECKING

import git

from . import GitMeTheURL, GMTUException

if TYPE_CHECKING:
    from typing import Optional, Tuple, Union

def main() -> None:
    #----------------------------------
    # Collect command line arguments
    #----------------------------------
    parser = argparse.ArgumentParser(
        description="Create a shareable URL to a Git repository"
    )
    parser.add_argument(
        '-e', '--exact', dest='exact_commit', action='store_true',default=False,
        help="If set, URL will point to the file at the exact commit."
    )
    parser.add_argument('target_path',
        nargs="?", default=".",
        help='Generate a public URL to this path.'
    )
    options = parser.parse_args()

    #----------------------------------
    # Parse target path
    m = re.fullmatch(r'(?P<path>.+?):(?P<line>\d+)(?:-(?P<to_line>\d+))?', options.target_path)
    line = None # type: Optional[Union[int, Tuple[int, int]]]
    if not m:
        path = options.target_path
    else:
        path = m.group("path")
        line = int(m.group("line"))
        to_line_str = m.group("to_line")
        if to_line_str is not None:
            to_line = int(to_line_str)
            line = (
                min(line, to_line),
                max(line, to_line),
            )

    #----------------------------------
    gmtu = GitMeTheURL()

    #----------------------------------
    # Translate the path!
    #----------------------------------
    try:
        url = gmtu.get_source_url(path, line=line, exact_commit=options.exact_commit)
    except git.InvalidGitRepositoryError:
        print("error: Path does not point to a git repository: %s" % path, file=sys.stderr)
        sys.exit(1)
    except git.NoSuchPathError:
        print("error: Path does not exist: %s" % path, file=sys.stderr)
        sys.exit(1)
    except GMTUException as e:
        print("error:", e.args[0], file=sys.stderr)
        sys.exit(1)

    #----------------------------------
    # Output
    #----------------------------------
    print(url)
