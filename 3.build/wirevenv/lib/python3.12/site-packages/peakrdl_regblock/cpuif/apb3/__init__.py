from ..base import CpuifBase

class APB3_Cpuif(CpuifBase):
    template_path = "apb3_tmpl.sv"
    is_interface = True

    @property
    def port_declaration(self) -> str:
        return "apb3_intf.slave s_apb"

    def signal(self, name:str) -> str:
        return "s_apb." + name.upper()


class APB3_Cpuif_flattened(APB3_Cpuif):
    is_interface = False

    @property
    def port_declaration(self) -> str:
        lines = [
            "input wire " + self.signal("psel"),
            "input wire " + self.signal("penable"),
            "input wire " + self.signal("pwrite"),
            f"input wire [{self.addr_width-1}:0] " + self.signal("paddr"),
            f"input wire [{self.data_width-1}:0] " + self.signal("pwdata"),
            "output logic " + self.signal("pready"),
            f"output logic [{self.data_width-1}:0] " + self.signal("prdata"),
            "output logic " + self.signal("pslverr"),
        ]
        return ",\n".join(lines)

    def signal(self, name:str) -> str:
        return "s_apb_" + name
