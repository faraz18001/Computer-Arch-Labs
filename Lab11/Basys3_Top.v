module Basys3_Top (
    input clk,            // 100MHz clock from Basys3 board
    input btnC,           // Center Button for Reset
    input btnU,           // Up button (Wait, let's use switches or just a slow clock)
    input [15:0] sw,      // Switches to select what to view
    output [15:0] led     // 16 LEDs
);

    // 1. Create a slow clock so you can see the processor running with your eyes
    reg [26:0] clk_div;
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    wire slow_clk = clk_div[26]; // roughly 0.75 Hz

    wire [31:0] pc_val;
    wire [31:0] alu_val;

    // 2. Instantiate your RISC-V Processor
    TopLevelProcessor cpu (
        .clk(slow_clk), 
        .reset(btnC),
        .show_pc(pc_val),
        .show_alu_result(alu_val)
    );

    // 3. Connect the bottom 16 bits of either the PC or the ALU result to the LEDs
    // If switch 0 is ON, show PC. If OFF, show ALU Result.
    assign led = sw[0] ? pc_val[15:0] : alu_val[15:0];

endmodule
