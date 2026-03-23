`timescale 1ns / 1ps​
module top_module_tb;​
​
// Parameters​
parameter CLOCK_FREQ = 10; // Speed up simulation (10 ticks = 1s)​
​
// Inputs​
reg clk;​
reg btnC;​
reg [15:0] sw;​
​
// Outputs​
wire [15:0] led;​
wire [6:0] seg;​
wire [3:0] an;​
​
// Instantiate the Unit Under Test (UUT)​
fsm_counter_top #(​
.CLOCK_FREQ(CLOCK_FREQ)​
) uut (​
.clk(clk), ​
.btnC(btnC), ​
.sw(sw), ​
.led(led), ​
.seg(seg), ​
.an(an)​
);​
​
// Clock generation​
initial begin​
clk = 0;​
forever #5 clk = ~clk;​
end​
​

initial begin​
// Generate waveform file​
$dumpfile("top_module_sim.vcd");​
$dumpvars(0, top_module_tb);​
​
// Initialize Inputs​
btnC = 1;​
sw = 0;​
​
// Wait for global reset​
#100;​
btnC = 0;​
#50;​
​
// Step 1: Arm the fsm (switches must be 0)​
sw = 16'h0000;​
#100;​
​
// Step 2: Set a value (bit 5 set = 5)​
sw = 16'h0020;​
#100;​
​
// Return switches to 0​
sw = 16'h0000;​
​
// Observe counting (needs more time for 5 counts)​
#1000;​
end​
​
endmodule
