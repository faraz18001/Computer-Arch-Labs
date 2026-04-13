module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255];
    
    initial begin
        mem[0]  = 32'h000000B7;   // lui  x1, 0             (TEST 1: Set sum to 0 using LUI)
        mem[1]  = 32'h10002103;   // lw   x2, 256(x0)       (Read physical switches constraint)
        mem[2]  = 32'h00004193;   // xori x3, x0, 0         (TEST 2: Set counter to 0 using XORI)
        
        mem[3]  = 32'h00010863;   // beq  x2, x0, +16       (Edge Case Handler: If N=0, exit safely)
        
        // --- LOOP DYNAMICS ---
        mem[4]  = 32'h00118193;   // addi x3, x3, 1         (Counter i++)
        mem[5]  = 32'h003080B3;   // add  x1, x1, x3        (Sum += i)
        mem[6]  = 32'hFE219CE3;   // bne  x3, x2, -8        (TEST 3: Loop dynamically using BNE!)
        
        mem[7]  = 32'h00102023;   // sw   x1, 0(x0)         (Logic Exit)
        mem[8]  = 32'h00000063;   // beq  x0, x0, 0         (Trap cleanly)
    end
    
    assign instruction = mem[address[9:2]];

endmodule
