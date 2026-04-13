`timescale 1ns / 1ps
module ProgramCounter(
    input        clk, rst,
    input [31:0] next_PC,
    output reg [31:0] PC
);
    always @(posedge clk or posedge rst) begin
        if (rst) PC <= 32'b0;
        else     PC <= next_PC;
    end
endmodule