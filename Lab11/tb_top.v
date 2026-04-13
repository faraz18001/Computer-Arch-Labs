`timescale 1ns/1ps

module tb_top ();
    reg clk;
    reg reset;
    
    TopLevelProcessor cpu (
        .clk(clk),
        .reset(reset)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, tb_top);
        
        clk = 0;
        reset = 1;
        
        #15;
        reset = 0;
        
        // Let it run for 100ns (10 clock cycles) to see the simple program execute and loop
        #100;
        $display("Execution complete. Inspect top.vcd for waveforms.");
        $finish;
    end
endmodule
