module tb_task1 ();
    reg clk;
    reg reset;
    reg PCSrc;
    reg [31:0] instr;
    
    wire [31:0] pc;
    wire [31:0] pc_next_seq;
    wire [31:0] pc_branch;
    wire [31:0] pc_next;
    wire [31:0] imm;
    
    // Instantiate Modules
    ProgramCounter pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    pcAdder pc_adder_inst (
        .pc(pc),
        .pc_next_seq(pc_next_seq)
    );
    
    immGen imm_gen_inst (
        .instr(instr),
        .imm(imm)
    );
    
    branchAdder branch_adder_inst (
        .pc(pc),
        .imm(imm),
        .pc_branch(pc_branch)
    );
    
    mux2 #(32) pc_mux (
        .in0(pc_next_seq),
        .in1(pc_branch),
        .sel(PCSrc),
        .out(pc_next)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("task1.vcd");
        $dumpvars(0, tb_task1);
        
        // Initialize
        clk = 0;
        reset = 1;
        PCSrc = 0;
        instr = 32'b0;
        
        #10;
        reset = 0;
        
        // Test 1: PC increment by 4
        #10; // PC becomes 4
        if (pc !== 32'd4) $display("Error: PC not 4, it is %0d", pc);
        else $display("Pass: PC incremented to 4");
        
        #10; // PC becomes 8
        if (pc !== 32'd8) $display("Error: PC not 8, it is %0d", pc);
        else $display("Pass: PC incremented to 8");
        
        // Test 2: B-Type Immediate Generation (beq x1, x2, offset)
        // offset = -8
        // immGen should output -4 (32'hFFFFFFFC)
        instr = {1'b1, 6'b111111, 5'b00010, 5'b00001, 3'b000, 4'b1100, 1'b1, 7'b1100011};
        
        #10; // PC becomes 12
        if (imm !== 32'hFFFFFFFC) $display("Error: B-Type Imm generated is %h, expected FFFFFFFC", imm);
        else $display("Pass: Correct B-Type immediate");
        
        if (pc_branch !== (pc + 32'hFFFFFFF8)) $display("Error: Branch Target is %h, expected %h", pc_branch, pc - 8);
        else $display("Pass: Correct branch target calculated (PC - 8)");
        
        // Test 3: Take Branch
        PCSrc = 1; 
        #10; // PC should now be (12 - 8) = 4
        if (pc !== 32'd4) $display("Error: PC did not branch to 4, it is %0d", pc);
        else $display("Pass: PC correctly branched to 4");
        
        // Return to sequential
        PCSrc = 0;
        #10;
        if (pc !== 32'd8) $display("Error: PC did not increment to 8 after branch, it is %0d", pc);
        else $display("Pass: PC returned to sequential execution (8)");
        
        // Test 4: Verify I-Type Immediate
        // addi x1, x0, 15
        instr = {12'd15, 5'b00000, 3'b000, 5'b00001, 7'b0010011};
        #10;
        if (imm !== 32'd15) $display("Error: I-type Immediate is %h", imm);
        else $display("Pass: Correct I-Type immediate");
        
        $display("All tests completed!");
        $finish;
    end
endmodule
