`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 02:07:35
// Design Name: 
// Module Name: sgt
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


module sgt(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Z
);
    wire [31:0] sub_result, temp;   // Result of the subtraction (B - A)
    // The sign bit will be 1 if the result is negative, meaning B < A (A > B)
    assign sign_bit = B - A;  // The MSB of the result represents the sign

    // Set the output Z: Z[0] = sign_bit, Z[31:1] = 0
    assign Z = {31'b0, temp[31]};

endmodule
