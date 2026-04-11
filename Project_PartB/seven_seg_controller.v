module seven_seg_controller(
    input clk,            // Fast 100MHz clock
    input [15:0] value,   // The 16-bit number to display
    output reg [6:0] seg, // The 7 LED segments (A-G)
    output reg [3:0] an   // The 4 Anodes (Digit selectors)
);

    // 1. Slow down the clock for multiplexing (too fast = blur, too slow = flicker)
    // 100MHz / 2^19 = ~190 Hz refresh rate
    reg [19:0] refresh_counter;
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    // 2. Decide which of the 4 digits to turn on right now
    wire [1:0] LED_activating_counter = refresh_counter[19:18];
    reg [3:0] LED_BCD;

    always @(*) begin
        case(LED_activating_counter)
        2'b00: begin
            an = 4'b0111; // Turn on 4th digit (leftmost)
            LED_BCD = value[15:12]; // Feed it the top 4 bits of the value
        end
        2'b01: begin
            an = 4'b1011; // Turn on 3rd digit
            LED_BCD = value[11:8];
        end
        2'b10: begin
            an = 4'b1101; // Turn on 2nd digit
            LED_BCD = value[7:4];
        end
        2'b11: begin
            an = 4'b1110; // Turn on 1st digit (rightmost)
            LED_BCD = value[3:0];
        end
        endcase
    end

    // 3. Hexadecimal to 7-Segment Decoder
    // These are ACTIVE LOW (0 means the LED light turns ON)
    // Order is {g, f, e, d, c, b, a}
    always @(*) begin
        case(LED_BCD)
        4'b0000: seg = 7'b1000000; // 0
        4'b0001: seg = 7'b1111001; // 1
        4'b0010: seg = 7'b0100100; // 2
        4'b0011: seg = 7'b0110000; // 3
        4'b0100: seg = 7'b0011001; // 4
        4'b0101: seg = 7'b0010010; // 5
        4'b0110: seg = 7'b0000010; // 6
        4'b0111: seg = 7'b1111000; // 7
        4'b1000: seg = 7'b0000000; // 8
        4'b1001: seg = 7'b0010000; // 9
        4'b1010: seg = 7'b0001000; // A
        4'b1011: seg = 7'b0000011; // B
        4'b1100: seg = 7'b1000110; // C
        4'b1101: seg = 7'b0100001; // D
        4'b1110: seg = 7'b0000110; // E
        4'b1111: seg = 7'b0001110; // F
        default: seg = 7'b1111111; // Blank display if broken
        endcase
    end

endmodule
