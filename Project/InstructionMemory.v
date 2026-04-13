module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255];
    
    initial begin
        // === MAIN PROGRAM ===
        mem[0]  = 32'h0FC00113;   // addi x2, x0, 252       (SP = 252, stack grows down)
        mem[1]  = 32'h10002503;   // lw   x10, 256(x0)      (Read N from switches via MMIO)
        mem[2]  = 32'h00C000EF;   // jal  x1, 12            (Call sum_of_n at mem[5])
        mem[3]  = 32'h00A02023;   // sw   x10, 0(x0)        (Store result for display)
        mem[4]  = 32'h00000063;   // beq  x0, x0, 0         (Trap: freeze)

        // === FUNCTION: sum_of_n ===
        // Input:  x10 = N
        // Output: x10 = sum(1..N)
        // Uses stack to save/restore return address
        mem[5]  = 32'hFFC10113;   // addi x2, x2, -4        (Push: SP -= 4)
        mem[6]  = 32'h00112023;   // sw   x1, 0(x2)         (Push: save RA to stack)
        mem[7]  = 32'h00004593;   // xori x11, x0, 0        (sum = 0, using XORI)
        mem[8]  = 32'h00000637;   // lui  x12, 0            (counter = 0, using LUI)
        mem[9]  = 32'h000500B7;   // lui  x1, 0x00050       (Demonstrate LUI with non-zero)
        mem[10] = 32'h00050863;   // beq  x10, x0, +16      (If N=0, skip to done at mem[14])

        // Loop
        mem[11] = 32'h00160613;   // addi x12, x12, 1       (counter++)
        mem[12] = 32'h00C585B3;   // add  x11, x11, x12     (sum += counter)
        mem[13] = 32'hFEA61CE3;   // bne  x12, x10, -8      (If counter != N, loop)

        // Done
        mem[14] = 32'h00058533;   // add  x10, x11, x0      (Move sum to x10 as return value)
        mem[15] = 32'h00012083;   // lw   x1, 0(x2)         (Pop: restore RA from stack)
        mem[16] = 32'h00410113;   // addi x2, x2, 4         (Pop: SP += 4)
        mem[17] = 32'h00008067;   // jalr x0, x1, 0         (Return to caller)
    end
    
    assign instruction = mem[address[9:2]];

endmodule
