module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255]; // 256 instructions (1KB max) 32 Bit wide each slot.
    


//Show PC ON Seven  Using 7-Segment Display BNE Instruction.
//Show all the control singals.



    initial begin

        // Part B: Instruction Extension Tests

        // TEST 1: LUI (U-type)
        mem[0]  = 32'h123450B7;   // lui  x1, 0x12345       → x1 = 0x12345000

        // TEST 2: XORI (I-type)
        mem[1]  = 32'h00F00093;   // addi x1, x0, 15        → x1 = 15
        mem[2]  = 32'h0060C113;   // xori x2, x1, 6         → x2 = 15 ^ 6 = 9

        // TEST 3: JAL (J-type)
        mem[3]  = 32'h008002EF;   // jal  x5, 8             → Jump to mem[5], x5 = PC+4 = 16
        mem[4]  = 32'h04D00313;   // addi x6, x0, 77        → SKIPPED (proves jump happened)
        mem[5]  = 32'h02A00393;   // addi x7, x0, 42        → x7 = 42 (proves JAL landed here)

        // Trap
        mem[6]  = 32'h00000063;   // beq  x0, x0, 0         → Infinite loop
    end
    
    // Address is byte address, so shift by 2 to get word index
    assign instruction = mem[address[9:2]];

endmodule
