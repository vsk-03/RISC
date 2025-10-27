`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 01:20:46
// Design Name: 
// Module Name: regbank
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


module regbank(instruction, rd1, rd2, wd, Rs, Rt, Rd, rst, RegW, clk, out1);
    input [31:0] instruction;
    input clk, RegW, rst;
    input [4:0] Rs, Rt, Rd;
    input [31:0] wd;
    
    output signed [31:0] rd1, rd2;
    output reg [15:0] out1;
    
    reg signed [31:0] regfile[0:16]; // R0 - R15 + SP
    integer i;
    
    assign rd1=regfile[Rs];
    assign rd2=regfile[Rt];

    
    //assign out1 = regfile[11];
    
    always @(posedge clk) begin
        regfile[0] <= 0;
//         $monitor("instruction=%b, reg[%d]=%d, reg[%d]=%d", instruction, Rs, rd1, Rt, rd2);
//         //$monitor("rf[15]=%d, rf[1]=%d, rf[2]=%d, rf[3]=%d, rf[4]=%d, rf[5]=%d, rf[6]=%d, rf[7]=%d, rf[8]=%d", regfile[15], regfile[1], regfile[2], regfile[3], regfile[4], regfile[5], regfile[6], regfile[7], regfile[8]);
//         $monitor("res=%d", regfile[15]);
//         $monitor("SP=%d", regfile[16]);
//         $monitor("instruction=%b, Rs=%d, Rt=%d, Rd=%d, wrData=%d", instruction, Rs, Rt, Rd, wd);
//           $monitor("rf[0]=%d, rf[1]=%d, rf[2]=%d, rf[3]=%d, rf[4]=%d, rf[5]=%d, rf[6]=%d, rf[7]=%d, rf[8]=%d", regfile[0], regfile[1], regfile[2], regfile[3], regfile[4], regfile[5], regfile[6], regfile[7], regfile[8]);
//           $monitor("rf[9]=%d, rf[10]=%d, rf[11]=%d, rf[12]=%d", regfile[9], regfile[10], regfile[11], regfile[12]);
        if (rst) begin
                    regfile[0]<=0;
                    regfile[1]<=0;
                    regfile[2]<=0;
                    regfile[3]<=0;
                    regfile[4]<=0;
                    regfile[5]<=0;
                    regfile[6]<=0;
                    regfile[7]<=0;
                    regfile[8]<=0;
                    regfile[9]<=0;
                    regfile[10]<=0;
                    regfile[11]<=0;
                    regfile[12]<=0;
                    regfile[13]<=0;
                    regfile[14]<=0;
                    regfile[15]<=0;
                    regfile[16]<=1023;
        end
        if (RegW) begin
//             $display("writing %d to reg[%d]", wd, Rd);
            regfile[Rd] <= wd;
            out1 = regfile[11][15:0];
//            $display("out1 = %d",out1);
        end
    end
endmodule
