from ..base import CpuifBase

class PassthroughCpuif(CpuifBase):
    template_path = "passthrough_tmpl.sv"

    @property
    def port_declaration(self) -> str:
        lines = [
            "input wire s_cpuif_req",
            "input wire s_cpuif_req_is_wr",
            f"input wire [{self.addr_width-1}:0] s_cpuif_addr",
            f"input wire [{self.data_width-1}:0] s_cpuif_wr_data",
            f"input wire [{self.data_width-1}:0] s_cpuif_wr_biten",
            "output wire s_cpuif_req_stall_wr",
            "output wire s_cpuif_req_stall_rd",
            "output wire s_cpuif_rd_ack",
            "output wire s_cpuif_rd_err",
            f"output wire [{self.data_width-1}:0] s_cpuif_rd_data",
            "output wire s_cpuif_wr_ack",
            "output wire s_cpuif_wr_err",
        ]
        return ",\n".join(lines)
