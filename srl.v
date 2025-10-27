`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 01:18:57
// Design Name: 
// Module Name: srl
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


module srl(a,b,shamt,out);
    input signed [31:0] a;
    input signed [31:0] b;
    input signed [4:0] shamt;
    output reg signed [31:0] out;

    always @(a or b or shamt) begin
        if (shamt)
            out = a >>> shamt;
        else
            out = a >>> b[0];
    end
endmodule 
