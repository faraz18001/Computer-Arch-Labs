module immGen (
    input [31:0] instr,
    output reg [31:0] imm
);
    wire [6:0] opcode = instr[6:0];
    
    always @(*) begin
        case (opcode)
            7'b0010011, 7'b0000011, 7'b1100111: // I-type (ALU imm, Load, JALR)
                imm = {{20{instr[31]}}, instr[31:20]};
                
            7'b0100011: // S-type (Store)
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                
            7'b1100011: // B-type (Branch)
                // Note: branchAdder will shift this by 1
                imm = {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]};
                
            7'b1101111: // J-type (JAL)
                // Assuming pcAdder/branchAdder is used for JAL too, JAL branches to pc + (imm << 1)
                imm = {{12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21]};
                
            7'b0110111, 7'b0010111: // U-type (LUI, AUIPC)
                imm = {instr[31:12], 12'b0};
                
            default:
                imm = 32'b0;
        endcase
    end
endmodule
