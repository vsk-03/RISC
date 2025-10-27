`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 01:59:54
// Design Name: 
// Module Name: nor_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module nor_module(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b)
        out = ~(a | b);
endmodule
