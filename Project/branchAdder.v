module branchAdder (
    input [31:0] pc,
    input [31:0] imm,
    output [31:0] pc_branch
);
    assign pc_branch = pc + (imm << 1);
endmodule
