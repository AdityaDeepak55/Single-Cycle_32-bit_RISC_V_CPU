`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 18:21:37
// Design Name: 
// Module Name: load
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


module load(      input [2:0] dm_sel,
                  input [1:0] addr,
                  input [31:0] data,
                  output reg [31:0] d_out

    );
    
always @(*)
 case (dm_sel)
   3'b000:  d_out=  ((data << ((3-{3'd0,addr[1:0]})<<3))) >> 24;      //lbu
   3'b001: d_out=  ((data << ((2-{3'd0,addr[1]})<<3))) >> 16;         //lhu
   3'b010: d_out=((data << ((3-{3'd0,addr[1:0]})<<3))) >>> 24  ;              //lb
   3'b100: d_out=((data << ((2-{3'd0,addr[1], 1'd0})<<3))) >>> 16 ;
   3'b101: d_out=data;
   default:  d_out=32'h0;
   endcase
endmodule
