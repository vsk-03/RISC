`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 17:19:11
// Design Name: 
// Module Name: PC_control
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


module PC_control(BranchOp, StackOp, ALUout, regval, LMD, PCin, rst, clk, PCout);
    input [2:0] BranchOp;
    input [2:0] StackOp;
    input [31:0] ALUout;   // computed using ALU
    input signed [31:0] regval;   // will get from opcode computation
    input [31:0] LMD;      // memory output
    input [31:0] PCin;
    input rst, clk;
    output reg [31:0] PCout; 


    always @(posedge clk) begin
        // $display("BranchOp = %d, StackOp = %d, ALUout = %d, PCin = %d", BranchOp, StackOp, ALUout, PCin);
        if (rst) begin
            PCout <= 0;
        end
        else begin
            case (BranchOp)
               // 001 -> BR (unconditional branch)
                3'b001: begin
//                    $display("BR: branching to %d from %d", ALUout, PCin);
                    PCout <= ALUout; 
                end

                3'b010: begin
                    // 010 -> BPL (branch if positive)
                    if (regval > 0) begin
                        PCout <= ALUout;
                    end
                    else begin
                        PCout <= PCin + 1;
                    end 
                end

                3'b011: begin
                    // 011 -> BMI
                    if (regval < 0) begin
                        PCout <= ALUout;
                    end
                    else begin
                        PCout <= PCin + 1;
                    end
                end

                3'b100: begin
                    // 100 -> BZ (branch if zero)
                    if (regval == 0) begin
//                        $display("BZ: branching to %d from %d", ALUout, PCin);
                    
                        PCout <= ALUout;
                    end
                    else begin
                        PCout <= PCin + 1;
                    end
                end

                3'b000: begin 
                    // not a branching operation, but PC could change because of it being a stack operation 
                    case(StackOp)
                        // 001 -> PUSH
                        3'b001: begin
                            PCout <= PCin + 1;
                        end

                        // 010 -> POP
                        3'b010: begin
                            PCout <= PCin + 1;
                        end

                        // 011 -> CALL
                        3'b011: begin
                            PCout <= ALUout;
                        end

                        // 100 -> RET
                        3'b100: begin
                            PCout <= LMD; // check this
                        end

                        // default 
                        default: begin  
                            PCout <= PCin + 1;
                        end
                    endcase
                end
            endcase 
        end
        end
endmodule

