from typing import TYPE_CHECKING
import re

if TYPE_CHECKING:
    from typing import List, Union, Tuple
    URLRecipe = List[Union[str, Tuple[str, str]]]

class TranslatorSpec:
    """
    Remote URL Patterns
    -------------------
    The ``remote_regexes`` class variable is used to define a list of regular
    expressions to match the remote URL for this service.
    This is typically two regexes - one for SSH and another for HTTPS

    If an expression uses named groups, the group names can be referenced later
    in URL recipes. Since URL patterns in this list are searched sequentially,
    named groups from only the first successful match are captured.


    URL Recipes
    -----------
    URL Recipes are used to construct the resulting weblink. A recipe entry can
    either be simply a format string, or a tuple containing a format string
    followed by a conditional expression:

        recipes = [
            <format string>,
            (<format string>, <expression string>),
        ]

    During recipe processing, keys from an "info" dictionary are made avaialble.
    These include the following:

    * ``path`` - target path, relative to the repository root.
    * ``is_folder`` - Boolean indicating whether the path is a directory or not.
    * ``branch_name`` - The target's current branch name. If not known, this key is not available.
    * ``commit_hash`` - The target's exact commit hash.
    * ``line`` - target line number. Only exists if a single line was specified in the target
    * ``start_line``, ``end_line`` - target line range. Only exists if a range
      of lines were specified in the target.

    .. as well as any named capture groups from the remote URL match earlier.

    Format strings are processed using ``str.format()`` using the keys available
    in the info dictionary.

    Conditional strings are evaluated. Keys from the info dictionary are
    available as local variables.

    The first recipe that matches its conditional (if any), and can be
    formatted successfully (all keys referenced are available) is used.

    """

    #: List of regexes to match the git remote URL.
    remote_regexes = [] # type: List[str]

    #: Formatting recipes for the URL prefix.
    #: This is usually for handling variations in the repository's base URL
    url_root_recipes = [] # type: URLRecipe

    #: Formatting recipes for the main contents of the URL
    #: This is a good place to define variations in file/folder paths,
    #: branch/commit references, etc.
    url_body_recipes = [] # type: URLRecipe

    #: Formatting recipes for the URL's suffix
    #: Use this to define line number highligting, etc.
    url_suffix_recipes = [] # type: URLRecipe

    @classmethod
    def is_match(cls, remote: str) -> bool:
        """
        Checks if remote URL is a match for this translator's service.
        Returning True guarantees that this translator can generate a link.

        Parameters
        ----------
        remote: str
            remote git URL.
        """
        for regex in cls.remote_regexes:
            if re.fullmatch(regex, remote):
                return True

        return False


    @classmethod
    def get_source_url(cls, remote: str, info: dict) -> str:

        # Get match object for remote url
        m = None
        for regex in cls.remote_regexes:
            m = re.fullmatch(regex, remote)
            if m:
                break
        assert m is not None

        # Extract any named match groups and stuff them to the info dictionary
        for k,v in m.groupdict().items():
            if v is not None:
                info[k] = v

        url_root = cls.process_recipe(info, cls.url_root_recipes)
        url_body = cls.process_recipe(info, cls.url_body_recipes)
        url_suffix = cls.process_recipe(info, cls.url_suffix_recipes)

        return url_root + url_body + url_suffix


    @classmethod
    def process_recipe(cls, info: dict, recipes: list) -> str:

        for recipe in recipes:
            if isinstance(recipe, tuple):
                format_string, conditional = recipe

                # Check conditional
                if not eval(conditional, {}, info):
                    continue
            else:
                # unconditional format string
                format_string = recipe
            assert isinstance(format_string, str)

            # Process format string
            try:
                return format_string.format(**info)
            except KeyError:
                # format string tried to use an info key that was unavailable
                # not a match
                pass

        raise RuntimeError
