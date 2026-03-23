`timescale 1ns / 1ps​
​
module tb_main_control;​
// Inputs​
reg [6:0] opcode;​
​

// Outputs​
wire RegWrite;​
wire [1:0] ALUOp;​
wire MemRead;​
wire MemWrite;​
wire ALUSrc;​
wire MemtoReg;​
wire Branch;​
​
// Instantiate the Unit Under Test (UUT)​
main_control uut (​
.opcode(opcode),​
.RegWrite(RegWrite),​
.ALUOp(ALUOp),​
.MemRead(MemRead),​
.MemWrite(MemWrite),​
.ALUSrc(ALUSrc),​
.MemtoReg(MemtoReg),​
.Branch(Branch)​
);​
​
initial begin​
// Open VCD file for GTKwave​
$dumpfile("main_control.vcd");​
$dumpvars(0, tb_main_control);​
​
$display("Testing Main Control");​
$display("Time | Opcode | RegWrite | ALUOp | MemRead | MemWrite | ALUSrc | MemtoReg | Branch");​
$monitor("%4t | %b |
%b
| %b
|
%b
|
%b
|
%b
|
%b
|
%b",​
$time, opcode, RegWrite, ALUOp, MemRead, MemWrite, ALUSrc, MemtoReg, Branch);​
​
// Initialize Inputs​
opcode = 0;​

​
// Wait 100 ns for global reset to finish​
#100;​
​
// Test R-type​
opcode = 7'b0110011; #20;​
​
// Test lw​
opcode = 7'b0000011; #20;​
​
// Test sw​
opcode = 7'b0100011; #20;​
​
// Test beq​
opcode = 7'b1100011; #20;​
​
// Test I-type​
opcode = 7'b0010011; #20;​
​
// Test invalid/unknown opcode to verify default assignments​
opcode = 7'b1111111; #20;​
​
#100;​
$finish;​
end​
endmodule
