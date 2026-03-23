`timescale 1ns / 1ps

module MemorySystem_tb();
    reg clk;
    reg rst;
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches_in;
    
    wire [31:0] readData;
    wire [15:0] leds_out;

    addressDecoder uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches_in(switches_in),
        .readData(readData),
        .leds_out(leds_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        address = 0;
        readEnable = 0;
        writeEnable = 0;
        writeData = 0;
        switches_in = 16'hA5A5;

        #20 rst = 0;
        #10;
        
        address = 32'h00000200;
        readEnable = 1;
        #10;
        $display("Switch Read: address=%h, readData=%h (Expected: 0000A5A5)", address, readData);
        readEnable = 0;

        address = 32'h00000010;
        writeData = 32'hDEADBEEF;
        writeEnable = 1;
        #10;
        writeEnable = 0;
        $display("Memory Write: address=%h, data=%h", address, writeData);
        
        readEnable = 1;
        #10;
        $display("Memory Read: address=%h, readData=%h (Expected: DEADBEEF)", address, readData);
        readEnable = 0;
        
        address = 32'h00000100;
        writeData = 32'h0000ABCD;
        writeEnable = 1;
        #10;
        writeEnable = 0;
    end

endmodule
