from systemrdl import rdltypes

# sw <--> ipxact:access
ACCESS_MAP = [
    (rdltypes.AccessType.r,     "read-only"),
    (rdltypes.AccessType.rw,    "read-write"),
    (rdltypes.AccessType.rw1,   "read-writeOnce"),
    (rdltypes.AccessType.w,     "write-only"),
    (rdltypes.AccessType.w1,    "writeOnce"),
]

def access_from_sw(sw: rdltypes.AccessType) -> str:
    for sw_entry, access_entry in ACCESS_MAP:
        if sw == sw_entry:
            return access_entry
    return None

def sw_from_access(access: str) -> rdltypes.AccessType:
    for sw_entry, access_entry in ACCESS_MAP:
        if access == access_entry:
            return sw_entry
    return None

#-------------------------------------------------------------------------------
# onwrite <--> ipxact:modifiedWriteValue
MWV_MAP = [
    (rdltypes.OnWriteType.wclr,     "clear"),
    (rdltypes.OnWriteType.woclr,    "oneToClear"),
    (rdltypes.OnWriteType.woset,    "oneToSet"),
    (rdltypes.OnWriteType.wot,      "oneToToggle"),
    (rdltypes.OnWriteType.wset,     "set"),
    (rdltypes.OnWriteType.wuser,    "modify"),
    (rdltypes.OnWriteType.wzc,      "zeroToClear"),
    (rdltypes.OnWriteType.wzs,      "zeroToSet"),
    (rdltypes.OnWriteType.wzt,      "zeroToToggle"),
]

def mwv_from_onwrite(onwrite: rdltypes.OnWriteType) -> str:
    for onwrite_entry, mwv_entry in MWV_MAP:
        if onwrite == onwrite_entry:
            return mwv_entry
    return None

def onwrite_from_mwv(mwv: str) -> rdltypes.OnWriteType:
    for onwrite_entry, mwv_entry in MWV_MAP:
        if mwv == mwv_entry:
            return onwrite_entry
    return None

#-------------------------------------------------------------------------------
# onread <--> ipxact:readAction
READ_ACTION_MAP = [
    (rdltypes.OnReadType.rclr, "clear"),
    (rdltypes.OnReadType.rset, "set"),
    (rdltypes.OnReadType.ruser, "modify"),
]

def readaction_from_onread(onread: rdltypes.OnReadType) -> str:
    for onread_entry, read_action_entry in READ_ACTION_MAP:
        if onread == onread_entry:
            return read_action_entry
    return None

def onread_from_readaction(readaction: str) -> rdltypes.OnReadType:
    for onread_entry, read_action_entry in READ_ACTION_MAP:
        if readaction == read_action_entry:
            return onread_entry
    return None
