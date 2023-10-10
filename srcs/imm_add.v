`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2023 16:35:10
// Design Name: 
// Module Name: imm_add
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


module imm_add( input [31:0] imm_in,
                 input [31:0] pc,
                 output [31:0] pc_out
                 );
                 assign pc_out=imm_in+pc;
                 
                 


endmodule
