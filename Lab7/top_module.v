`timescale 1ns / 1ps​
​
module top_module(​
input
clk,​
input
btnC,
// Center button = switch between
WRITE/ALU mode​
input
btnU,
// Up button = WriteEnable​
input [15:0] sw,
// sw[15] = reset, sw[7:0] = data or
ALU control​
output [15:0] led
// 16 LEDs on Basys 3​
);​
​
// sw[15] = reset​
wire rst = sw[15];​
​
// Debounce buttons​
wire btnC_debounced, btnU_debounced;​
debouncher btn_c_deb (.clk(clk), .pbin(btnC),
.pbout(btnC_debounced));​
debouncher btn_u_deb (.clk(clk), .pbin(btnU),

.pbout(btnU_debounced));​
​
// Edge detect for btnC​
reg btnC_prev;​
wire btnC_pulse = btnC_debounced & ~btnC_prev;​
always @(posedge clk) btnC_prev <= btnC_debounced;​
​
// Switch interface​
wire [31:0] switch_data;​
switches sw_module (​
.clk(clk), .rst(rst),​
.btns(16'b0),​
.writeData(32'b0), .writeEnable(1'b0),​
.readEnable(1'b1),​
.memAddress(30'b0),​
.switches(sw),​
.readData(switch_data)​
);​
​
// Register File​
reg [4:0] rf_rs1, rf_rs2, rf_rd;​
wire [31:0] rf_rd1, rf_rd2;​
​
RegisterFile regfile (​
.clk(clk), .rst(rst), .WriteEnable(btnU_debounced),​
.rs1(rf_rs1), .rs2(rf_rs2), .rd(rf_rd),​
.WriteData({24'b0, switch_data[7:0]}), // sw[7:0] = data to
write​
.ReadData1(rf_rd1), .ReadData2(rf_rd2)​
);​
​
// ALU​
wire [31:0] ALUResult;​
wire
Zero;​
​
ALU alu (​
.A(rf_rd1),​
.B(rf_rd2),​
.ALUControl(switch_data[3:0]),​
.ALUResult(ALUResult),​
.Zero(Zero)​
);​
​

// FSM: only 2 modes​
reg mode; // 0 = WRITE mode, 1 = ALU mode​
reg [15:0] led_out;​
assign led = led_out;​
​
always @(posedge clk or posedge rst) begin​
if (rst) begin​
mode <= 0;​
rf_rs1 <= 0; rf_rs2 <= 0; rf_rd <= 0;​
led_out <= 0;​
end else begin​
if (btnC_pulse) mode <= ~mode; // toggle mode​
​
if (mode == 0) begin​
// WRITE MODE: sw[7:0] = data, btnU = write to x5​
rf_rd <= 5;​
rf_rs1 <= 5;​
led_out <= rf_rd1[15:0]; // show current x5 value​
end else begin​
// ALU MODE: sw[3:0] = ALU control, uses x1 and x2​
rf_rs1 <= 1;​
rf_rs2 <= 2;​
led_out <= {Zero, ALUResult[14:0]};​
end​
end​
end​
​
// LED interface module​
leds led_module (​
.clk(clk), .rst(rst),​
.writeData({16'b0, led_out}),​
.writeEnable(1'b1),​
.readEnable(1'b0),​
.memAddress(30'b0),​
.readData(),​
.leds()​
);​
​
endmodule
