import sys
from typing import List, Tuple, TYPE_CHECKING, Optional

if TYPE_CHECKING:
    from importlib.metadata import EntryPoint, Distribution

if sys.version_info >= (3,10,0):
    from importlib import metadata

    def _get_entry_points(group_name: str) -> List[Tuple['EntryPoint', Optional['Distribution']]]:
        eps = []
        for ep in metadata.entry_points().select(group=group_name):
            eps.append((ep, ep.dist))
        return eps

    def _get_name_from_dist(dist: 'Distribution') -> str:
        return dist.name

elif sys.version_info >= (3,8,0): # pragma: no cover
    from importlib import metadata

    def _get_entry_points(group_name: str) -> List[Tuple['EntryPoint', Optional['Distribution']]]:
        eps = [] # type: List[Tuple[EntryPoint, Optional[Distribution]]]
        dist_names = set()
        for dist in metadata.distributions():
            # Due to a bug in importlib.metadata's distributions iterator, in
            # some cases editable installs will cause duplicate dist entries.
            # Filter this out.
            dist_name = get_name_from_dist(dist)
            if dist_name in dist_names:
                continue
            dist_names.add(dist_name)

            for ep in dist.entry_points:
                if ep.group == group_name:
                    eps.append((ep, dist))
        return eps

    def _get_name_from_dist(dist: 'Distribution') -> str:
        return dist.metadata["Name"]

else: # pragma: no cover
    import pkg_resources

    def _get_entry_points(group_name: str) -> List[Tuple['EntryPoint', Optional['Distribution']]]:
        eps = []
        for ep in pkg_resources.iter_entry_points(group_name):
            eps.append((ep, ep.dist))
        return eps

    def _get_name_from_dist(dist: 'Distribution') -> str:
        return dist.project_name # type: ignore


def get_entry_points(group_name: str) -> List[Tuple['EntryPoint', Optional['Distribution']]]:
    return _get_entry_points(group_name)

def get_name_from_dist(dist: 'Distribution') -> str:
    return _get_name_from_dist(dist)
