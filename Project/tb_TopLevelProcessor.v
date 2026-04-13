`timescale 1ns / 1ps

module tb_TopLevelProcessor;

    reg clk;
    reg reset;
    reg [15:0] sw;

    wire [31:0] show_pc;
    wire [31:0] show_alu_result;

    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .show_pc(show_pc),
        .show_alu_result(show_alu_result),
        .switches(sw)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        sw = 16'd8; // N = 8

        #20;
        reset = 0;

        #800;
        
        $display("=== Final Register State ===");
        $display("x1  (RA)      = %0d (hex: %h)", uut.rf.regs[1], uut.rf.regs[1]);
        $display("x2  (SP)      = %0d", uut.rf.regs[2]);
        $display("x10 (result)  = %0d (hex: %h)", uut.rf.regs[10], uut.rf.regs[10]);
        $display("x11 (sum)     = %0d", uut.rf.regs[11]);
        $display("x12 (counter) = %0d", uut.rf.regs[12]);
        $display("Simulation finished.");
        $finish;
    end

    always @(negedge clk) begin
        if (!reset) begin
            $display("T=%0dns PC=%h Instr=%h | Jump=%b JumpReg=%b PCSrc=%b | x1=%0d x10=%0d x11=%0d x12=%0d", 
                     $time, show_pc, uut.instr,
                     uut.Jump, uut.JumpReg, uut.PCSrc,
                     uut.rf.regs[1], uut.rf.regs[10], uut.rf.regs[11], uut.rf.regs[12]);
        end
    end

endmodule
