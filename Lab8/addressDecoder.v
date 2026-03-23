`timescale 1ns / 1ps

module addressDecoder(
    input clk,
    input rst,
    input [31:0] address,
    input readEnable,
    input writeEnable,
    input [31:0] writeData,
    input [15:0] switches_in,
    output [31:0] readData,
    output [15:0] leds_out
);

    wire [31:0] memReadData;
    wire [31:0] ledReadData;
    wire [31:0] switchReadData;

    wire DataMemSelect = (address[9:8] == 2'b00);
    wire LEDSelect     = (address[9:8] == 2'b01);
    wire SwitchSelect  = (address[9:8] == 2'b10);

    wire DataMemWrite = writeEnable && DataMemSelect;
    wire LEDWrite     = writeEnable && LEDSelect;
    wire SwitchRead   = readEnable  && SwitchSelect;

    DataMemory dm_inst (
        .clk(clk),
        .MemWrite(DataMemWrite),
        .address(address),
        .write_data(writeData),
        .read_data(memReadData)
    );

    leds led_inst (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(LEDWrite),
        .readEnable(1'b0),
        .memAddress(address[31:2]),
        .readData(),
        .leds(leds_out)
    );

    switches sw_inst (
        .clk(clk),
        .rst(rst),
        .btns(16'b0),
        .writeData(writeData),
        .writeEnable(writeEnable && SwitchSelect),
        .readEnable(SwitchRead),
        .memAddress(address[31:2]),
        .switches(switches_in),
        .readData(switchReadData)
    );

    assign readData = (DataMemSelect) ? memReadData :
                      (SwitchSelect)  ? switchReadData :
                      32'h00000000;

endmodule
