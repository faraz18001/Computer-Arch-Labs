module Basys3_Top (
    input clk,            // 100MHz clock from Basys3 board
    input btnC,           // Center Button for Reset
    input btnU,           // Up button
    input [15:0] sw,      // Switches to select what to view
    output [15:0] led,    // 16 LEDs
    output [6:0] seg,     // 7-segment display segments
    output [3:0] an       // 7-segment display targets
);

    // Create a slow clock
    reg [26:0] clk_div;
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    wire slow_clk = clk_div[26];

    wire [31:0] pc_val;
    wire [31:0] alu_val;

    // Instantiate CPU
    TopLevelProcessor cpu (
        .clk(slow_clk), 
        .reset(btnC),
        .show_pc(pc_val),
        .show_alu_result(alu_val)
    );

    wire [15:0] display_val = sw[0] ? pc_val[15:0] : alu_val[15:0];
    assign led = display_val;
    
    seven_seg_controller display (
        .clk(clk),           // Use the fast 100Mhz clock for smooth multiplexing
        .value(display_val),
        .seg(seg),
        .an(an)
    );

endmodule
