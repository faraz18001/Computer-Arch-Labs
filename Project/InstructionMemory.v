module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:255];
    
    initial begin
        mem[0]  = 32'h000000B7;   // lui  x1, 0
        mem[1]  = 32'h10002103;   // lw   x2, 256(x0)
        mem[2]  = 32'h00004193;   // xori x3, x0, 0
        
        mem[3]  = 32'h00218863;   // beq  x3, x2, +16
        mem[4]  = 32'h00118193;   // addi x3, x3, 1
        mem[5]  = 32'h003080B3;   // add  x1, x1, x3
        mem[6]  = 32'hFE000AE3;   // beq  x0, x0, -12
        
        mem[7]  = 32'h00102023;   // sw   x1, 0(x0)
        mem[8]  = 32'h00000063;   // beq  x0, x0, 0
    end
    
    assign instruction = mem[address[9:2]];

endmodule
