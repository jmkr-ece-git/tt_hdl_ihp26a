/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_jmkr_ece_git_code_lock(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Internal wires
  wire lock;
  wire [2:0] debug;

  // Instantiate code_lock module
  code_lock code_lock_inst (
    .clk(clk),
    .reset(rst_n),           // Convert active-low reset to active-high
    .enter(ui_in[4]),         // Use bit 4 as enter signal
    .code(ui_in[3:0]),        // Use bits 3:0 as 4-bit code input
    .lock(lock),
    .debug(debug)
  );

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = {1'b0, debug, lock, 4'b0};  // Map lock to bit 0, debug to bits 3:1
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in, 1'b0};

endmodule
