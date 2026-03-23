`timescale 1ns / 1ps

module top (
    input  [3:0]  SW,    // 4 Switches for ALUControl
    output [15:0] LED    // 16 LEDs for showing all workings
);

    wire [31:0] A, B, ALUResult;
    wire Zero, Negative;

    // -------------------------------------------------------------
    // 1. FIXED INPUTS: A = 8, B = 2
    // -------------------------------------------------------------
    assign A = 32'd8; // Binary: 1000
    assign B = 32'd2; // Binary: 0010

    // -------------------------------------------------------------
    // 2. ALU INSTANTIATION
    // -------------------------------------------------------------
    ALU alu_inst (
        .A(A),
        .B(B),
        .ALUControl(SW[3:0]),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    assign Negative = ALUResult[31];

    // -------------------------------------------------------------
    // 3. LED MAPPING (A=8, B=2 always visible in the middle)
    // -------------------------------------------------------------
    assign LED[15]   = Zero;               // Left Flag
    assign LED[14]   = Negative;           // Right Flag
    assign LED[13]   = 1'b0;               // Spacer
    assign LED[12:9] = A[3:0];             // Shows '1000' (8)
    assign LED[8]    = 1'b0;               // Spacer
    assign LED[7:4]  = B[3:0];             // Shows '0010' (2)
    assign LED[3:0]  = ALUResult[3:0];     // The Result

endmodule
