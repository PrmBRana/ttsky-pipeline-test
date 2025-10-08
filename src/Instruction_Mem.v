`default_nettype none
module Ins_Mem (
    input  wire [31:0] read_Address,    // Program counter (word-aligned)
    output wire [31:0] Instruction_out  // Fetched instruction
);
    reg [31:0] I_Mem[0:255];

    // Word-aligned access with range masking
    assign Instruction_out = I_Mem[read_Address[9:2]];

endmodule
