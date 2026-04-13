//`timescale 1ns / 1ps

//module immGen(
//    input [31:0] instr,
//    input [6:0] opcode,
//    output reg [31:0] imm
//);
  
//    always @(*) begin
//        case(opcode)
//            7'b0010011, 7'b0000011, 7'b1100111: // I-type (ADDI, LW, JALR)
//                imm = {{20{instr[31]}}, instr[31:20]};
//            7'b0100011:                         // S-type (SW)
//                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
//            7'b1100011:                         // B-type (BEQ)
//                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
//            7'b1101111:                         // J-type (JAL)
//                //left shift by padding a 0 at the right side
//                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
//            default: imm = 32'b0;
//        endcase
//    end
    
//endmodule  


`timescale 1ns / 1ps
module immGen(
    input  [31:0] instr,
    input  [6:0]  opcode,
    output reg [31:0] imm
);
    always @(*) begin
        case(opcode)
            7'b0010011, 7'b0000011, 7'b1100111:
                imm = {{20{instr[31]}}, instr[31:20]};        // I-type
            7'b0100011:
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
            7'b1100011:
                imm = {{19{instr[31]}}, instr[31], instr[7],
                       instr[30:25], instr[11:8], 1'b0};      // B-type
            7'b1101111:
                imm = {{11{instr[31]}}, instr[31], instr[19:12],
                       instr[20], instr[30:21], 1'b0};        // J-type
            7'b0110111:
                imm = {instr[31:12], 12'b0};                  // U-type (LUI)
            default: imm = 32'b0;
        endcase
    end
endmodule