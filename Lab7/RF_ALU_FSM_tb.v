`timescale 1ns / 1ps​
​
module RF_ALU_FSM_tb;​
​
reg
clk, rst, WriteEnable;​
reg [4:0] rs1, rs2, rd;​
reg [31:0] WriteData;​
wire [31:0] ReadData1, ReadData2;​
​
reg [3:0] ALUControl;​
wire [31:0] ALUResult;​
wire
Zero;​
​
// Write-back Mux: 0 = manual WriteData, 1 = ALUResult​
reg wb_sel;​
wire [31:0] wb_data = wb_sel ? ALUResult : WriteData;​
​
// Instantiate Modules​
RegisterFile regfile (.clk(clk), .rst(rst),
.WriteEnable(WriteEnable), .rs1(rs1), .rs2(rs2), .rd(rd),
.WriteData(wb_data), .ReadData1(ReadData1), .ReadData2(ReadData2));​

ALU alu (.A(ReadData1), .B(ReadData2), .ALUControl(ALUControl),
.ALUResult(ALUResult), .Zero(Zero));​
​
// Clock Generation​
initial clk = 0;​
always #5 clk = ~clk;​
​
// FSM States​
reg [4:0] state;​
parameter IDLE
= 0;​
parameter WRITE_X1
= 1;​
parameter WRITE_X2
= 2;​
parameter WRITE_X3
= 3;​
parameter ALU_ADD
= 4;​
parameter ALU_SUB
= 5;​
parameter ALU_AND
= 6;​
parameter ALU_OR
= 7;​
parameter ALU_XOR
= 8;​
parameter ALU_SLL
= 9;​
parameter ALU_SRL
= 10;​
parameter BEQ_CHECK
= 11;​
parameter BEQ_WRITE
= 12;​
parameter RAW_WRITE
= 13;​
parameter RAW_READ
= 14;​
parameter VERIFY
= 15;​
parameter DONE
= 16;​
​
​
// FSM Logic​
always @(posedge clk or posedge rst) begin​
if (rst) begin​
state <= IDLE;​
WriteEnable <= 0;​
end else begin​
case (state)​
IDLE: begin​
state <= WRITE_X1;​
end​
​
WRITE_X1: begin​
wb_sel <= 0; rd <= 1; WriteData <= 32'h10101010;
WriteEnable <= 1;​
state <= WRITE_X2;​

end​
​
WRITE_X2: begin​
wb_sel <= 0; rd <= 2; WriteData <= 32'h01010101;
WriteEnable <= 1;​
state <= WRITE_X3;​
end​
​
WRITE_X3: begin​
wb_sel <= 0; rd <= 3; WriteData <= 32'h00000005;
WriteEnable <= 1;​
state <= ALU_ADD;​
end​
​
ALU_ADD: begin​
rs1 <= 1; rs2 <= 2; ALUControl <= 4'b0000; wb_sel
<= 1; rd <= 4; WriteEnable <= 1;​
state <= ALU_SUB;​
end​
​
ALU_SUB: begin​
rs1 <= 1; rs2 <= 2; ALUControl <= 4'b0001; wb_sel
<= 1; rd <= 5; WriteEnable <= 1;​
state <= ALU_AND;​
end​
​
ALU_AND: begin​
rs1 <= 1; rs2 <= 2; ALUControl <= 4'b0010; wb_sel
<= 1; rd <= 6; WriteEnable <= 1;​
state <= ALU_OR;​
end​
​
ALU_OR: begin​
rs1 <= 1; rs2 <= 2; ALUControl <= 4'b0011; wb_sel
<= 1; rd <= 7; WriteEnable <= 1;​
state <= ALU_XOR;​
end​
​
ALU_XOR: begin​
rs1 <= 1; rs2 <= 2; ALUControl <= 4'b0100; wb_sel
<= 1; rd <= 8; WriteEnable <= 1;​
state <= ALU_SLL;​
end​

​
ALU_SLL: begin​
rs1 <= 1; rs2 <= 3; ALUControl <= 4'b0110; wb_sel
<= 1; rd <= 9; WriteEnable <= 1;​
state <= ALU_SRL;​
end​
​
ALU_SRL: begin​
rs1 <= 1; rs2 <= 3; ALUControl <= 4'b0111; wb_sel
<= 1; rd <= 10; WriteEnable <= 1;​
state <= BEQ_CHECK;​
end​
​
BEQ_CHECK: begin​
rs1 <= 1; rs2 <= 1; ALUControl <= 4'b0001; // SUB
to check x1==x1​
WriteEnable <= 0; // Don't write yet​
state <= BEQ_WRITE;​
end​
​
BEQ_WRITE: begin​
wb_sel <= 0; rd <= 11; WriteData <= Zero ? 1 : 0;
WriteEnable <= 1;​
state <= RAW_WRITE;​
end​
​
RAW_WRITE: begin​
wb_sel <= 0; rd <= 12; WriteData <= 32'h0000BEEF;
WriteEnable <= 1;​
state <= RAW_READ;​
end​
​
RAW_READ: begin​
rs1 <= 12; WriteEnable <= 0;​
state <= VERIFY;​
end​
​
VERIFY: begin​
state <= DONE;​
end​
​
default: state <= IDLE;​
endcase​

end​
end​
​
​
endmodule
