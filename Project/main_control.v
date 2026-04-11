module main_control (
    input [6:0] opcode,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg Branch,
    output reg ALUSrcA
);

    always @(*) begin
        // default assignments to handle Don't Care (X) conditions safely
        RegWrite = 1'b0;
        ALUOp = 2'b00;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        MemtoReg = 1'b0;
        Branch = 1'b0;
        ALUSrcA = 1'b0;

        case(opcode)
            7'b0110011: begin // R-type
                RegWrite = 1'b1;
                ALUOp = 2'b10;
            end
            7'b0000011: begin // lw
                RegWrite = 1'b1;
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                MemRead = 1'b1;
                MemtoReg = 1'b1;
            end
            7'b0100011: begin // sw
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
            end
            7'b1100011: begin // beq
                ALUOp = 2'b01;
                Branch = 1'b1;
            end
            7'b0010011: begin // I-type
                RegWrite = 1'b1;
                ALUOp = 2'b10;
                ALUSrc = 1'b1;
            end
            7'b0110111: begin // LUI
                RegWrite = 1'b1;
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                ALUSrcA = 1'b1;
            end
            default: begin
                // safe defaults already set
            end
        endcase
    end
endmodule
