module ALU (
    input  [6:0]  SW,    // Use individual switches for operations
    output [15:0] LED    // Use 15 LEDs for result, 1 for Zero
);

    // Hardcoded values as requested
    wire [31:0] A = 32'd8;
    wire [31:0] B = 32'd2;

    reg [31:0] result;

    always @(*) begin
        // Use switches for operations instead of a 4-bit code
        if      (SW[0]) result = A + B;          // SW0: ADD
        else if (SW[1]) result = A - B;          // SW1: SUB
        else if (SW[2]) result = A & B;          // SW2: AND
        else if (SW[3]) result = A | B;          // SW3: OR
        else if (SW[4]) result = A ^ B;          // SW4: XOR
        else if (SW[5]) result = A << B[4:0];    // SW5: SLL
        else if (SW[6]) result = A >> B[4:0];    // SW6: SRL
        else            result = 32'd0;          // Default: All Off
    end

    // Result in 15 LEDs
    assign LED[14:0] = result[14:0];

    // Zero Flag on the 16th LED
    assign LED[15] = (result == 32'd0);

endmodule
