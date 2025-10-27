`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 01:22:13
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(addr, ins);
	input [31:0] addr;
	output reg [31:0] ins;

	reg [31:0] mem [1023:0];
	
	initial begin
		$readmemb("instructions_bit.mem", mem, 0, 1023);	
	end

	always @(*) begin 
//		$monitor("PC = %d, ins = %b", addr[9:0], mem[addr[9:0]]);
		ins = mem[addr[9:0]];
	end
endmodule
