`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2023 18:27:31
// Design Name: 
// Module Name: sign_extend
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


module sign_extend( input [2:0] imm_select,
                    input [31:0] instr,
                    output reg [31:0] Imm_out

    );
    always @(*) 
    begin
    case (imm_select)
     3'b000: Imm_out= {{20{instr[31]}},instr[31:20]}; //I-immediate
     3'b001: Imm_out= {{21{instr[31]}}, instr[30:25],instr[11:7]};          //S-immediate
     3'b010:  Imm_out= {{20{instr[31]}}, instr[7],instr[30:25],instr[11:8],1'b0}; //B-immediate 
     3'b011:  Imm_out= {instr[31],instr[30:12],{12{1'b0}}};                      //U-immediate
     3'b100:  Imm_out={{12{instr[31]}}, instr[19:12],instr[20],instr[30:21],1'b0}; //J-immediate 
     default:Imm_out=32'h0;
    
     
    endcase
    end
endmodule
