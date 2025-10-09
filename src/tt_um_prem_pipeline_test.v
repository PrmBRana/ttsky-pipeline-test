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

    // Clean unused inputs
    wire [7:0] ui_in_clean  = ui_in & 8'b00000000;
    wire [7:0] uio_in_clean = uio_in & 8'b00000000;

    // Unused dedicated outputs
    assign uo_out[7:2] = 6'b000000;

    // Unused bidirectional outputs and enable
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Intermediate wires for pipeline outputs
    wire pc_out, data_mem_out_top;
    assign uo_out[0] = pc_out;
    assign uo_out[1] = data_mem_out_top;

    // Instantiate pipeline module
    pipeline pipeline_inst (
        .clk(clk),
        .reset(rst),
        .PC_OUT(pc_out),
        .DATA_MEM_OUT_TOP(data_mem_out_top)
    );

endmodule
