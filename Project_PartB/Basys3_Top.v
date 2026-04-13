module Basys3_Top (
    input clk,
    input btnC,           // Center Button for Reset
    input [15:0] sw,
    output [15:0] led,    // 16 LEDs → Control Signals
    output [6:0] seg,     // 7-Segment shapes
    output [3:0] an       // 4-Digit Anodes
);

    // Slow clock so the instructor can watch each instruction execute
    reg [26:0] clk_div;
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    wire slow_clk = clk_div[26];

    wire [31:0] pc_val;
    wire [31:0] alu_val;

    // Control signal wires
    wire c_RegWrite, c_MemRead, c_MemWrite, c_ALUSrc;
    wire c_MemtoReg, c_Branch, c_ALUSrcA, c_PCSrc, c_Zero;
    wire [1:0] c_ALUOp;

    // Instantiate RISC-V Processor with control signals exposed
    TopLevelProcessor cpu (
        .clk(slow_clk),
        .reset(btnC),
        .show_pc(pc_val),
        .show_alu_result(alu_val),
        .switches(sw),
        .ctrl_RegWrite(c_RegWrite),
        .ctrl_MemRead(c_MemRead),
        .ctrl_MemWrite(c_MemWrite),
        .ctrl_ALUSrc(c_ALUSrc),
        .ctrl_MemtoReg(c_MemtoReg),
        .ctrl_Branch(c_Branch),
        .ctrl_ALUSrcA(c_ALUSrcA),
        .ctrl_ALUOp(c_ALUOp),
        .ctrl_PCSrc(c_PCSrc),
        .ctrl_Zero(c_Zero)
    );

    // === LEDs: Show Control Signals ===
    // LED[0]  = RegWrite
    // LED[1]  = MemRead
    // LED[2]  = MemWrite
    // LED[3]  = ALUSrc
    // LED[4]  = MemtoReg
    // LED[5]  = Branch
    // LED[6]  = ALUSrcA
    // LED[7]  = ALUOp[0]
    // LED[8]  = ALUOp[1]
    // LED[9]  = PCSrc
    // LED[10] = Zero
    // LED[15:11] = unused
    assign led = {5'b0, c_Zero, c_PCSrc, c_ALUOp, c_ALUSrcA,
                  c_Branch, c_MemtoReg, c_ALUSrc, c_MemWrite,
                  c_MemRead, c_RegWrite};

    // === 7-Segment: Always show Program Counter ===
    seven_seg_controller display (
        .clk(clk),
        .value(pc_val[15:0]),
        .seg(seg),
        .an(an)
    );

endmodule
