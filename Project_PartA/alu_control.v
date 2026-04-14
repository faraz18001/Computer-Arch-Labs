module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input IsRtype,
    output reg [3:0] ALUControl
);

    always @(*) begin
        // default assignment to handle Don't Care (X) conditions safely
        ALUControl = 4'b0000;

        case (ALUOp)
            2'b00: begin // lw, sw
                ALUControl = 4'b0010; // add
            end
            2'b01: begin // beq
                ALUControl = 4'b0110; // sub
            end
            2'b10: begin // R-type or I-type
                case(funct3)
                    3'b000: begin
                        // SUB only for R-type (funct7[5]=1). I-type bit 30 is part of immediate!
                        if (IsRtype && funct7[5])
                            ALUControl = 4'b0110; // sub
                        else
                            ALUControl = 4'b0010; // add
                    end
                    3'b111: ALUControl = 4'b0000; // and
                    3'b110: ALUControl = 4'b0001; // or
                    3'b010: ALUControl = 4'b1000; // SLT
                    3'b100: ALUControl = 4'b0011; // XOR / XORI
                    default: ALUControl = 4'b0000; // undefined default
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end
endmodule
