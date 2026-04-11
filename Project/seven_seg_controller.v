module seven_seg_controller(
    input clk,
    input [15:0] value,
    output reg [6:0] seg,
    output reg [3:0] an
);

    reg [19:0] refresh_counter;
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    wire [1:0] LED_activating_counter = refresh_counter[19:18];
    reg [3:0] LED_BCD;

    always @(*) begin
        case(LED_activating_counter)
        2'b00: begin
            an = 4'b0111;
            LED_BCD = value[15:12];
        end
        2'b01: begin
            an = 4'b1011;
            LED_BCD = value[11:8];
        end
        2'b10: begin
            an = 4'b1101;
            LED_BCD = value[7:4];
        end
        2'b11: begin
            an = 4'b1110;
            LED_BCD = value[3:0];
        end
        endcase
    end

    always @(*) begin
        case(LED_BCD)
        4'b0000: seg = 7'b1000000;
        4'b0001: seg = 7'b1111001;
        4'b0010: seg = 7'b0100100;
        4'b0011: seg = 7'b0110000;
        4'b0100: seg = 7'b0011001;
        4'b0101: seg = 7'b0010010;
        4'b0110: seg = 7'b0000010;
        4'b0111: seg = 7'b1111000;
        4'b1000: seg = 7'b0000000;
        4'b1001: seg = 7'b0010000;
        4'b1010: seg = 7'b0001000;
        4'b1011: seg = 7'b0000011;
        4'b1100: seg = 7'b1000110;
        4'b1101: seg = 7'b0100001;
        4'b1110: seg = 7'b0000110;
        4'b1111: seg = 7'b0001110;
        default: seg = 7'b1111111;
        endcase
    end

endmodule
