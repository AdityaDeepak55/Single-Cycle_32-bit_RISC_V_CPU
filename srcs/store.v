`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 19:53:48
// Design Name: 
// Module Name: store
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


module store(      input [31:0] data, 
                   input [31:0] r_data,
                   input [2:0] store_sel,
                   input [1:0] addr,
                   output reg [31:0] data_out

    );
    always @(*)
                   begin
                   case (store_sel)
                   2'b00: data_out= (r_data & ~(32'h000000ff << ({3'd0,addr[1:0]} << 3))) | ({24'h000000,data[7:0]}<<({3'd0,addr[1:0]}<<3));       //store byte
                   2'b01: data_out= (r_data & ~(32'h0000ffff << ({3'd0,addr[1],1'd0} << 3))) | ({16'h0000,data[15:0]}<<({3'd0,addr[1], 1'd0}<<3));       //store half word
                   2'b10: data_out= data;                        //store word
                   default:data_out=32'h0;
                   endcase
                   end
endmodule
