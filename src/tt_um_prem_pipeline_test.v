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
    wire [31:0] PC_OUT;
    wire [31:0] DATA_MEM_OUT_TOP;

    // Instantiate pipeline module
    pipeline pipeline_inst (
        .clk(clk),
        .reset(rst),
        .PC_OUT(PC_OUT),
        .DATA_MEM_OUT_TOP(DATA_MEM_OUT_TOP)
    );

    // Map 32-bit outputs to 8-bit outputs
    // You can choose which bits to display - here using lower 8 bits
    assign uo_out = PC_OUT[7:0];           // Show lower 8 bits of PC
    assign uio_out = DATA_MEM_OUT_TOP[7:0]; // Show lower 8 bits of data memory
    
    // Enable all bidirectional pins as outputs
    assign uio_oe = 8'hFF;

endmodule