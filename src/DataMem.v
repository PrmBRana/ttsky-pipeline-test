`default_nettype none
module DataMem(
    input  wire        clk,
    input  wire        reset,           // optional (can remove for FPGA)
    input  wire [31:0] aluAddress_in,   // byte address
    input  wire [31:0] DataWriteM_in,
    input  wire        memwriteM_in,
    input  wire [2:0]  func3,           // funct3 from instruction
    output reg  [31:0] DataMem_out
);

    // 20 KB memory → 5120 words (32-bit each)
    reg [31:0] DataMem [0:5119];

    integer i;

    // Reset logic
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 5120; i = i + 1) begin
                DataMem[i] <= 32'b0;
            end
        end else if (memwriteM_in) begin
            case (func3)
                3'b000: begin // SB (store byte)
                    case (aluAddress_in[1:0])
                        2'b00: DataMem[aluAddress_in[13:2]][7:0]   <= DataWriteM_in[7:0];
                        2'b01: DataMem[aluAddress_in[13:2]][15:8]  <= DataWriteM_in[7:0];
                        2'b10: DataMem[aluAddress_in[13:2]][23:16] <= DataWriteM_in[7:0];
                        2'b11: DataMem[aluAddress_in[13:2]][31:24] <= DataWriteM_in[7:0];
                        default: ;
                    endcase
                end
                3'b001: begin // SH (store halfword)
                    case (aluAddress_in[1:0])
                        2'b00: DataMem[aluAddress_in[13:2]][15:0]  <= DataWriteM_in[15:0];
                        2'b10: DataMem[aluAddress_in[13:2]][31:16] <= DataWriteM_in[15:0];
                        default: ; // ignore unaligned halfword writes
                    endcase
                end
                3'b010: DataMem[aluAddress_in[13:2]] <= DataWriteM_in; // SW (store word)
                default: ; // no write for unsupported funct3
            endcase
        end
    end

    // Combinational read logic
    always @(*) begin
        case (func3)
            3'b000: case (aluAddress_in[1:0]) // LB
                2'b00: DataMem_out = {{24{DataMem[aluAddress_in[13:2]][7]}}, DataMem[aluAddress_in[13:2]][7:0]};
                2'b01: DataMem_out = {{24{DataMem[aluAddress_in[13:2]][15]}}, DataMem[aluAddress_in[13:2]][15:8]};
                2'b10: DataMem_out = {{24{DataMem[aluAddress_in[13:2]][23]}}, DataMem[aluAddress_in[13:2]][23:16]};
                2'b11: DataMem_out = {{24{DataMem[aluAddress_in[13:2]][31]}}, DataMem[aluAddress_in[13:2]][31:24]};
                default: DataMem_out = 32'b0;
            endcase
            3'b001: case (aluAddress_in[1:0]) // LH
                2'b00: DataMem_out = {{16{DataMem[aluAddress_in[13:2]][15]}}, DataMem[aluAddress_in[13:2]][15:0]};
                2'b10: DataMem_out = {{16{DataMem[aluAddress_in[13:2]][31]}}, DataMem[aluAddress_in[13:2]][31:16]};
                default: DataMem_out = 32'b0;
            endcase
            3'b010: DataMem_out = DataMem[aluAddress_in[13:2]]; // LW
            3'b100: case (aluAddress_in[1:0]) // LBU
                2'b00: DataMem_out = {24'b0, DataMem[aluAddress_in[13:2]][7:0]};
                2'b01: DataMem_out = {24'b0, DataMem[aluAddress_in[13:2]][15:8]};
                2'b10: DataMem_out = {24'b0, DataMem[aluAddress_in[13:2]][23:16]};
                2'b11: DataMem_out = {24'b0, DataMem[aluAddress_in[13:2]][31:24]};
                default: DataMem_out = 32'b0;
            endcase
            3'b101: case (aluAddress_in[1:0]) // LHU
                2'b00: DataMem_out = {16'b0, DataMem[aluAddress_in[13:2]][15:0]};
                2'b10: DataMem_out = {16'b0, DataMem[aluAddress_in[13:2]][31:16]};
                default: DataMem_out = 32'b0;
            endcase
            default: DataMem_out = 32'b0;
        endcase
    end

endmodule
