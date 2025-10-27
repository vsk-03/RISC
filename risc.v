`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 00:01:06
// Design Name: 
// Module Name: risc
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

module risc(clk, rst, out);
    input clk, rst;
    output [15:0] out;


    wire [31:0] MemAddr, MemIn;
    wire [15:0] ou1;
    wire [31:0] PC, NPC, ins;
    wire [5:0] opcode, funct;
    wire [4:0] Rs, Rt, Rd, shamt;
    wire [4:0] destReg; 
    wire [31:0] imm;
    wire ALUSrc, MemR, MemW, RegW, RegDst, MemtoReg; 
    wire [2:0] BranchOp, StackOp;
    wire [3:0] ALUOp;
    wire [31:0] A, B, Rdin;
    wire [31:0] LMD;
    wire [31:0] ALUout; 
    wire [31:0] SPin, SPout, MemSP;
    wire updatePC;
    wire clk_;


//    instruction_memory IM (
//        .addr(PC),
//        .ins(ins)
//    );

    blk_mem_gen_1  ins_mem(
       .clka(clk),    // input wire
       .ena(1'b1),
       .addra(PC[9:0]),  // input wire [9 : 0] 
       .douta(ins)  // output wire [31 : 0] 
     );

    assign MemIn = (StackOp == 3'b011) ? PC: B; // MUX to control memory write input - PC in case of CALL, A otherwise
    assign MemAddr = (StackOp == 3'b000) ? ALUout : MemSP; // MUX to control memory address - MemSP in case of stack operations, ALUout otherwise
    assign destReg = (RegDst == 1) ? Rd : Rt; // MUX to control destination register to write to 
    assign Rdin = (MemtoReg == 1) ? LMD : ( (StackOp == 0) ? ALUout : SPout ); // MUX to control Rdin - additional case is in case of stack operations, where Rdin = SPout

    
    wire [3:0] ALUfunct;
    assign ALUfunct = (ALUOp == 4'b0000) ? funct : ALUOp; // MUX to control ALU function based on ALUOp

    // if it's a branching operation, then ALUin1 is PC, else A
    // ALUin1 will be PC also in case of CALL
    wire [31:0] ALUin1; 
    assign ALUin1 = (BranchOp == 0) ? ((StackOp == 3'b011) ? PC : A) : PC; // MUX to control ALUin1

    
    // if ALUSrc is 0, choose B, else choose imm 
    wire [31:0] ALUin2;
    assign ALUin2 = (ALUSrc == 0) ? B : imm; // MUX to control ALUin2
    
    clkdiv CD(
        .clk_(clk),
        .clk(clk_)
    );
    
    control_unit CPU (
        .clk(clk),
        .opcode(opcode),
        .BranchOp(BranchOp),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .MemR(MemR),
        .MemW(MemW),
        .RegW(RegW),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg),
        .StackOp(StackOp), 
        .updatePC(updatePC), 
        .INT(1'b0),
        .rst(rst)
    );
    
    alu ALU (
        .a(ALUin1),
        .b(ALUin2),
        .shamt(shamt),
        .funct(ALUfunct),
        .clk(clk),
        .res(ALUout)
    );
  
    blk_mem_gen_0 datamem(
      .clka(clk),     // input wire clk (check ~clk or clk)
       .ena(MemR|MemW),      // to enable read
       .wea(MemW),      // to enable write
       .addra(MemAddr[9:0]),    // address that is being read/written
       .dina(MemIn),      // data that is being written
       .douta(LMD)      // data that is being read
     );

    // decode the instruction into Rs, Rt, Rd, shamt, funct, imm... 
    instruction_decoder ID (
        .ins(ins),
        .opcode(opcode),
        .Rs(Rs),
        .Rt(Rt),
        .Rd(Rd),
        .shamt(shamt),
        .funct(funct),
        .imm(imm)
    );
    
    regbank RB(
        .instruction(ins),
        .rd1(A),
        .rd2(B),
        .wd(Rdin),
        .Rs(Rs),
        .Rt(Rt),
        .Rd(destReg),
        .rst(rst),
        .RegW(RegW),
        .clk(clk),
        .out1(ou1)
    );
    

    PC_control PCC (
        .BranchOp(BranchOp),
        .StackOp(StackOp),
        .ALUout(ALUout),
        .regval(A),
        .LMD(LMD),
        .PCin(PC), 
        .rst(rst),
        .clk(clk),
        .PCout(NPC)
    );


    SP_control SPC (
        .StackOp(StackOp), 
        .clk(clk), 
        .rst(rst),
        .SPin(A), 
        .SPout(SPout), 
        .MemSP(MemSP)
    );

    program_counter PC0 (
        .ins(ins),
        .PCin(NPC),
        .clk(clk),
        .reset(rst),
        .PCout(PC),
        .updatePC(updatePC)
    );

    assign out = ou1; 

endmodule
