`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 17:27:52
// Design Name: 
// Module Name: testbench
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


module testbench;
reg clk = 0;
reg rst; 
wire [15:0] out; 


risc KGPRISC(
    .clk(clk),
    .rst(rst),
    .out(out)
); 

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $display("Starting testbench");
     #10 rst = 1;
     #10 rst = 0;

    $monitor("Reg[11] = %d", KGPRISC.RB.regfile[11]);
    $monitor("out = %d", out);  

    #100000000;
//    $finish;
end

endmodule
