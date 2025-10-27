`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 17:22:21
// Design Name: 
// Module Name: program_counter
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

module program_counter(ins, PCin, updatePC, reset, clk, PCout);
    input [31:0] ins;
    input [31:0] PCin;
    input updatePC;
    input reset,clk;
    output reg [31:0] PCout;

    always @(posedge clk)
    begin
        if(reset) begin
            PCout <= 0;
        end
        else if (updatePC) begin
//            $display("UPDATING PC to %d", PCin);
            PCout <= PCin;
        end
    end
endmodule

