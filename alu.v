`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 17:12:05
// Design Name: 
// Module Name: alu
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
module sra(a,b,shamt,out);
    input [31:0] a;
    input [31:0] b;
    input [4:0] shamt;
    output reg [31:0] out;

    always @(a or b or shamt) begin
        if (shamt)
            out = a >> shamt;
        else
            out = a >> b[0];
    end
endmodule

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


module sla(a,b,shamt,out);
    input signed [31:0] a;
    input signed [31:0] b;
    input signed [4:0] shamt;
    output reg signed [31:0] out;

    always @(a or b or shamt) begin
        if (shamt)
            out = a <<< shamt;
        else
            out = a <<< b[0];
    end
endmodule


module slt(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Z
);
    wire [31:0] sub_result, temp;   // Result of the subtraction (A - B) 

    // The sign bit will be 1 if the result is negative, meaning A < B
    assign temp = A - B;  // The MSB of the result represents the sign

    // Set the output Z: Z[0] = sign_bit, Z[31:1] = 0
    assign Z = {31'b0, temp[31]};

endmodule

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

module xor_module(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b)
        out = a ^ b;
endmodule


module or_module(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b)
        out = a | b;
endmodule

module not_module(a,out);
    input [31:0] a;
    output reg [31:0] out;

    always @(a)
        out = ~a;
endmodule

module nor_module(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b)
        out = ~(a | b);
endmodule

module and_module(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b)
        out = a & b;
endmodule

module subtractor(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b)
        out = a - b;
endmodule

module adder(a,b,out);
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] out;

    always @(a or b) begin
        out = a + b;
    end
endmodule

module ham_module(a, ham_out);

    input [31:0] a;
    output [31:0] ham_out;
    
    assign ham_out = a[0] + a[1] + a[2] + a[3] + a[4] + a[5] + a[6] + a[7] + a[8] + a[9] + a[10] + a[11] + a[12] + a[13] + a[14] + a[15] + a[16] + a[17] + a[18] + a[19] + a[20] + a[21] + a[22] + a[23] + a[24] + a[25] + a[26] + a[27] + a[28] + a[29] + a[30] + a[31];
endmodule

module alu (a,b,shamt,funct,clk,res);
    input [31:0] a;
    input [31:0] b;
    input [4:0] shamt;
    input [3:0] funct;
    input clk;
    output reg [31:0] res;

    parameter 
        ADD = 1,
        SUB = 2,
        AND = 3,
        OR = 4,
        XOR = 5,
        NOR  = 6,
        NOT = 7,
        SLA = 8,
        SRL = 9, 
        SRA = 10,
        INC = 11,
        DEC = 12,
        SLT = 13,
        SGT = 14,
        HAM = 15;
        

    wire signed [31:0] add_out, sub_out, and_out, or_out, xor_out, nor_out, not_out, sla_out, sra_out, srl_out, slt_out, sgt_out, ham_out;

    adder       add_gate(a,b,add_out);
    subtractor  sub_gate(a,b,sub_out);
    and_module  and_gate(a,b,and_out);
    or_module   or_gate(a,b,or_out);
    xor_module  xor_gate(a,b,xor_out);
    nor_module  nor_gate(a,b,nor_out);
    not_module  not_gate(b,not_out);
    sla         sla_gate(a,b,shamt,sla_out);
    sra         sra_gate(a,b,shamt,sra_out);
    srl         srl_gate(a,b,shamt,srl_out);
    slt         slt_gate(a,b,slt_out);
    sgt         sgt_gate(a,b,sgt_out);
    ham_module  ham_gate(a, ham_out);



    always @(posedge clk)
    begin
        // $display("A = %d, B = %d, shamt = %d, funct = %d, res = %d", a, b, shamt, funct, sla_out);
        case(funct)
            ADD: res <= add_out; 
            SUB: res <= sub_out;
            AND: res <= and_out;
            OR:  res <= or_out;
            XOR: res <= xor_out;
            NOR: res <= nor_out;
            NOT: res <= not_out;
            SLA: res <= sla_out;
            SRL: res <= srl_out;
            SRA: res <= sra_out;
            INC: res <= a + 4;
            DEC: res <= a - 4;
            SLT: res <= slt_out;
            SGT: res <= sgt_out;
            HAM: res <= ham_out;
        endcase
    end
endmodule

