//`timescale 1ns / 1ps
//module ALUControl (
//    input  [1:0] ALUOp,
//    input  [2:0] funct3,
//    input        funct7_5,   // just bit 5 of funct7, distinguishes ADD vs SUB
//    output reg [3:0] ALUControl
//);
//    always @(*) begin
//        case (ALUOp)
//            2'b00: ALUControl = 4'b0011; // LOAD/STORE ? ADD
//            2'b01: ALUControl = 4'b0100; // BRANCH    ? SUB
//            2'b10: begin                 // R-type / I-type ? decode funct3/funct7
//                case (funct3)
//                    3'b000: ALUControl = (funct7_5) ? 4'b0100 : 4'b0011; // SUB : ADD
//                    3'b001: ALUControl = 4'b0101; // SLL
//                    3'b101: ALUControl = 4'b0110; // SRL (assuming no SRA for now)
//                    3'b111: ALUControl = 4'b0000; // AND
//                    3'b110: ALUControl = 4'b0001; // OR
//                    3'b100: ALUControl = 4'b0010; // XOR
//                    default: ALUControl = 4'b0011; // default ADD
//                endcase
//            end
//            default: ALUControl = 4'b0011;
//        endcase
//    end
//endmodule



`timescale 1ns / 1ps
module ALUControl (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_5,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0011;  // LOAD/STORE ? ADD
            2'b01: ALUControl = 4'b0100;  // BRANCH ? SUB
            2'b11: ALUControl = 4'b1000;  // LUI ? pass immediate through
            2'b10: begin
                case (funct3)
                    3'b000: ALUControl = funct7_5 ? 4'b0100 : 4'b0011; // SUB : ADD
                    3'b001: ALUControl = 4'b0101;  // SLL
                    3'b010: ALUControl = 4'b0111;  // SLT / SLTI ? NEW
                    3'b101: ALUControl = 4'b0110;  // SRL
                    3'b111: ALUControl = 4'b0000;  // AND
                    3'b110: ALUControl = 4'b0001;  // OR
                    3'b100: ALUControl = 4'b0010;  // XOR
                    default: ALUControl = 4'b0011;
                endcase
            end
            default: ALUControl = 4'b0011;
        endcase
    end
endmodule