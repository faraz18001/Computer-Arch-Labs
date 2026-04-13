`timescale 1ns / 1ps

module pcAdder(
    input [31:0] currentPC,
    output [31:0] nextPC
);
    
    assign nextPC = currentPC + 32'd4; 

endmodule