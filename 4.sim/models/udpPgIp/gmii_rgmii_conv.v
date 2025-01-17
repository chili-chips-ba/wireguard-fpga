/*
 * GMII - RGMII convertor
 *
 * Copyright (c) 2025 Simon Southwell.
 *
 * This file is part of udp_ip_pg.
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * The code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this code. If not, see <http://www.gnu.org/licenses/>.
 *
 */

// --------------------------------------------
// Timescale
// --------------------------------------------

`timescale 1ps/1ps

// --------------------------------------------
// DEFINES
// --------------------------------------------

`define HoldDly                      100

// ============================================
//  MODULE
// ============================================

module gmii_rgmii_conv
(
  input                               clk,

  // GMII to RGMII
  input      [7:0]                    gmiitxd,
  input                               gmiitxen,
  input                               gmiitxer,

  output     [3:0]                    rgmiitxd,
  output                              rgmiitxctl,

  // RGMII to GMII
  input      [3:0]                    rgmiirxd,
  input                               rgmiirxctl,

  output reg [7:0]                    gmiirxd,
  output reg                          gmiirxdv,
  output reg                          gmiirxer
);

reg   [3:0] gmiirxdlo;
reg   [3:0] gmiirxdhi;
reg         gmiirxdv_int;
reg         gmiirxer_int;

reg   [7:0] gmiirxdneg;
reg         gmiirxdvneg;
reg         gmiirxerneg;

// Time-division multiplex the GMII TX input onto RGMII
// with a hold delay (needed, even for Verilator, since using clock
// as mux control, and must ensure signals are sample corrrectly
// at destination).
assign #`HoldDly rgmiitxd           = clk ? gmiitxd[3:0] : gmiitxd[7:4];
assign #`HoldDly rgmiitxctl         = clk ? gmiitxen     : gmiitxer;

always @(posedge clk)
begin
  // Sample high nibble RX input
  gmiirxdhi                        <= rgmiirxd;
  gmiirxer_int                     <= rgmiirxctl;

  // RX output alignment stage on rising edge1
  gmiirxd                          <= gmiirxdneg;
  gmiirxdv                         <= gmiirxdvneg;
  gmiirxer                         <= gmiirxerneg;
end

always @(negedge clk)
begin
  // Sample low nibble RX input
  gmiirxdlo                        <= rgmiirxd;
  gmiirxdv_int                     <= rgmiirxctl;

  // Construct wide GMII RX on falling egde
  gmiirxdneg                       <= {gmiirxdhi, gmiirxdlo};
  gmiirxdvneg                      <= gmiirxdv_int;
  gmiirxerneg                      <= gmiirxer_int;
end

endmodule