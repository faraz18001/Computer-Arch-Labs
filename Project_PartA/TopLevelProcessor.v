module TopLevelProcessor (
    input clk,
    input reset,
    output [31:0] show_pc,
    output [31:0] show_alu_result
);

    // Wires for interconnections
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_branch;
    
    wire [31:0] instr;
    
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;
    
    wire [31:0] rd1, rd2;
    wire [31:0] write_data;
    
    wire [31:0] alu_in2;
    wire [31:0] alu_result;
    wire zero;
    
    wire [31:0] read_data;
    wire [31:0] imm;
    
    // branching logic
    wire PCSrc = Branch & zero;
    
    // === PC and Instruction Fetch ===
    ProgramCounter pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    pcAdder pc_add (
        .pc(pc),
        .pc_next_seq(pc_plus_4)
    );
    
    InstructionMemory imem (
        .address(pc),
        .instruction(instr)
    );
    
    // === Control Unit ===
    main_control ctrl (
        .opcode(instr[6:0]),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );
    
    // === Register File ===
    RegisterFile rf (
        .clk(clk),
        .rst(reset),
        .WriteEnable(RegWrite),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .WriteData(write_data),
        .ReadData1(rd1),
        .ReadData2(rd2)
    );
    
    // === Immediate Generation ===
    immGen ig (
        .instr(instr),
        .imm(imm)
    );
    
    // === Branch Addr Calc ===
    branchAdder br_add (
        .pc(pc),
        .imm(imm),
        .pc_branch(pc_branch)
    );
    
    mux2 #(32) pc_mux (
        .in0(pc_plus_4),
        .in1(pc_branch),
        .sel(PCSrc),
        .out(pc_next)
    );
    
    // === ALU ===
    mux2 #(32) alu_src_mux (
        .in0(rd2),
        .in1(imm),
        .sel(ALUSrc),
        .out(alu_in2)
    );
    
    alu_control alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .ALUControl(ALUControl)
    );
    
    ALU alu_inst (
        .A(rd1),
        .B(alu_in2),
        .ALUControl(ALUControl),
        .ALUResult(alu_result),
        .Zero(zero)
    );
    
    // === Data Memory ===
    DataMemory dmem (
        .clk(clk),
        .MemWrite(MemWrite),
        .address(alu_result),
        .write_data(rd2),
        .read_data(read_data)
    );
    
    // === Write Back ===
    mux2 #(32) wb_mux (
        .in0(alu_result),
        .in1(read_data),
        .sel(MemtoReg),
        .out(write_data)
    );
    
    // Debug outputs for FPGA LEDs
    assign show_pc = pc;
    assign show_alu_result = rf.regs[3]; // Point cleanly to x3 so the LEDs freeze on the answer (15)

endmodule
