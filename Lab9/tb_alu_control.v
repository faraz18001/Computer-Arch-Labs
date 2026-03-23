`timescale 1ns / 1ps​

​
module tb_alu_control;​
​
// Inputs​
reg [1:0] ALUOp;​
reg [2:0] funct3;​
reg [6:0] funct7;​
​
// Outputs​
wire [3:0] ALUControl;​
​
// Instantiate the Unit Under Test (UUT)​
alu_control uut (​
.ALUOp(ALUOp),​
.funct3(funct3),​
.funct7(funct7),​
.ALUControl(ALUControl)​
);​
​
initial begin​
// Open VCD file for GTKwave​
$dumpfile("alu_control.vcd");​
$dumpvars(0, tb_alu_control);​
​
$display("Testing ALU Control");​
$display("Time | ALUOp | funct3 | funct7 | ALUControl");​
$monitor("%4t | %b
| %b
| %b |
%b",​
$time, ALUOp, funct3, funct7, ALUControl);​
​
// Intialize to 0​
ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000;​
​
// Wait 100 ns for global reset to finish​

#100;​
​
// Test lw / sw (ALUOp = 00) -> ADD​
ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;​
​
// Test beq (ALUOp = 01) -> SUB​
ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;​
​
// Test R-type ADD (ALUOp = 10, funct3 = 000, funct7 = 0000000) -> ADD​
ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #10;​
​
// Test R-type SUB (ALUOp = 10, funct3 = 000, funct7 = 0100000) -> SUB​
ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #10;​
​
// Test R-type AND (ALUOp = 10, funct3 = 111, funct7 = 0000000) -> AND​
ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #10;​
​
// Test R-type OR (ALUOp = 10, funct3 = 110, funct7 = 0000000) -> OR​
ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000; #10;​
​
// End simulation​
#20;​
$finish;​
end​
endmodule
