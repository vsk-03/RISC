`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 17:21:05
// Design Name: 
// Module Name: control_unit
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


// Control unit that outputs required control signals for each instruction

// Control unit that outputs required control signals for each instruction

module control_unit(clk, opcode, BranchOp, ALUOp, ALUSrc, MemR, MemW, RegW, RegDst, MemtoReg, StackOp, updatePC, INT, rst);
    input clk, INT, rst;
    input [5:0] opcode;
    output reg [2:0] BranchOp;
    output reg [3:0] ALUOp;
    output reg ALUSrc, MemR, MemW, RegW, RegDst, MemtoReg; 
    output reg [2:0] StackOp;
    output reg updatePC;

    reg [2:0] CS; 
    reg [4:0] IS; // instruction state

    parameter 
        R_TYPE = 6'b000000,

        ADDI =  6'b000001,
        SUBI =  6'b000010,
        ANDI =  6'b000011,
        ORI =   6'b000100,
        XORI = 6'b000101,
        NOTI = 6'b000110,
        SLAI = 6'b000111,
        SRLI = 6'b001000,
        SRAI = 6'b001001,
        NORI = 6'b011001,
        SLTI = 6'b011010,
        SGTI = 6'b011011,

        BR =   6'b001010,
        BMI =  6'b001011,
        BPL =  6'b001100,
        BZ =   6'b001101,

        LD =  6'b001110,
        ST =  6'b001111,
//        LDSP = 6'b010000,
//        STSP = 6'b010001,

        MOVE = 6'b010010,

        PUSH = 6'b010011,
        POP = 6'b010100,
        CALL = 6'b010101, 

        HALT = 6'b010110,
        NOP = 6'b010111,
        RET = 6'b011000;


    always @(posedge clk) begin
        if (rst) begin
            CS <= 0; 
            IS <= 0; 
            BranchOp <= 0; 
            ALUOp <= 0;
            ALUSrc <= 0;
            MemR <= 0;
            MemW <= 0;
            RegW <= 0;
            RegDst <= 0;
            MemtoReg <= 0;
            StackOp <= 0;
            updatePC <= 0;
        end
        case (CS) 
        0: begin 
            updatePC <= 0;
            CS <= 1;
        end
        1: begin
        case(opcode)
            // R-type arithmetic operations
            R_TYPE: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0000;
                        ALUSrc <= 0;
                        MemR <= 0;
                        MemW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 1; 
                        StackOp <= 3'b000;

                        IS <= 4;
                    end
                    4: begin 
                        // initiate register write
                        RegW <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // finish register write
                        RegW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            // I-type arithmetic operations
            ADDI,SUBI,ANDI,ORI,XORI,NORI,NOTI,SLAI,SRLI,SRAI,SLTI,SGTI: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin
                        BranchOp <= 3'b000;
                        ALUOp <= opcode;
                        ALUSrc <= 1;
                        MemR <= 0;
                        MemW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0;
                        StackOp <= 3'b000;

                        IS <= 4;
                    end 
                    4: begin 
                        // initiate register write
                        RegW <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // finish register write
                        RegW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end
            // I-type branch operations

            // BR Imm 
            BR: begin
                case(IS) 
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b001;
                        ALUOp <= 4'b0001;   // ADD is required
                        ALUSrc <= 1;        // imm is used
                        MemR <= 0;
                        MemW <= 0;
                        RegW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0; 
                        StackOp <= 3'b000; // this and above 5 are irrelevant

                        IS <= 4;
                    end
                    4: begin 
                        // buffer state to finish ALU operations

                        IS <= 5;
                    end
                    5: begin 
                        // finish 
                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            BPL: begin
                case(IS) 
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b010;
                        ALUOp <= 4'b0001;   // ADD is required
                        ALUSrc <= 1;        // imm is used
                        MemR <= 0;
                        MemW <= 0;
                        RegW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0; 
                        StackOp <= 3'b000; // this and above 5 are irrelevant

                        IS <= 4;
                    end
                    4: begin 
                        // buffer state to finish ALU operations

                        IS <= 5;
                    end 
                    5: begin 
                        // finish 
                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase

                
            end

            BMI: begin
                case(IS) 
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b011;
                        ALUOp <= 4'b0001;   // ADD is required
                        ALUSrc <= 1;        // imm is used
                        MemR <= 0;
                        MemW <= 0;
                        RegW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0; 
                        StackOp <= 3'b000; // this and above 5 are irrelevant

                        IS <= 4;
                    end
                    4: begin 
                        // buffer state to finish ALU operations

                        IS <= 5;
                    end
                    5: begin 
                        // finish 
                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            BZ: begin
                case(IS) 
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b100;
                        ALUOp <= 4'b0001;   // ADD is required
                        ALUSrc <= 1;        // imm is used
                        MemR <= 0;
                        MemW <= 0;
                        RegW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0; 
                        StackOp <= 3'b000; // this and above 5 are irrelevant

                        IS <= 4;
                    end
                    4: begin 
                        // buffer state to finish ALU operations

                        IS <= 5;
                    end
                    5: begin 
                        // finish 
                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end


            // I-type load and store operations
            LD: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0001;   // ADD is required
                        ALUSrc <= 1;        // imm is used 
                        RegDst <= 0;
                        StackOp <= 3'b000;

                        IS <= 4; 
                    end
                    4: begin 
                        // initiate memory read
                        MemR <= 1;
                        MemW <= 0;

                        IS <= 5;
                    end
                    5: begin 
                        // write to register
                        MemR <= 0;
                        MemtoReg <= 1;
                        RegW <= 1;

                        IS <= 6;
                    end
                    6: begin 
                        // finish 
                        MemtoReg <= 0;
                        RegW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0; 
                    end
                endcase
            end

            ST: begin
                case(IS) 
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0001;   // ADD is required
                        ALUSrc <= 1;      // imm is used 
                        RegDst <= 0;
                        StackOp <= 3'b000;
                        MemR <= 0;

                        IS <= 4; 
                    end
                    4: begin 
                        // buffer state to finish ALU operations

                        IS <= 5;
                    end
                    5: begin 
                        // initiate memory write
                        MemW <= 1;

                        IS <= 6;
                    end
                    6: begin 
                        // finish 
                        MemW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            // I-type move operation - implemented similar to ADDI (Rt = Rs + 0)
            MOVE: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0001;
                        ALUSrc <= 1;
                        MemR <= 0;
                        MemW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0;
                        StackOp <= 3'b000;

                        IS <= 4;
                    end 
                    4: begin 
                        // initiate register write
                        RegW <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // finish register write
                        RegW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            // I-type stack operations + RET (miscellaneous)
            PUSH: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0001; // ADD will be used (Rs + 0)
                        ALUSrc <= 1;      // imm is used
                        MemR <= 0;
                        MemtoReg <= 0;
                        RegDst <= 1; // write to Rd
                        StackOp <= 3'b001;

                        IS <= 4;
                    end
                    4: begin 
                        // initiate register write
                        RegW <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // initiate memory write
                        RegW <= 0;
                        MemW <= 1;

                        IS <= 6;
                    end
                    6: begin 
                        // finish

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            POP: begin
                case(IS) 
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0001; // ADD will be used (Rt + 0)
                        ALUSrc <= 1;      // imm is used
                        MemW <= 0;
                        RegDst <= 0;    // initially Rt will be written to 
                        MemtoReg <= 1;  // initially LMD will be used
                        StackOp <= 3'b010;

                        IS <= 4;
                    end
                    4: begin 
                        // read from memory
                        MemR <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // initiate register write to Rt
                        MemR <= 0;
                        RegW <= 1;

                        IS <= 6;
                    end
                    6: begin 
                        // finish register write to Rt
                        RegW <= 0; 
                        
                        // start register write to Rd
                        RegDst <= 1;
                        MemtoReg <= 0; // SPout will be used this time

                        IS <= 7;
                    end
                    7: begin 
                        // write to Rd
                        RegW <= 1;

                        IS <= 8;
                    end
                    8: begin 
                        // finish register write to Rd
                        RegW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            CALL: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000; 
                        ALUOp <= 4'b0001; // ADD will be used (PC + Imm)
                        ALUSrc <= 1;      // imm is used
                        MemR <= 0;
                        MemtoReg <= 0; // SPout will be used
                        RegDst <= 1; // Rd (SP) will be written to 
                        StackOp <= 3'b011;

                        IS <= 4;
                    end
                    4: begin 
                        // write to register 
                        RegW <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // initiate memory write
                        RegW <= 0;
                        MemW <= 1;

                        // $display("CALL state 2");
                        IS <= 6;
                    end
                    6: begin
                        // finish memory write
                        MemW <= 0;

                        IS <= 7; 
                    end
                    7: begin 
                        updatePC <= 1; // will be updated as PC + Imm -> need to check this
                        
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            RET: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0001; // no need for ALUOp
                        ALUSrc <= 1;      // not releevant
                        MemW <= 0;      
                        MemtoReg <= 0; // SPout will be used
                        RegDst <= 1; // Rd (SP) will be written to 
                        StackOp <= 3'b100;

                        IS <= 4;
                    end
                    4: begin    
                        // read from memory (for PC)
                        MemR <= 1;

                        IS <= 5;
                    end
                    5: begin 
                        // start register write to Rd
                        MemR <= 0;
                        RegW <= 1;

                        IS <= 6;
                    end
                    6: begin
                        // finish register write to Rd
                        RegW <= 0;

                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            // HALT 
            HALT: begin
                case(IS)
                    0: begin
                        IS <= 1;
                    end
                    1: begin 
                        IS <= 2;
                    end
                    2: begin 
                        IS <= 3;
                    end
                    3: begin 
                        BranchOp <= 3'b000;
                        ALUOp <= 4'b0000;
                        ALUSrc <= 0;
                        MemR <= 0;
                        MemW <= 0;
                        RegW <= 0;
                        MemtoReg <= 0;
                        RegDst <= 0;
                        StackOp <= 3'b000;   

                        if (INT) IS <= 4; 
                    end
                    4: begin 
                        updatePC <= 1;
                        IS <= 0;
                        CS <= 0;
                    end
                endcase
            end

            // NOP
            default: begin
                BranchOp <= 3'b000;
                ALUOp <= 4'b0000;
                ALUSrc <= 0;
                MemR <= 0;
                MemW <= 0;
                RegW <= 0;
                MemtoReg <= 0;
                RegDst <= 0;
                StackOp <= 3'b000;
            end

        endcase
        end
        endcase
    end
endmodule