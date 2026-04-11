`timescale 1ns / 1ps

module tb_TopLevelProcessor;

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [31:0] show_pc;
    wire [31:0] show_alu_result;

    // Instantiate the Unit Under Test (UUT)
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .show_pc(show_pc),
        .show_alu_result(show_alu_result)
    );

    // Clock Generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;

        // Wait 20 ns for global reset to finish
        #20;
        
        // Deassert reset to start processor execution
        reset = 0;

        // Monitor the PC and ALU results
        $monitor("Time: %0dns | PC: %0d | ALU Result: %0d (Hex: %h)", $time, show_pc, show_alu_result, show_alu_result);
        
        // 5 instructions = initial loop is 50ns, then loops between sw and beq (2 clock cycles per loop)
        // Let's run it for 200ns
        #200;
        
        $display("Simulation finished.");
        $finish;
    end

endmodule
