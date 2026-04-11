module pcAdder (
    input [31:0] pc,
    output [31:0] pc_next_seq
);
    assign pc_next_seq = pc + 32'd4;
endmodule
