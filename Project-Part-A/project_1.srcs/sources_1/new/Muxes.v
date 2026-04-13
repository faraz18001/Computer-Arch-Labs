`timescale 1ns / 1ps

module mux1(
    input memToReg,
    input [31:0] readData,
    input [31:0] aluResult,
    output [31:0] writeData
);
    assign writeData = memToReg? readData : aluResult;
endmodule




module mux2(
    input pcSrc,
    input [31:0] nonBranchPC,
    input [31:0] branchPC,
    output [31:0] nextPC
);
    assign nextPC = pcSrc? branchPC : nonBranchPC;
endmodule



module mux3(
    input aluSrc,
    input [31:0] rs2Data,
    input [31:0] imm,
    output [31:0] aluIn
);
    assign aluIn = aluSrc? imm : rs2Data;
endmodule
