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
        $dumpfile("simulation.vcd");
        $dumpvars(0, tb_TopLevelProcessor);

        // Initialize Inputs
        clk = 0;
        reset = 1;

        // Wait 20 ns for global reset to finish
        #20;
        
        // Deassert reset to start processor execution
        reset = 0;

        // Run for 800ns to cover all Part B tests + Part C loop (N=10)
        #800;
        
        $display("=== Final Register State ===");
        $display("x1 (sum) = %0d", uut.rf.regs[1]);
        $display("x2 (N)   = %0d", uut.rf.regs[2]);
        $display("x3 (i)   = %0d", uut.rf.regs[3]);
        $display("x4       = %0d", uut.rf.regs[4]);
        $display("x5       = %0d", uut.rf.regs[5]);
        $display("Simulation finished.");
        $finish;
    end

    always @(negedge clk) begin
        if (!reset) begin
            $display("Time=%0dns | PC=%h | Instr=%h | ALURes=[%h] %0d | x1=%0d, x2=%0d, x3=%0d, x4=%0d, x5=%0d", 
                     $time, show_pc, uut.instr, show_alu_result, $signed(show_alu_result), 
                     uut.rf.regs[1], uut.rf.regs[2], uut.rf.regs[3],
                     uut.rf.regs[4], uut.rf.regs[5]);
        end
    end

endmodule
