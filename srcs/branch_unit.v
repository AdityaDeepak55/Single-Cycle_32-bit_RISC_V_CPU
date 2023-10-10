`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2023 10:27:13
// Design Name: 
// Module Name: branch_unit
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


module branch_unit( input [31:0] rs1,
                    input [31:0] rs2,
                    input [2:0] br_sel,
                    output reg branch_taken 
                   );
                   
                   always @(br_sel)
                   
                   case (br_sel)
                    3'b000: branch_taken=(rs1==rs2)? 1'b1:1'b0; //beq
                    3'b001: branch_taken=(rs1!=rs2)? 1'b1:1'b0;  //bne
                    3'b010: branch_taken= $signed(rs1)>=$signed(rs2)? 1'b1:1'b0; //bge
                    3'b011:branch_taken= $signed(rs1)<$signed(rs2)? 1'b1:1'b0; //blt
                    3'b100:branch_taken= (rs1<rs2)? 1'b1:1'b0; //bltu
                    3'b101: branch_taken=(rs1>=rs2)? 1'b1:1'b0; //bgeu
                    3'b110:branch_taken=1'b1;                   // jalr/jal
                    default: branch_taken=1'b0;
                    endcase

                    
                    
                    

endmodule
