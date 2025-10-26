import sys
from typing import List, TYPE_CHECKING

if TYPE_CHECKING:
    from importlib.metadata import EntryPoint

if sys.version_info >= (3,10,0):
    from importlib import metadata

    def _get_entry_points(group_name: str) -> List['EntryPoint']:
        eps = []
        for ep in metadata.entry_points().select(group=group_name):
            eps.append(ep)
        return eps

elif sys.version_info >= (3,8,0):
    from importlib import metadata

    def _get_entry_points(group_name: str) -> List['EntryPoint']:
        eps = []
        for dist in metadata.distributions():
            for ep in dist.entry_points:
                if ep.group == group_name:
                    eps.append(ep)
        return eps

else:
    import pkg_resources # type: ignore

    def _get_entry_points(group_name: str) -> List['EntryPoint']:
        eps = []
        for ep in pkg_resources.iter_entry_points(group_name):
            eps.append(ep)
        return eps



def get_entry_points(group_name: str) -> List['EntryPoint']:
    return _get_entry_points(group_name)
