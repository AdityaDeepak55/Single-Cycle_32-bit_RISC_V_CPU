`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2023 13:58:40
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


module ALU (
	input [31:0] inp1,
	input [31:0] inp2,
	input [3:0] alu_ctrl,
	output reg [31:0] result
);
    always @(*)
	case(alu_ctrl)

	4'b0000: result = inp1 & inp2;
	4'b0001: result = inp1 | inp2;
	4'b0010: result = inp1 + inp2;
	4'b0011: result = inp1 << inp2[4:0];
	4'b0100: result = inp1 ^ inp2;
	4'b0101: result = inp1 + (~inp2) + 1;

	4'b0110: result = inp1 < inp2 ? 32'h1 : 32'h0;
	4'b0111: result= $signed(inp1)<$signed(inp2) ? 32'h1:32'h0;
	4'b1000: result = inp1 >> inp2[4:0];
	4'b1001: result = inp1 >>> inp2[4:0];
	4'b1010: result = ~(inp1 | inp2);
	default:result=32'h0;
	endcase
endmodule

