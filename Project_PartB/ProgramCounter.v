module ProgramCounter (
    input clk,
    input reset,
    input freeze,           // When HIGH, PC holds current value (pause)
    input [31:0] pc_next,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else if (!freeze)   // Only advance if NOT frozen
            pc <= pc_next;
    end
endmodule
