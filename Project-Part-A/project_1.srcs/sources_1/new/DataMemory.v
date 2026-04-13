`timescale 1ns / 1ps


module DataMemory (
    input clk,
    input MemWrite,        // From Control Unit
    input [31:0] address,  // Memory address
    input [31:0] writeData, // Data to be stored
    output [31:0] readData  // Data being read
);
    // 512 words of 32 bits each        
    reg [31:0] mem [0:511];

    // Synchronous Write 
    always @(posedge clk) begin
        if (MemWrite)
            mem[address[7:0]] <= writeData; 
    end

    // Asynchronous Read 
    assign readData = mem[address[8:0]];

endmodule