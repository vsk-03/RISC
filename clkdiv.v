`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2024 16:48:11
// Design Name: 
// Module Name: clkdiv
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


module clkdiv(
    input clk_,
    output reg clk
    );
reg [26:0] counter = 27'b10001111000011010001100000000;

always @(posedge clk_)
    begin
        if(counter)
            begin 
                counter = counter - 1;
            end
        else 
            begin 
                clk=~clk;
                counter = 27'b10001111000011010001100000000;
            end
    end

endmodule
