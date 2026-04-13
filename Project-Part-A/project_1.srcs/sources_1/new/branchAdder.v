`timescale 1ns / 1ps

module branchAdder(
    input [31:0] currentPC,
    input [31:0] imm,
    output[31:0] nextPC
);

    assign nextPC = currentPC + imm;

endmodule