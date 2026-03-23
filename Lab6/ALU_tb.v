module ALU_tb;

    reg  [31:0]  A;
    reg  [31:0]  B;
    reg  [3:0]   ALUControl;
    wire [31:0]  ALUResult;
    wire         Zero;

    // Instantiate ALU
    ALU dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);

        $display("Time\t A\t B\t ALUControl\t ALUResult\t Zero");
        $monitor("%0t\t %h\t %h\t %b\t %h\t %b", $time, A, B, ALUControl, ALUResult, Zero);

        // Test ADD
        A = 32'd5; B = 32'd3; ALUControl = 4'b0000; #10;

        // Test SUB
        A = 32'd10; B = 32'd4; ALUControl = 4'b0001; #10;

        // Test AND
        A = 32'h0000FFFF; B = 32'hFFFF0000; ALUControl = 4'b0010; #10;

        // Test OR
        A = 32'h0000FFFF; B = 32'hFFFF0000; ALUControl = 4'b0011; #10;

        // Test XOR
        A = 32'hAAAAAAAA; B = 32'h55555555; ALUControl = 4'b0100; #10;

        // Test SLL
        A = 32'h00000001; B = 32'd4; ALUControl = 4'b0101; #10;

        // Test SRL
        A = 32'hF0000000; B = 32'd4; ALUControl = 4'b0110; #10;

        // Test SRA
        A = 32'hF0000000; B = 32'd4; ALUControl = 4'b0111; #10;

        // Test SLT
        A = -32'd5; B = 32'd3; ALUControl = 4'b1000; #10; // -5 < 3 is true (1)
        A = 32'd5; B = -32'd3; ALUControl = 4'b1000; #10; // 5 < -3 is false (0)

        // Test SLTU
        A = 32'hFFFFFFFF; B = 32'h00000001; ALUControl = 4'b1001; #10; // Unsigned: huge > 1 (0)

        // Test Zero flag
        A = 32'd100; B = 32'd100; ALUControl = 4'b0001; #10;

        $display("Testbench completed successfully.");
        $finish;
    end

endmodule
