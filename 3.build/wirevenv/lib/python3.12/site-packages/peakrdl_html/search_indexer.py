from typing import Dict, List, Tuple, Set, Union
from collections import defaultdict, OrderedDict
import re
import hashlib
import json
import os

from systemrdl.node import Node, FieldNode

class SearchIndexer:
    # Rough limit of how many words each index file should have.
    # Intent is to reduce amount of data the client has to fetch per query
    WORDS_PER_FILE_THRESHOLD = 500

    def __init__(self) -> None:

        # Flat index of mappings
        #   word: {(page_id, loc_code), ...}
        self.index = defaultdict(set) # type: Dict[str, Set[Tuple[int, int]]]


    def add_node(self, node: Node, page_id: int, field_idx:int=0) -> None:
        is_field = isinstance(node, FieldNode)

        text = node.get_property('desc')
        if text:
            loc = self.get_location_code(is_field=is_field, field_idx=field_idx)
            self.add_text(text, page_id, loc)

        text = node.get_property('name', default=None)
        if text:
            loc = self.get_location_code(is_name=True, is_field=is_field, field_idx=field_idx)
            self.add_text(text, page_id, loc)

        if is_field:
            encode = node.get_property('encode')
            if encode:
                for member in encode:
                    loc = self.get_location_code(is_field=True, is_name=True, is_enum=True, field_idx=field_idx)
                    self.add_text(member.name, page_id, loc)
                    if member.rdl_name:
                        self.add_text(member.rdl_name, page_id, loc)
                    if member.rdl_desc:
                        loc = self.get_location_code(is_field=True, is_enum=True, field_idx=field_idx)
                        self.add_text(member.rdl_desc, page_id, loc)


    def get_location_code(self, is_name:bool=False, is_field:bool=False, is_enum:bool=False, field_idx:int=0) -> int:
        """
        Along with the page_id, each word locator also gets a refined location code.
        This is an integer bitfield as follows:
        [N:3]: field index
        [2]: is in enum
        [1]: is field node
        [0]: in name property (otherwise in desc)
        """
        loc_code = (
            int(is_name)
            | (int(is_field) << 1)
            | (int(is_enum) << 2)
            | (field_idx << 3)
        )
        return loc_code


    def add_text(self, text: str, page_id: int, loc_code:int) -> None:
        text = self.normalize_text(text)

        # Submit words into index
        for word in text.split():
            self.add_word(word, page_id, loc_code)

            # If a word contains underscores, submit the individual segments too
            subwords = word.split("_")
            if len(subwords) >= 2:
                for w in subwords:
                    self.add_word(w, page_id, loc_code)


    def normalize_text(self, text: str) -> str:
        # Normalize to lowercase
        text = text.lower()

        # Delete anything that looks like a URL
        # regex from: https://daringfireball.net/2010/07/improved_regex_for_matching_urls
        text = re.sub(r"\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'\".,<>?«»“”‘’]))", " ", text)

        # Replace non-word characters with spaces
        text = re.sub(r"[^\w]", " ", text)

        return text


    def add_word(self, word: str, page_id: int, loc_code:int) -> None:
        # Discard small, or 'low value' words
        if len(word) < 3:
            return
        if word in SKIP_WORDS:
            return

        self.index[word].add((page_id, loc_code))


    def get_shorthash(self, prefix:str) -> int:
        shahash = hashlib.sha1(prefix.encode('utf-8'))
        # Prune to a short 28-bit hash to fit into a 32-bit int.
        # Pruning extra to avoid pesky sign bits
        shorthash = int(shahash.hexdigest()[-7:], 16)
        return shorthash


    def write_index_js(self, output_dir: str) -> None:
        """
        Writes out js files

        One or more bucket files (bkt-#.json):
            {
                "word_prefix": [    # bucket entry
                    [               # word entry
                        "word",
                        [           # List of word locations
                            [page_id, location_code],
                            [page_id, location_code],
                            ...
                        ]
                    ],
                    ...
                ],
                ...
            }

        A bucket index file (bkt_index.js):
            List of short hashes (see get_shorthash()) of the last prefix bucket
            stored in each bucket file.
            This will be used by the search to determine which bucket file to fetch
        """
        # Sort all words alphabetically
        words = sorted(self.index.keys())

        # Group word entries into buckets based on the word prefix
        # This is intentional so that each bucket may contain multiple words
        # with the same prefix, allowing easy linear search of similar words
        buckets = defaultdict(list)
        for word in words:
            locations = self.index[word]

            prefix = word[:3]

            entry = [
                word,
                list(locations),
            ]
            buckets[prefix].append(entry)


        # Generate hashes of each prefix. This will be used as a mechanism to
        # evenly split the buckets across multiple files
        shorthash_map = defaultdict(list)
        for prefix in buckets.keys():
            shorthash = self.get_shorthash(prefix)

            # Store prefix in list in case there is a hash collision
            shorthash_map[shorthash].append(prefix)

        # Write out JSON files
        bucket_file_idx = 0 # current bucket file index
        last_hash_list = [] # List of last bucket hash inserted into each bucket file
        word_count = 0 # Number of words in current bucket file
        bucket_file_dict = OrderedDict() # type: Dict[str, List[Union[str, List[Tuple[int, int]]]]]
        shorthashes = sorted(shorthash_map.keys())

        def _write_bucket_file() -> None:
            path = os.path.join(output_dir, "bkt-%d.json" % bucket_file_idx)
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(bucket_file_dict, f, separators=(',', ':'))

        for shorthash in shorthashes:
            # Load buckets
            for prefix in shorthash_map[shorthash]:
                bucket = buckets[prefix]
                word_count += len(bucket)
                bucket_file_dict[prefix] = bucket

            # Split to a new file once word threshold is exceeded
            if word_count >= self.WORDS_PER_FILE_THRESHOLD:
                # Write out json
                _write_bucket_file()
                last_hash_list.append(shorthash)

                # reset for new file
                bucket_file_idx += 1
                word_count = 0
                bucket_file_dict = OrderedDict()

        # Write out remainder file
        if bucket_file_dict:
            _write_bucket_file()
            last_hash_list.append(shorthash)

        # Write out bucket file hash list
        path = os.path.join(output_dir, "bkt_index.js")
        with open(path, 'w', encoding='utf-8') as f:
            f.write("var SearchBucketIndex = ")
            json.dump(last_hash_list, f, separators=(',', ':'))
            f.write(";")

        #self._debug_print_stats(buckets)


    def _debug_print_stats(self, buckets):
        word_counts = []
        for word, locations in self.index.items():
            word_counts.append((len(locations), word))
        word_counts.sort(reverse=True)

        bucket_counts = []
        for prefix, words in buckets.items():
            bucket_counts.append((len(words), prefix))
        bucket_counts.sort(reverse=True)

        print("Unique words:", len(word_counts))
        print("Words that show up in the most locations:")
        for count, word in word_counts[:25]:
            print("\t%d: %s" % (count, word))

        print("Prefix buckets:", len(bucket_counts))
        print("Largest buckets:")
        for count, prefix in bucket_counts[:25]:
            print("\t%d: %s" % (count, prefix))


# set of "low value" words that should not be indexed.
# In the context of register space description text, these words are not considered
# to be meaningful enough to ever be indexed, and are common enough that they could bloat it
# Subset hand-selected from top 100 of https://gist.github.com/deekayen/4148741
SKIP_WORDS = {
    "the", "and", "you", "that", "was", "for", "are", "with",
    "his", "they", "one", "have", "this", "from", "had", "not",
    "word", "but", "what", "some", "can", "out", "other", "were",
    "all", "there", "when", "use", "your", "how", "she", "which",
    "their", "will", "way", "about", "many", "then", "them", "would",
    "like", "these", "her", "make", "him", "has", "could", "come",
    "did", "than", "who", "may", "been", "now", "its",
}
