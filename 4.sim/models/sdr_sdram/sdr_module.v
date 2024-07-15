`timescale 1ns / 100ps

module sdr_module (Dq, Addr, Ba, Clk, Cke, Cs_n, Ras_n, Cas_n, We_n, Dqm);

`include "sdr_parameters.vh"

    inout            [63 : 0] Dq;                                      // Data IO
    input [ADDR_BITS - 1 : 0] Addr;                                    // Address
    input   [BA_BITS - 1 : 0] Ba;                                      // Bank
    input             [1 : 0] Clk;                                     // Clock
    input             [1 : 0] Cke;                                     // Clock Enable
    input             [1 : 0] Cs_n;                                    // Chip Select
    input                     Ras_n;
    input                     Cas_n;
    input                     We_n;
    input             [7 : 0] Dqm;                                     // Dq mask

`ifdef x8
    sdr U0A (Dq[ 7 :  0], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[0]);
    sdr U1A (Dq[15 :  8], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[1]);
    sdr U2A (Dq[23 : 16], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[2]);
    sdr U3A (Dq[31 : 24], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[3]);
    sdr U4A (Dq[39 : 32], Addr, Ba, Clk[1], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[4]);
    sdr U5A (Dq[47 : 40], Addr, Ba, Clk[1], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[5]);
    sdr U6A (Dq[55 : 48], Addr, Ba, Clk[1], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[6]);
    sdr U7A (Dq[63 : 56], Addr, Ba, Clk[1], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[7]);

    `ifdef dual_rank
    sdr U0B (Dq[ 7 :  0], Addr, Ba, Clk[0], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[0]);
    sdr U1B (Dq[15 :  8], Addr, Ba, Clk[0], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[1]);
    sdr U2B (Dq[23 : 16], Addr, Ba, Clk[0], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[2]);
    sdr U3B (Dq[31 : 24], Addr, Ba, Clk[0], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[3]);
    sdr U4B (Dq[39 : 32], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[4]);
    sdr U5B (Dq[47 : 40], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[5]);
    sdr U6B (Dq[55 : 48], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[6]);
    sdr U7B (Dq[63 : 56], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[7]);
    `endif
`endif

`ifdef x16
    sdr U0A (Dq[15 :  0], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[1:0]);
    sdr U1A (Dq[31 : 16], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[3:2]);
    sdr U2A (Dq[47 : 32], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[5:4]);
    sdr U3A (Dq[63 : 48], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[7:6]);
    `ifdef dual_rank
    sdr U0B (Dq[15 :  0], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[1:0]);
    sdr U1B (Dq[31 : 16], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[3:2]);
    sdr U2B (Dq[47 : 32], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[5:4]);
    sdr U3B (Dq[63 : 48], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[7:6]);
    `endif
`endif

endmodule
