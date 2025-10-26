from ..base import CpuifBase
from ...utils import clog2

class Avalon_Cpuif(CpuifBase):
    template_path = "avalon_tmpl.sv"
    is_interface = True

    @property
    def port_declaration(self) -> str:
        return "avalon_mm_intf.agent avalon"

    def signal(self, name:str) -> str:
        return "avalon." + name

    @property
    def word_addr_width(self) -> int:
        # Avalon agents use word addressing, therefore address width is reduced
        return self.addr_width - clog2(self.data_width_bytes)

class Avalon_Cpuif_flattened(Avalon_Cpuif):
    is_interface = False

    @property
    def port_declaration(self) -> str:
        lines = [
            "input wire " + self.signal("read"),
            "input wire " + self.signal("write"),
            "output logic " + self.signal("waitrequest"),
            f"input wire [{self.word_addr_width-1}:0] " + self.signal("address"),
            f"input wire [{self.data_width-1}:0] " + self.signal("writedata"),
            f"input wire [{self.data_width_bytes-1}:0] " + self.signal("byteenable"),
            "output logic " + self.signal("readdatavalid"),
            "output logic " + self.signal("writeresponsevalid"),
            f"output logic [{self.data_width-1}:0] " + self.signal("readdata"),
            "output logic [1:0] " + self.signal("response"),
        ]
        return ",\n".join(lines)

    def signal(self, name:str) -> str:
        return "avalon_" + name
