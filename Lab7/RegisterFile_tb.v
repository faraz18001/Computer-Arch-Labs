`timescale 1ns / 1ps​
​
module RegisterFile_tb;​
​
reg
clk, rst, WriteEnable;​

reg [4:0] rs1, rs2, rd;​
reg [31:0] WriteData;​
wire [31:0] ReadData1, ReadData2;​
​
RegisterFile uut (​
.clk(clk), .rst(rst), .WriteEnable(WriteEnable),​
.rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),​
.ReadData1(ReadData1), .ReadData2(ReadData2)​
);​
​
initial clk = 0;​
always #5 clk = ~clk;​
​
initial begin​
​
​
// Init​
rst = 0; WriteEnable = 0;​
rs1 = 0; rs2 = 0; rd = 0; WriteData = 0;​
​
// Reset​
rst = 1; #10;​
rst = 0; #10;​
​
// Test i: Write 0xDEADBEEF to x5, read it back​
rd = 5; WriteData = 32'hDEADBEEF; WriteEnable = 1;​
@(posedge clk); #1;​
WriteEnable = 0;​
rs1 = 5; #1;​
​
​
rs2 = 5; #1;​
​
​
// Test ii: Write to x0, should stay 0​
rd = 0; WriteData = 32'hCAFEBABE; WriteEnable = 1;​
@(posedge clk); #1;​
WriteEnable = 0;​
rs1 = 0; #1;​
​
​
// Test iii: Write to x10 and x20, read both at same time​
rd = 10; WriteData = 32'hAAAAAAAA; WriteEnable = 1;​

@(posedge clk); #1;​
rd = 20; WriteData = 32'h55555555;​
@(posedge clk); #1;​
WriteEnable = 0;​
rs1 = 10; rs2 = 20; #1;​
​
​
// Test iv: Overwrite x5 with new value​
rd = 5; WriteData = 32'h12345678; WriteEnable = 1;​
@(posedge clk); #1;​
WriteEnable = 0;​
rs1 = 5; #1;​
​
​
// Test v: Reset clears everything​
rst = 1; #10;​
rst = 0;​
rs1 = 5; rs2 = 10; #1;​
​
​
$finish;​
end​
​
endmodule
