module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255]; // 256 instructions (1KB max) 32 Bit wide each slot.
    
    initial begin

        // ============================================================
        // === Part B: Instruction Extension Tests ===
        // === TEST 1: LUI (U-type) ===
        // ============================================================
        mem[0]  = 32'h123450B7;   // lui  x1, 0x12345       → x1 = 0x12345000

        // === TEST 2: XORI (I-type) ===
        mem[1]  = 32'h00F00093;   // addi x1, x0, 15        → x1 = 15 (0x0000000F)
        mem[2]  = 32'h0060C113;   // xori x2, x1, 6         → x2 = 15 ^ 6 = 9

        // === TEST 3: BNE (B-type) ===
        mem[3]  = 32'h00300193;   // addi x3, x0, 3         → x3 = 3 (loop limit)
        mem[4]  = 32'h00000213;   // addi x4, x0, 0         → x4 = 0 (counter)
        // loop_bne_test:  (addr = 5*4 = 20 = 0x14)
        mem[5]  = 32'h00120213;   // addi x4, x4, 1         → x4++
        mem[6]  = 32'hFE321EE3;   // bne  x4, x3, -4        → if x4 != 3, goto mem[5]
        mem[7]  = 32'h06300293;   // addi x5, x0, 99        → x5 = 99 (proves bne exited)

        // ============================================================
        // === Part C: Sum of N Numbers (1 + 2 + ... + N) ===
        // === N = 10, Expected sum = 55 ===
        // === Uses LUI, XORI, ADDI, ADD, BNE, SW ===
        // ============================================================
        // Setup
        mem[8]  = 32'h000000B7;   // lui  x1, 0             → x1 = 0 (sum)
        // mem[9]  = 32'h00A04113;   // xori x2, x0, 10        → x2 = 10 (HARDCODED N)
        mem[9]  = 32'h10002103;   // lw   x2, 256(x0)       → READ SWITCHES from Address 0x100!
        mem[10] = 32'h00004193;   // xori x3, x0, 0         → x3 = 0 (counter i)
        // loop_sum:  (addr = 11*4 = 44 = 0x2C)
        mem[11] = 32'h00118193;   // addi x3, x3, 1         → i++
        mem[12] = 32'h003080B3;   // add  x1, x1, x3        → sum += i
        mem[13] = 32'hFE219CE3;   // bne  x3, x2, -8        → if i != N, goto mem[11]
        mem[14] = 32'h00102023;   // sw   x1, 0(x0)         → store sum (55) to mem[0]
        mem[15] = 32'h00000063;   // beq  x0, x0, 0         → TRAP: Infinite loop to stop the program!
    end
    
    // Address is byte address, so shift by 2 to get word index
    assign instruction = mem[address[9:2]];

endmodule
