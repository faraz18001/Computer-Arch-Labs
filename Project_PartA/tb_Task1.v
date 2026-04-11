`timescale 1ns / 1ps

module tb_Task1;

    // Inputs
    reg clk;
    reg reset;
    
    // Instruction to Decode
    reg [31:0] instr;
    
    // Control Signal
    reg PCSrc;

    // Wiresa
    wire [31:0] pc_out;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_branch;
    wire [31:0] pc_next;
    wire [31:0] imm_out;

    // Instantiate Modules for Task 1
    ProgramCounter u_pc (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_out)
    );

    pcAdder u_pcAdder (
        .pc(pc_out),
        .pc_next_seq(pc_plus_4)
    );

    immGen u_immGen (
        .instr(instr),
        .imm(imm_out)
    );

    branchAdder u_branchAdder (
        .pc(pc_out),
        .imm(imm_out),
        .pc_branch(pc_branch)
    );

    mux2 #(32) u_pcmux (
        .in0(pc_plus_4),
        .in1(pc_branch),
        .sel(PCSrc),
        .out(pc_next)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        PCSrc = 0;
        instr = 32'd0;

        // Reset the system
        #15;
        reset = 0;

        // --- Test 1: PC Increments by 4 when PCSrc = 0 ---
        #10;
        if (pc_out !== 32'd4) $display("Fail: PC did not increment to 4. Got %d", pc_out);
        else $display("Pass: PC incremented to 4.");

        #10;
        if (pc_out !== 32'd8) $display("Fail: PC did not increment to 8. Got %d", pc_out);
        else $display("Pass: PC incremented to 8.");

        // --- Test 2: Immediate Generation (I-Type: addi x2, x0, 5) ---
        // opcode=0010011, rd=00010, funct3=000, rs1=00000, imm=5 (0000 0000 0101)
        instr = 32'b000000000101_00000_000_00010_0010011; 
        #10;
        if (imm_out !== 32'd5) $display("Fail: I-Type Immediates. Got %d", imm_out);
        else $display("Pass: I-Type Immediate Generation Produced 5.");

        // --- Test 3: PC updates to Branch Target when PCSrc = 1 ---
        // Let's manually inject negative branch offset: -8
        // 12-bit of -8: 111111111000
        // Inst B-type fields: imm[12]=1, imm[11]=1, imm[10:5]=111111, imm[4:1]=1100, imm[0]=0
        // inst[31]=1, inst[7]=1, inst[30:25]=111111, inst[11:8]=1100
        // opcode for B-type = 1100011
        // Let's assume branch instruction at PC = 12, jumping to PC=4 (offset -8)
        instr = {1'b1, 6'b111111, 5'b00000, 5'b00000, 3'b000, 4'b1100, 1'b1, 7'b1100011}; 
        
        #10; // Let it compute the branch logic internally
        PCSrc = 1; // Trigger the branch
        
        #10;
        // Check new PC
        // Previous PC was 16. Target = 16 + (-8) = 8.
        if (pc_out !== 32'd8) $display("Fail: Branch PC. Expected 8, got %d", pc_out);
        else $display("Pass: Branch PC successfully updated to target.");

        #10;
        $finish;
    end

endmodule
