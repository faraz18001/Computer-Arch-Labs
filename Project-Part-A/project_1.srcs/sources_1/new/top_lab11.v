`timescale 1ns / 1ps
module TopLevelProcessor(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] sw,
    output wire [15:0] led,
    output wire [6:0]  seg,
    output wire [3:0]  an
);

    // ==========================================
    // WIRES
    // ==========================================
    // PC wires
    wire [31:0] PC, PCplus4, branchTarget, next_PC;
    wire        pcSrc;

    // Instruction wires
    wire [31:0] instr;
    wire [6:0]  opcode  = instr[6:0];
    wire [4:0]  rd      = instr[11:7];
    wire [2:0]  funct3  = instr[14:12];
    wire [4:0]  rs1     = instr[19:15];
    wire [4:0]  rs2     = instr[24:20];
    wire        funct7_5 = instr[30];
    // force funct7_5 to 0 for I-type so ADDI doesnt get treated as SUB
    wire        funct7_5_safe = (opcode == 7'b0010011) ? 1'b0 : funct7_5;

    // Immediate wire
    wire [31:0] imm;

    // Control signal wires
    wire        RegWrite_ctrl, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0]  ALUOp;
    wire [3:0]  ALUControl_wire;

    // Jump wires
    wire is_jal  = (opcode == 7'b1101111);
    wire is_jalr = (opcode == 7'b1100111);
    wire RegWrite = RegWrite_ctrl | is_jal | is_jalr;

    // Register file wires
    wire [31:0] ReadData1, ReadData2;

    // ALU wires
    wire [31:0] ALU_B;
    wire [31:0] ALUResult;
    wire        Zero;

    // Memory wires
    wire [31:0] MemReadData;
    wire [15:0] leds_out;

    // Writeback wire
    wire [31:0] WriteData;

    // Branch decision
    reg do_branch;
    always @(*) begin
        case (funct3)
            3'b000: do_branch = Branch & Zero;           // BEQ
            3'b001: do_branch = Branch & ~Zero;          // BNE
            3'b100: do_branch = Branch & ALUResult[31];  // BLT
            3'b101: do_branch = Branch & ~ALUResult[31]; // BGE
            default: do_branch = 1'b0;
        endcase
    end

    assign pcSrc = do_branch | is_jal;

    // ==========================================
    // CLOCK DIVIDER
    // ==========================================
    wire clk_slow;
    clk_div #(.div_value(12499999)) clk_div_inst ( // 8Hz
        .clk(clk),
        .clk_d(clk_slow)
    );

    // ==========================================
    // 1. PROGRAM COUNTER
    // ==========================================
    ProgramCounter pc_inst (
        .clk    (clk_slow),
        .rst    (rst),
        .next_PC(next_PC),
        .PC     (PC)
    );

    // ==========================================
    // 2. PC ADDER (PC + 4)
    // ==========================================
    pcAdder pc_adder_inst (
        .currentPC(PC),
        .nextPC   (PCplus4)
    );

    // ==========================================
    // 3. INSTRUCTION MEMORY
    // ==========================================
    InstructionMemory imem (
        .readAddress(PC),
        .instruction(instr)
    );

    // ==========================================
    // 4. IMMEDIATE GENERATOR
    // ==========================================
    immGen imm_gen_inst (
        .instr (instr),
        .opcode(opcode),
        .imm   (imm)
    );

    // ==========================================
    // 5. MAIN CONTROL
    // ==========================================
    MainControl mc (
        .opcode  (opcode),
        .RegWrite(RegWrite_ctrl),
        .ALUSrc  (ALUSrc),
        .MemRead (MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch  (Branch),
        .ALUOp   (ALUOp)
    );

    // ==========================================
    // 6. ALU CONTROL
    // ==========================================
    ALUControl ac (
        .ALUOp     (ALUOp),
        .funct3    (funct3),
        .funct7_5  (funct7_5_safe),
        .ALUControl(ALUControl_wire)
    );

    // ==========================================
    // 7. REGISTER FILE
    // ==========================================
    RegisterFile rf (
        .clk       (clk_slow),
        .rst       (rst),
        .WriteEnable(RegWrite),
        .rs1       (rs1),
        .rs2       (rs2),
        .rd        (rd),
        .WriteData (WriteData),
        .ReadData1 (ReadData1),
        .ReadData2 (ReadData2)
    );

    // ==========================================
    // 8. ALUSrc MUX (mux3)
    // selects between rs2 and immediate for ALU input B
    // ==========================================
    mux3 alu_src_mux (
        .aluSrc (ALUSrc),
        .rs2Data(ReadData2),
        .imm    (imm),
        .aluIn  (ALU_B)
    );

    // ==========================================
    // 9. ALU
    // ==========================================
    ALU32bit alu (
        .A        (ReadData1),
        .B        (ALU_B),
        .ALUctl   (ALUControl_wire),
        .ALUResult(ALUResult),
        .Zero     (Zero)
    );

    // ==========================================
    // 10. MEMORY MAPPED I/O (Lab 8)
    // ==========================================
    addressDecoderTop mem_io (
        .clk        (clk_slow),
        .rst        (rst),
        .address    (ALUResult),
        .readEnable (MemRead),
        .writeEnable(MemWrite),
        .writeData  (ReadData2),
        .switches   (sw),
        .readData   (MemReadData),
        .leds       (leds_out)
    );
    assign led = leds_out;

    // ==========================================
    // 11. WRITEBACK MUX (mux1)
    // selects what goes back into register file
    // ==========================================
    mux1 writeback_mux (
        .memToReg (MemtoReg),
        .readData (MemReadData),
        .aluResult(ALUResult),
        .writeData(WriteData)
    );

    // Override WriteData for JAL/JALR - save PC+4 as return address
    // We need a separate wire for this
    // So we replace the mux1 output with this logic:
    // assign WriteData = (is_jal | is_jalr) ? PCplus4 :
    //                    MemtoReg           ? MemReadData :
    //                                         ALUResult;
    // NOTE: comment out mux1 above and use this instead if you want JAL support

    // ==========================================
    // 12. BRANCH ADDER (PC + imm)
    // ==========================================
    branchAdder branch_adder_inst (
        .currentPC(PC),
        .imm      (imm),
        .nextPC   (branchTarget)
    );

    // ==========================================
    // 13. NEXT PC MUX (mux2)
    // selects between PC+4 and branch target
    // ==========================================
    mux2 pc_mux (
        .pcSrc      (pcSrc),
        .nonBranchPC(PCplus4),
        .branchPC   (is_jalr ? (ReadData1 + imm) : branchTarget),
        .nextPC     (next_PC)
    );

    // ==========================================
    // 14. 7-SEG DISPLAY (shows countdown value)
    // ==========================================
    wire [3:0] d0, d1, d2, d3;
    bcd_converter bcd (
        .value  (leds_out),
        .digit_0(d0),
        .digit_1(d1),
        .digit_2(d2),
        .digit_3(d3)
    );
    seven_segment seg_inst (
        .clk    (clk),      // fast clock for display multiplexing
        .reset  (rst),
        .digit_0(d0),
        .digit_1(d1),
        .digit_2(d2),
        .digit_3(d3),
        .seg    (seg),
        .an     (an)
    );

endmodule