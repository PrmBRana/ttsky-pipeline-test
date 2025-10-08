/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_prem_pipeline_test (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n
);

    wire rst = !rst_n;

    // Example: Drive output pins partially
    assign uio_out[7:3] = 5'b00000;
    assign uio_out[2:0] = 3'b101; // example pattern

    // Example: Set bidirectional pins as input mode
    assign uio_oe = 8'b00000000;:

    // Instantiate pipeline module
    pipeline pipeline (
        .clk(clk),
        .reset(rst),
        .PC_OUT(uo_out[0]),
        .DATA_MEM_OUT_TOP(uo_out[1])
    );

endmodule

