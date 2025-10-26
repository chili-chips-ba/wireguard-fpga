from typing import TYPE_CHECKING

from .entry_points import get_entry_points

if TYPE_CHECKING:
    from typing import List, Type
    from .translators.translator import TranslatorSpec

def get_translator_plugins() -> 'List[Type[TranslatorSpec]]':
    return [ep.load() for ep in get_entry_points("gitmetheurl.translators")]
