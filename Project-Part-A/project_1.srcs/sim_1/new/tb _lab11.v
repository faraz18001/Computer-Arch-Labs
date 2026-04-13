`timescale 1ns / 1ps
module tb_lab11_task1;

    // ==========================================
    // CLOCK AND RESET
    // ==========================================
    reg clk, rst;
    always #5 clk = ~clk; // 100MHz clock, period = 10ns

    // ==========================================
    // WIRES
    // ==========================================
    
    wire [31:0] PC;
    wire [31:0] PCplus4;
    wire [31:0] branchTarget;
    wire [31:0] next_PC;
    reg         pcSrc;

    // For immGen testing
    reg  [31:0] instr_tb;
    wire [6:0]  opcode_tb = instr_tb[6:0];
    wire [31:0] imm_out;

    // ==========================================
    // MODULE INSTANTIATIONS
    // ==========================================
    ProgramCounter pc_inst (
        .clk    (clk),
        .rst    (rst),
        .next_PC(next_PC),
        .PC     (PC)
    );

    pcAdder pc_adder_inst (
        .currentPC(PC),
        .nextPC   (PCplus4)
    );

    branchAdder branch_adder_inst (
        .currentPC(PC),
        .imm      (imm_out),      // use immGen output as branch offset
        .nextPC   (branchTarget)
    );

    mux2 pc_mux (
        .pcSrc      (pcSrc),
        .nonBranchPC(PCplus4),
        .branchPC   (branchTarget),
        .nextPC     (next_PC)
    );

    immGen imm_gen_inst (
        .instr (instr_tb),
        .opcode(opcode_tb),
        .imm   (imm_out)
    );

    // ==========================================
    // TEST SEQUENCE
    // ==========================================
    initial begin
        // Initialize
        clk   = 0;
        rst   = 1;
        pcSrc = 0;
        instr_tb = 32'b0;

        // Apply reset
        #20;
        rst = 0;
        $display("=== PC INCREMENT TESTS (PCSrc = 0) ===");
        $display("After reset: PC = %0d (expected 0)", PC);

        // ==========================================
        // TEST 1: PC increments by 4 each cycle
        // ==========================================
        pcSrc = 0; // sequential execution
        repeat(5) begin
            @(posedge clk); #1;
            $display("PC = %0d,  PC+4 = %0d", PC, PCplus4);
        end

        // ==========================================
        // TEST 2: PC jumps to branch target
        // ==========================================
        $display("");
        $display("=== BRANCH TARGET TESTS (PCSrc = 1) ===");

        // Simulate BEQ with imm = +20
        // B-type instruction encoding for imm=20:
        // imm=20 = 0b10100, bits[4:1]=1010, bit[11]=0, bit[12]=0
        // BEQ opcode = 1100011, funct3 = 000, rs1=x0, rs2=x0
        instr_tb = 32'b0_000000_00000_00000_000_1010_0_1100011;
        // imm should be 20 (0x14)
        #1;
        $display("B-type imm=+20: immGen output = %0d (expected 20)", $signed(imm_out));

        pcSrc = 1; // take the branch
        @(posedge clk); #1;
        $display("After branch: PC = %0d, branchTarget = %0d", PC, branchTarget);
        $display("(branch target should be previous_PC + 20)");

        // ==========================================
        // TEST 3: Negative branch offset (jump backwards)
        // ==========================================
        $display("");
        $display("=== NEGATIVE BRANCH TEST ===");

        // BEQ with imm = -4
        // -4 in 13-bit signed = 1_1111111_1100
        // bit[12]=1, bit[11]=1, bits[10:5]=111111, bits[4:1]=1100
        instr_tb = 32'b1_111111_00000_00000_000_1100_1_1100011;
        #1;
        $display("B-type imm=-4: immGen output = %0d (expected -4)", $signed(imm_out));

        pcSrc = 1;
        @(posedge clk); #1;
        $display("After branch: PC = %0d", PC);

        // ==========================================
        // TEST 4: immGen I-type (ADDI)
        // ==========================================
        $display("");
        $display("=== IMMGEN I-TYPE TESTS ===");
        pcSrc = 0; // back to sequential

        // addi x18, x18, -1  ?  imm should be -1
        instr_tb = 32'hFFF90913;
        #1;
        $display("ADDI imm=-1:  immGen output = %0d (expected -1)", $signed(imm_out));

        // addi x8, x0, 512  ?  imm should be 512
        instr_tb = 32'h20000413;
        #1;
        $display("ADDI imm=512: immGen output = %0d (expected 512)", $signed(imm_out));

        // addi x9, x0, 256  ?  imm should be 256
        instr_tb = 32'h10000493;
        #1;
        $display("ADDI imm=256: immGen output = %0d (expected 256)", $signed(imm_out));

        // ==========================================
        // TEST 5: immGen S-type (SW)
        // ==========================================
        $display("");
        $display("=== IMMGEN S-TYPE TESTS ===");

        // sw x18, 0(x9)  ?  imm should be 0
        instr_tb = 32'h0124A023;
        #1;
        $display("SW imm=0:  immGen output = %0d (expected 0)", $signed(imm_out));

        // ==========================================
        // TEST 6: Back to sequential, verify PC
        // ==========================================
        $display("");
        $display("=== SEQUENTIAL EXECUTION RESUMING ===");
        pcSrc = 0;
        repeat(3) begin
            @(posedge clk); #1;
            $display("PC = %0d,  PC+4 = %0d", PC, PCplus4);
        end

        $display("");
        $display("=== ALL TESTS DONE ===");
        $finish;
    end

endmodule