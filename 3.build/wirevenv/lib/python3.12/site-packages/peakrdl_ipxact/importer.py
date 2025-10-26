from typing import Optional, List, Dict, Any, Type, Union, Set
import re

from xml.etree import ElementTree

from systemrdl import RDLCompiler, RDLImporter
from systemrdl import rdltypes
from systemrdl.messages import SourceRefBase
from systemrdl import component as comp

from . import typemaps


# Expected IP-XACT namespaces. This parser is not strict about the exact version.
VALID_NS_REGEXES = [
    re.compile(r"\{http[s]?:\/\/www\.spiritconsortium\.org\/XMLSchema\/SPIRIT", re.IGNORECASE),
    re.compile(r"\{http[s]?:\/\/www\.accellera\.org/XMLSchema/spirit\/1685-2009", re.IGNORECASE),
    re.compile(r"\{http[s]?:\/\/www\.accellera\.org\/XMLSchema\/IPXACT", re.IGNORECASE),
]

class IPXACTImporter(RDLImporter):

    def __init__(self, compiler: RDLCompiler):
        """
        Parameters
        ----------
        compiler:
            Reference to ``RDLCompiler`` instance to bind the importer to.
        """

        super().__init__(compiler)
        self.ns = None # type: str
        self._addressUnitBits = 8
        self._current_addressBlock_access = rdltypes.AccessType.rw
        self.remap_states_seen = set() # type: Set[str]

    @property
    def src_ref(self) -> SourceRefBase:
        return self.default_src_ref


    def import_file(self, path: str, remap_state: Optional[str] = None) -> None:
        """
        Import a single SPIRIT or IP-XACT file into the SystemRDL namespace.

        Parameters
        ----------
        path:
            Input SPIRIT or IP-XACT XML file.
        remap_state:
            Optional remapState string that is used to select memoryRemap regions
            that are tagged under a specific remap state.
        """
        super().import_file(path)

        self._addressUnitBits = 8
        self.remap_states_seen = set()

        tree = ElementTree.parse(path)

        component = self.get_component(tree)

        memoryMaps = self.get_all_memoryMap(component)

        for memoryMap in memoryMaps:
            comp_name = self.get_sanitized_element_name(component)
            self.import_memoryMap(memoryMap, comp_name, remap_state)


    def get_component(self, tree: ElementTree.ElementTree) -> ElementTree.Element:
        # Find <component> and determine namespace prefix
        root = tree.getroot()
        if get_local_name(root) == "component":
            component = root
            namespace = get_namespace(root)
            for ns_regex in VALID_NS_REGEXES:
                if ns_regex.match(namespace):
                    self.ns = namespace
                    break
            else:
                self.msg.fatal("Unrecognized namespace URI: %s" % namespace, self.src_ref)
        else:
            self.msg.fatal(
                "Could not find a 'component' element",
                self.src_ref
            )
        return component


    def get_all_memoryMap(self, component: ElementTree.Element) -> List[ElementTree.Element]:
        # Find <memoryMaps>
        memoryMaps_s = component.findall(self.ns+"memoryMaps")
        if len(memoryMaps_s) != 1:
            self.msg.fatal(
                "'component' must contain exactly one 'memoryMaps' element",
                self.src_ref
            )
        memoryMaps = memoryMaps_s[0]

        # Find all <memoryMap>
        memoryMap_s = memoryMaps.findall(self.ns+"memoryMap")

        return memoryMap_s


    def get_all_address_blocks(self, memoryMap: ElementTree.Element, remap_state: Optional[str]) -> List[ElementTree.Element]:
        """
        Gets all the addressBlock elements within a memoryMap

        A memoryMap can also contain one or more addressBlocks that are wrapped in a memoryRemap tag.
        These provide alternate views into the address space depending on the state of the device.
        This function also returns any addressBlock elements that match the remap state
        """
        addressBlocks = memoryMap.findall(self.ns+"addressBlock")

        memoryRemaps = memoryMap.findall(self.ns+"memoryRemap")
        for memoryRemap in memoryRemaps:
            this_remapState = memoryRemap.get(self.ns+"state")
            self.remap_states_seen.add(this_remapState)
            if this_remapState == remap_state:
                remap_addressBlocks = memoryRemap.findall(self.ns+"addressBlock")
                addressBlocks.extend(remap_addressBlocks)

        return addressBlocks


    def import_memoryMap(self, memoryMap: ElementTree.Element, component_name: str, remap_state: Optional[str]) -> None:
        # Schema:
        #     {nameGroup}
        #         name (required) --> inst_name
        #         displayName --> prop:name
        #         description --> prop:desc
        #     isPresent --> prop:ispresent
        #     addressBlock --> children
        #     memoryRemap
        #         addressBlock --> children
        #     addressUnitBits
        #     shared
        #     vendorExtensions

        d = self.flatten_element_values(memoryMap)


        # Check for required values
        name = self.get_sanitized_element_name(memoryMap)
        if not name:
            self.msg.fatal("memoryMap is missing required tag 'name'", self.src_ref)

        # Add component prefix to name
        name = "%s__%s" % (component_name, name)

        # Create named component definition
        C_def = self.create_addrmap_definition(name)

        # Collect properties and other values
        if 'displayName' in d:
            self.assign_property(C_def, "name", d['displayName'])

        if 'description' in d:
            self.assign_property(C_def, "desc", d['description'])

        if 'isPresent' in d:
            self.assign_property(C_def, "ispresent", d['isPresent'])

        aub = memoryMap.find(self.ns+"addressUnitBits")
        if aub is not None:
            self._addressUnitBits = self.parse_integer(get_text(aub))

            if (self._addressUnitBits < 8) or (self._addressUnitBits % 8 != 0):
                self.msg.fatal(
                    "Importer only supports <addressUnitBits> that is a multiple of 8",
                    self.src_ref
                )
        else:
            self._addressUnitBits = 8


        # collect children
        name_prefix = name + "__"
        self.remap_states_seen = set()
        addressBlocks = self.get_all_address_blocks(memoryMap, remap_state)
        for addressBlock in addressBlocks:
            child = self.parse_addressBlock(addressBlock, name_prefix)
            if child:
                self.add_child(C_def, child)

        if 'vendorExtensions' in d:
            C_def = self.memoryMap_vendorExtensions(d['vendorExtensions'], C_def)

        if not C_def.children:
            # memoryMap contains no addressBlocks. Skip
            self.msg.warning(
                "Discarding memoryMap '%s' because it does not contain any child addressBlocks"
                % name,
                self.src_ref
            )

            if self.remap_states_seen:
                self.msg.warning(
                    "memoryMap '%s' contains the following possible memory remap states: \n\t%s\n"
                    "Try selecting a remap state, as it may uncover state-specific address regions."
                    % (name, "\n\t".join(self.remap_states_seen)),
                    self.src_ref
                )
            return

        self.register_root_component(C_def)


    def parse_addressBlock(self, addressBlock: ElementTree.Element, name_prefix:str) -> Optional[Union[comp.Addrmap, comp.Mem]]:
        """
        Parses an addressBlock and returns an instantiated addrmap or mem
        component.

        If addressBlock is empty or usage specifies 'reserved' then returns
        None
        """
        # Schema:
        #   {nameGroup}
        #       name (required) --> inst_name
        #       displayName --> prop:name
        #       description --> prop:desc
        #   accessHandles
        #   isPresent --> prop:ispresent
        #   baseAddress (required) --> addr_offset
        #   {addressBlockDefinitionGroup}
        #       typeIdentifier
        #       range (required) --> divide by width and set prop:mementries if Mem
        #       width (required) --> prop:memwidth if Mem
        #       {memoryBlockData}
        #           usage --> Mem vs Addrmap instance
        #           volatile
        #           access --> prop:sw if Mem
        #           parameters
        #       {registerData}
        #           register --> children
        #           registerFile --> children
        #   vendorExtensions

        d = self.flatten_element_values(addressBlock)
        name = self.get_sanitized_element_name(addressBlock)

        if d.get('usage', None) == "reserved":
            # 1685-2014 6.9.4.2-a.1.iii: defines the entire range of the
            # addressBlock as reserved or for unknown usage to IP-XACT. This
            # type shall not contain registers.
            return None

        # Check for required values
        required = {'baseAddress', 'range', 'width'}
        missing = required - set(d.keys())
        if not name:
            missing.add('name')
        for m in missing:
            self.msg.fatal("addressBlock is missing required tag '%s'" % m, self.src_ref)

        # Create named component definition
        is_memory = d.get('usage', None) == "memory"
        type_name = name_prefix + name
        if is_memory:
            C_def = self.create_mem_definition(type_name)
        else:
            C_def = self.create_addrmap_definition(type_name)

        # Collect properties and other values
        if 'displayName' in d:
            self.assign_property(C_def, "name", d['displayName'])

        if 'description' in d:
            self.assign_property(C_def, "desc", d['description'])

        if 'isPresent' in d:
            self.assign_property(C_def, "ispresent", d['isPresent'])

        if is_memory:
            self.assign_property(C_def, "memwidth", d['width'])
            self.assign_property(
                C_def, "mementries",
                (d['range'] * self._addressUnitBits) // (d['width'])
            )

            if 'access' in d:
                self.assign_property(C_def, "sw", d['access'])

        if 'access' in d:
            self._current_addressBlock_access = d['access']
        else:
            self._current_addressBlock_access = rdltypes.AccessType.rw

        # collect children
        for child_el in d['child_els']:
            local_name = get_local_name(child_el)
            if local_name == "register":
                R = self.parse_register(child_el)
                if R:
                    self.add_child(C_def, R)
            elif local_name == "registerFile" and not is_memory:
                R = self.parse_registerFile(child_el)
                if R:
                    self.add_child(C_def, R)
            else:
                self.msg.error(
                    "Invalid child element <%s> found in <%s:addressBlock>"
                    % (child_el.tag, self.ns),
                    self.src_ref
                )

        if 'vendorExtensions' in d:
            C_def = self.addressBlock_vendorExtensions(d['vendorExtensions'], C_def)


        if not is_memory and not C_def.children:
            # If an addressBlock has no children, skip it
            self.msg.warning(
                "Discarding addressBlock '%s' because it does not contain any children"
                % name,
                self.src_ref
            )
            return None

        # All addressBlocks get registered under the root namespace
        self.register_root_component(C_def)

        # Also convert to an instance, since this will be instantiated into the
        # wrapper that represents the memoryMap
        if is_memory:
            C = self.instantiate_mem(
                C_def,
                name, self.AU_to_bytes(d['baseAddress'])
            )
        else:
            C = self.instantiate_addrmap(
                C_def,
                name, self.AU_to_bytes(d['baseAddress'])
            )

        return C


    def parse_registerFile(self, registerFile: ElementTree.Element) -> Optional[comp.Regfile]:
        """
        Parses an registerFile and returns an instantiated regfile component
        """
        # Schema:
        #   {nameGroup}
        #       name (required) --> inst_name
        #       displayName --> prop:name
        #       description --> prop:desc
        #   accessHandles
        #   isPresent --> prop:ispresent
        #   dim --> dimensions
        #   addressOffset (required)
        #   {registerFileDefinitionGroup}
        #       typeIdentifier
        #       range (required)
        #       {registerData}
        #           register --> children
        #           registerFile --> children
        #   parameters
        #   vendorExtensions

        d = self.flatten_element_values(registerFile)
        name = self.get_sanitized_element_name(registerFile)

        # Check for required values
        required = {'addressOffset', 'range'}
        missing = required - set(d.keys())
        if not name:
            missing.add('name')
        for m in missing:
            self.msg.fatal("registerFile is missing required tag '%s'" % m, self.src_ref)

        # Create component instance
        if 'dim' in d:
            # is array
            C = self.instantiate_regfile(
                self.create_regfile_definition(),
                name, self.AU_to_bytes(d['addressOffset']),
                d['dim'], self.AU_to_bytes(d['range'])
            )
        else:
            C = self.instantiate_regfile(
                self.create_regfile_definition(),
                name, self.AU_to_bytes(d['addressOffset'])
            )

        # Collect properties and other values
        if 'displayName' in d:
            self.assign_property(C, "name", d['displayName'])

        if 'description' in d:
            self.assign_property(C, "desc", d['description'])

        if 'isPresent' in d:
            self.assign_property(C, "ispresent", d['isPresent'])

        # collect children
        for child_el in d['child_els']:
            local_name = get_local_name(child_el)
            if local_name == "register":
                R = self.parse_register(child_el)
                if R:
                    self.add_child(C, R)
            elif local_name == "registerFile":
                R = self.parse_registerFile(child_el)
                if R:
                    self.add_child(C, R)
            else:
                self.msg.error(
                    "Invalid child element <%s> found in <%s:registerFile>"
                    % (child_el.tag, self.ns),
                    self.src_ref
                )

        if 'vendorExtensions' in d:
            C = self.registerFile_vendorExtensions(d['vendorExtensions'], C)

        if not C.children:
            # Register File contains no fields! RDL does not allow this. Discard
            self.msg.warning(
                "Discarding registerFile '%s' because it does not contain any children"
                % (C.inst_name),
                self.src_ref
            )
            return None

        return C


    def parse_register(self, register: ElementTree.Element) -> Optional[comp.Reg]:
        """
        Parses a register and returns an instantiated reg component
        """
        # Schema:
        #   {nameGroup}
        #       name (required) --> inst_name
        #       displayName --> prop:name
        #       description --> prop:desc
        #   accessHandles
        #   isPresent --> prop:ispresent
        #   dim --> dimensions
        #   addressOffset (required)
        #   {registerDefinitionGroup}
        #       typeIdentifier
        #       size (required)
        #       volatile
        #       access
        #       reset { <<1685-2009>>
        #           value
        #           mask
        #       }
        #       field...
        #   alternateRegisters
        #   parameters
        #   vendorExtensions

        d = self.flatten_element_values(register)
        name = self.get_sanitized_element_name(register)

        # Check for required values
        required = {'addressOffset', 'size'}
        missing = required - set(d.keys())
        if not name:
            missing.add('name')
        for m in missing:
            self.msg.fatal("register is missing required tag '%s'" % m, self.src_ref)

        # IP-XACT allows registers to be any arbitrary bit width, but SystemRDL
        # requires the register size to be at least 8, and a power of 2.
        # Pad up the register size if needed
        d['size'] = max(8, d['size'])
        d['size'] = roundup_pow2(d['size'])

        # Create component instance
        if 'dim' in d:
            # is array
            C = self.instantiate_reg(
                self.create_reg_definition(),
                name, self.AU_to_bytes(d['addressOffset']),
                d['dim'], d['size'] // 8
            )
        else:
            C = self.instantiate_reg(
                self.create_reg_definition(),
                name, self.AU_to_bytes(d['addressOffset'])
            )

        # Collect properties and other values
        if 'displayName' in d:
            self.assign_property(C, "name", d['displayName'])

        if 'description' in d:
            self.assign_property(C, "desc", d['description'])

        if 'isPresent' in d:
            self.assign_property(C, "ispresent", d['isPresent'])

        self.assign_property(C, "regwidth", d['size'])


        reg_access = d.get('access', self._current_addressBlock_access)
        reg_reset_value = d.get('reset.value', None)
        reg_reset_mask = d.get('reset.mask', None)

        # Collect field elements and scan for name collisions
        field_tuples = []
        field_names = set()
        field_name_collisions = set()
        for child_el in d['child_els']:
            local_name = get_local_name(child_el)
            if local_name == "field":
                # This XML element is a field
                field_name = self.get_sanitized_element_name(child_el)
                field_tuples.append((field_name, child_el))
                if field_name in field_names:
                    field_name_collisions.add(field_name)
                else:
                    field_names.add(field_name)
            else:
                self.msg.error(
                    "Invalid child element <%s> found in <%s:register>"
                    % (child_el.tag, self.ns),
                    self.src_ref
                )

        # Process fields
        for field_name, field_el in field_tuples:
            # Uniquify field name if necessary
            uniquify_field_name = field_name in field_name_collisions

            field = self.parse_field(
                field_name, field_el,
                reg_access, reg_reset_value, reg_reset_mask,
                uniquify_field_name
            )
            if field is not None:
                self.add_child(C, field)


        if 'vendorExtensions' in d:
            C = self.register_vendorExtensions(d['vendorExtensions'], C)

        if not C.children:
            # Register contains no fields! RDL does not allow this. Discard
            self.msg.warning(
                "Discarding register '%s' because it does not contain any fields"
                % (C.inst_name),
                self.src_ref
            )
            return None

        return C


    def parse_field(
        self,
        name: str, field: ElementTree.Element,
        reg_access: rdltypes.AccessType, reg_reset_value: Optional[int], reg_reset_mask: Optional[int],
        uniquify_field_name: bool,
    ) -> Optional[comp.Field]:
        """
        Parses an field and returns an instantiated field component
        """
        # Schema:
        #   {nameGroup}
        #       name (required) --> inst_name
        #       displayName --> prop:name
        #       description --> prop:desc
        #   accessHandles
        #   isPresent --> prop:ispresent
        #   bitOffset (required)
        #   resets { <<1685-2014>>
        #       reset {
        #           value
        #           mask
        #       }
        #   }
        #   {fieldDefinitionGroup}
        #       typeIdentifier
        #       bitWidth (required)
        #       {fieldData}
        #           volatile
        #           access
        #           enumeratedValues...
        #           modifiedWriteValue
        #           writeValueConstraint
        #           readAction
        #           testable
        #           reserved
        #   parameters
        #   vendorExtensions

        d = self.flatten_element_values(field)

        # Check for required values
        required = {'bitOffset', 'bitWidth'}
        missing = required - set(d.keys())
        if not name:
            missing.add('name')
        for m in missing:
            self.msg.fatal("field is missing required tag '%s'" % m, self.src_ref)

        # Discard field if it is reserved
        if d.get('reserved', False):
            return None

        if uniquify_field_name:
            name += "_%d_%d" % (d['bitOffset'] + d['bitWidth'] - 1, d['bitOffset'])

        # Create component instance
        C = self.instantiate_field(
            self.create_field_definition(),
            name, d['bitOffset'], d['bitWidth']
        )

        # Collect properties and other values
        if 'displayName' in d:
            self.assign_property(C, "name", d['displayName'])

        if 'description' in d:
            self.assign_property(C, "desc", d['description'])

        if 'isPresent' in d:
            self.assign_property(C, "ispresent", d['isPresent'])

        sw_access = d.get("access", reg_access)
        self.assign_property(C, "sw", sw_access)

        if 'testable' in d:
            self.assign_property(C, "donttest", not d['testable'])

        if 'reset.value' in d:
            self.assign_property(C, "reset", d['reset.value'])
        elif reg_reset_value is not None:
            mask = (1 << C.width) - 1
            rst = (reg_reset_value >> C.lsb) & mask

            if reg_reset_mask is None:
                rmask = mask
            else:
                rmask = (reg_reset_mask >> C.lsb) & mask

            if rmask:
                self.assign_property(C, "reset", rst)

        if 'readAction' in d:
            self.assign_property(C, "onread", d['readAction'])

        if 'modifiedWriteValue' in d:
            self.assign_property(C, "onwrite", d['modifiedWriteValue'])

        if 'enum_el' in d:
            enum_type = self.parse_enumeratedValues(d['enum_el'], C.inst_name + "_enum_t")
            self.assign_property(C, "encode", enum_type)

        if 'vendorExtensions' in d:
            C = self.field_vendorExtensions(d['vendorExtensions'], C)

        # Guess what the hw access property might be based on context
        volatile = d.get("volatile", False)
        if sw_access == rdltypes.AccessType.r:
            hw_access = rdltypes.AccessType.w
        else:
            if volatile:
                hw_access = rdltypes.AccessType.rw
            else:
                hw_access = rdltypes.AccessType.r
        self.assign_property(C, "hw", hw_access)

        return C


    def parse_integer(self, s: str) -> int:
        """
        Converts an IP-XACT number string into an int

        IP-XACT technically supports integer expressions in these fields.
        For now, I don't have a compelling reason to support them.

        Handles the following formats:
            - Normal decimal: 123, -456
            - Verilog-style: 'b10, 'o77, d123, 'hff, 8'hff
            - scaledInteger:
                - May have # or 0x prefix for hex
                - May have K, M, G, or T multiplier suffix
        """
        s = s.strip()

        multiplier = {
            "K": 1024,
            "M": 1024*1024,
            "G": 1024*1024*1024,
            "T": 1024*1024*1024*1024
        }

        m = re.fullmatch(r'(-?\d+)(K|M|G|T)?', s, re.I)
        if m:
            v = int(m.group(1))
            if m.group(2):
                v *= multiplier[m.group(2).upper()]
            return v

        m = re.fullmatch(r"\d*'h([0-9a-f]+)", s, re.I) # type: ignore [unreachable]
        if m:
            return int(m.group(1), 16)

        m = re.fullmatch(r"(-)?(0x|#)([0-9a-f]+)(K|M|G|T)?", s, re.I)
        if m:
            v = int(m.group(3), 16)
            if m.group(1):
                v = -v
            if m.group(4):
                v *= multiplier[m.group(4).upper()]
            return v

        m = re.fullmatch(r"\d*'d([0-9]+)", s, re.I)
        if m:
            return int(m.group(1), 10)

        m = re.fullmatch(r"\d*'b([0-1]+)", s, re.I)
        if m:
            return int(m.group(1), 2)

        m = re.fullmatch(r"\d*'o([0-7]+)", s, re.I)
        if m:
            return int(m.group(1), 8)

        raise ValueError


    def parse_boolean(self, s: str) -> bool:
        """
        Converts several boolean-ish representations to a true bool.
        """
        s = s.lower().strip()
        if s in ("true", "1"):
            return True
        elif s in ("false", "0"):
            return False
        else:
            raise ValueError("Unable to parse boolean value '%s'" % s)


    def get_sanitized_element_name(self, el: ElementTree.Element) -> Optional[str]:
        """
        Extracts the text from the <name> child of the given element.

        Sanitizes the name to conform to import identifier rules.

        Returns None if not found
        """
        name_el = el.find(self.ns+"name")

        if name_el is None:
            return None

        return re.sub(
            r'[:\-.]',
            "_",
            get_text(name_el).strip()
        )


    def flatten_element_values(self, el: ElementTree.Element) -> Dict[str, Any]:
        """
        Given any of the IP-XACT RAL component elements, flatten the
        key/value tags into a dictionary.

        Handles values contained in:
            addressBlock, register, registerFile, field

        Ignores several tags that are not interesting to the RAL importer
        """

        d = {
            'child_els' : []
        } # type: Dict[str, Any]

        for child in el.iterfind("*"):
            local_name = get_local_name(child)
            if local_name in ("displayName", "usage"):
                # Copy string types directly, but stripped
                d[local_name] = get_text(child).strip()

            elif local_name == "description":
                # Copy description string types unmodified
                d[local_name] = get_text(child)

            elif local_name in ("baseAddress", "addressOffset", "range", "width", "size", "bitOffset", "bitWidth"):
                # Parse integer types
                d[local_name] = self.parse_integer(get_text(child))

            elif local_name in ("isPresent", "volatile", "testable", "reserved"):
                # Parse boolean types
                d[local_name] = self.parse_boolean(get_text(child))

            elif local_name in ("register", "registerFile", "field"):
                # Child elements that need to be parsed elsewhere
                d['child_els'].append(child)

            elif local_name in ("reset", "resets"):
                if local_name == "resets":
                    # pick the first reset
                    reset = child.find(self.ns + "reset")
                    if reset is None:
                        continue
                else:
                    reset = child

                value_el = reset.find(self.ns + "value")
                if value_el is not None:
                    d['reset.value'] = self.parse_integer(get_text(value_el))

                mask_el = reset.find(self.ns + "mask")
                if mask_el is not None:
                    d['reset.mask'] = self.parse_integer(get_text(mask_el))

            elif local_name == "access":
                s = get_text(child).strip()
                sw = typemaps.sw_from_access(s)
                if sw is None:
                    self.msg.error(
                        "Invalid value '%s' found in <%s>" % (s, child.tag),
                        self.src_ref
                    )
                else:
                    d['access'] = sw

            elif local_name == "dim":
                # Accumulate array dimensions
                dim = self.parse_integer(get_text(child))
                if 'dim' in d:
                    d['dim'].append(dim)
                else:
                    d['dim'] = [dim]

            elif local_name == "readAction":
                s = get_text(child).strip()
                onread = typemaps.onread_from_readaction(s)
                if onread is None:
                    self.msg.error(
                        "Invalid value '%s' found in <%s>" % (s, child.tag),
                        self.src_ref
                    )
                else:
                    d['readAction'] = onread

            elif local_name == "modifiedWriteValue":
                s = get_text(child).strip()
                onwrite = typemaps.onwrite_from_mwv(s)
                if onwrite is None:
                    self.msg.error(
                        "Invalid value '%s' found in <%s>" % (s, child.tag),
                        self.src_ref
                    )
                else:
                    d['modifiedWriteValue'] = onwrite

            elif local_name == "enumeratedValues":
                # Deal with this later
                d['enum_el'] = child

            elif local_name == "vendorExtensions":
                # Deal with this later
                d['vendorExtensions'] = child

        return d


    def parse_enumeratedValues(self, enumeratedValues: ElementTree.Element, type_name: str) -> Type[rdltypes.UserEnum]:
        """
        Parses an enumeration listing and returns the user-defined enum type
        """
        members = []
        values = []
        member_names = []
        for enumeratedValue in enumeratedValues.iterfind("*"):
            if get_local_name(enumeratedValue) != "enumeratedValue":
                continue

            # Flatten element values
            d = {} # type: Dict[str, Any]
            for child in enumeratedValue.iterfind("*"):
                local_name = get_local_name(child)
                if local_name in ("name", "displayName"):
                    d[local_name] = get_text(child).strip()
                elif local_name == "description":
                    d[local_name] = get_text(child)
                elif local_name == "value":
                    d[local_name] = self.parse_integer(get_text(child))

            name = self.get_sanitized_element_name(enumeratedValue)

            # Check for required values
            required = {'value'}
            missing = required - set(d.keys())
            if not name:
                missing.add('name')
            for m in missing:
                self.msg.fatal("enumeratedValue is missing required tag '%s'" % m, self.src_ref)

            entry_name = name
            entry_value = d['value']
            displayname = d.get('displayName', None)
            desc = d.get('description', None)

            if entry_value in values:
                self.msg.warning(
                    "Discarding enum member '%s' since its value '%d' is already defined"
                    % (entry_name, entry_value),
                    self.src_ref
                )
                continue
            values.append(entry_value)

            if entry_name in member_names:
                self.msg.warning(
                    "Discarding enum member '%s' since it was already defined"
                    % entry_name,
                    self.src_ref
                )
                continue
            member_names.append(entry_name)

            member = rdltypes.UserEnumMemberContainer(
                entry_name, entry_value, displayname, desc
            )
            members.append(member)

        enum_type = rdltypes.UserEnum.define_new(type_name, members)

        return enum_type


    def AU_to_bytes(self, au: int) -> int:
        """
        IP-XACT addresses are byte-agnostic and express addresses and ranges as
        'addressable units' that each span addressUnitBits bits.
        This function converts the AUs into normalized bytes.

        To make my life easier, this importer only allows multiples of 8 for
        the addressUnitBits property.
        """
        bit_units = au * self._addressUnitBits
        byte_units = bit_units // 8
        return byte_units


    def memoryMap_vendorExtensions(self, vendorExtensions: ElementTree.Element, component: comp.Component) -> comp.Component:
        #pylint: disable=unused-argument
        return component

    def addressBlock_vendorExtensions(self, vendorExtensions: ElementTree.Element, component: comp.Component) -> comp.Component:
        #pylint: disable=unused-argument
        return component

    def registerFile_vendorExtensions(self, vendorExtensions: ElementTree.Element, component: comp.Component) -> comp.Component:
        #pylint: disable=unused-argument
        return component

    def register_vendorExtensions(self, vendorExtensions: ElementTree.Element, component: comp.Component) -> comp.Component:
        #pylint: disable=unused-argument
        return component

    def field_vendorExtensions(self, vendorExtensions: ElementTree.Element, component: comp.Component) -> comp.Component:
        #pylint: disable=unused-argument
        return component

#===============================================================================
def get_text(el: ElementTree.Element) -> str:
    return "".join(el.itertext())

def roundup_pow2(x: int) -> int:
    return 1<<(x-1).bit_length()

def get_namespace(el: ElementTree.Element) -> str:
    # Returns the namespace part of this element's tag
    return el.tag.split("}")[0] + "}"

def get_local_name(el: ElementTree.Element) -> str:
    # Returns the non-namespace part of this element's tag
    return el.tag.split("}")[1]
