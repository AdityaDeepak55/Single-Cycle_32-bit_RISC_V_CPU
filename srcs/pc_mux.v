`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2023 09:51:46
// Design Name: 
// Module Name: pc_mux
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


module pc_mux( input [1:0] PC_src,
               input [31:0] imm,
               input [31:0] PC_plus4,
               input [31:0] pc_next,
               output reg [31:0]  PC_data
              );
              always @ (*)
              begin
              case (PC_src)
              2'b00: PC_data=PC_plus4;
              2'b01:PC_data=imm;
              2'b10: PC_data= pc_next;
              endcase
              end

              
   
endmodule
