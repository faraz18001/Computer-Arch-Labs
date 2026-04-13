module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255]; // 256 instructions (1KB max)
    
    initial begin
        // ============================================================
        // === PART A: HARDCODED SERIES CALCULATION ===
        // === Calculates the Sum of the first 5 numbers 
        // === Demonstrates Base RISC-V capabilities (Loops & Addition)
        // ============================================================
        
        mem[0] = 32'h00000093; // addi x1, x0, 0      (sum = 0)
        mem[1] = 32'h00500113; // addi x2, x0, 5      (N = 5)
        mem[2] = 32'h00000193; // addi x3, x0, 0      (i = 0)
        
        // loop_start:
        mem[3] = 32'h00310863; // beq x2, x3, 16      (if N == i, jump 4 instructions to 'end')
        mem[4] = 32'h00118193; // addi x3, x3, 1      (i++)
        mem[5] = 32'h003080B3; // add x1, x1, x3      (sum += i)
        mem[6] = 32'hFE000AE3; // beq x0, x0, -12     (jump back to 'loop_start')
        
        // end:
        mem[7] = 32'h00102023; // sw x1, 0(x0)        (store sum (15) to memory)
        mem[8] = 32'h00000063; // beq x0, x0, 0       (Trap and freeze)
    end
    
    // Address is byte address, so shift by 2 to get word index
    assign instruction = mem[address[9:2]];

endmodule
