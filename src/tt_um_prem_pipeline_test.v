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

    // Connect inputs to outputs for testing
    assign uo_out = ui_in;       // drive outputs from inputs
    assign uio_out = uio_in;     // loop back IO inputs
    assign uio_oe = 8'hFF;       // enable all bidirectional pins

    // Instantiate pipeline module
    pipeline pipeline_inst (
        .clk(clk),
        .reset(rst),
        .PC_OUT(uo_out[0]),
        .DATA_MEM_OUT_TOP(uo_out[1])
    );
endmodule
