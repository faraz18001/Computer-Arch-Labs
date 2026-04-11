module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255]; // 256 instructions (1KB max)
    
    initial begin
        // Simple test program:
        // address 0: addi x1, x0, 10      (Instruction: 0x00A00093)
        // address 4: addi x2, x0, 5       (Instruction: 0x00500113)
        // address 8: add x3, x1, x2       (Instruction: 0x002081B3)
        // address 12: sw x3, 0(x0)        (Instruction: 0x00302023)
        // address 16: beq x1, x1, -4      (Instruction: 0xFE108EE3) Infinite loop
        
        mem[0] = 32'h00A00093; // addi x1, x0, 10
        mem[1] = 32'h00500113; // addi x2, x0, 5
        mem[2] = 32'h002081B3; // add x3, x1, x2
        mem[3] = 32'h00302023; // sw x3, 0(x0)
        mem[4] = 32'hFE108EE3; // beq x1, x1, -4 (branch to mem[3])
    end
    
    // Address is byte address, so shift by 2 to get word index
    assign instruction = mem[address[9:2]];

endmodule
