`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2023 14:08:58
// Design Name: 
// Module Name: datapath
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


module datapath( input clk_in,
                 input rst,
                 input preset,
                 input [3:0] alu_control,
                 input [4:0] rs1,
                 input [4:0] rs2,
                 input [4:0] rd,
                 input [2:0] store_sel,
                 input [2:0] dm_sel,
                 input [2:0] imm_sel,
                 input[2:0] wd_src,
                 input [2:0] br_sel,
                 input reg_write,
                 input dm_write,
                 input A_sel,
                 input B_sel,
                 input [1:0] pc_src,
                 input [31:0] start_addr,
                 input hlt,
                 output [31:0] instr,
                 output [31:0] result,
                 output br_taken
               );
              wire clk;
              wire [31:0] current_addr;
              reg [31:0] reg_in;
              reg [31:0] next_addr;
              wire [31:0] pc_plus4,imm_out,alu_out;
             
              assign clk=(hlt)?1'b0:clk_in;
              prog_counter pc (.clk(clk),.rst(rst),.pc_next(next_addr),.pc_data(current_addr),.start_addr(start_addr),.preset(preset));
              pc_add pc_adder(.pc_data(current_addr),.next_pc(pc_plus4));
              
              instr_mem imem (.instr_addr(current_addr),.instr_data(instr));
              
              wire [31:0]  instr_fetched;
              wire [31:0]Imm_out;
              assign instr_fetched=instr;
              sign_extend imm_extend (.imm_select(imm_sel),.instr(instr_fetched),.Imm_out(Imm_out));
              imm_add immediate_adder(.imm_in(Imm_out),.pc(current_addr),.pc_out(imm_out));
               
              wire [31:0] src1_out,src2_out;
              
              
              reg_file registers (.clk(clk),.rs1(rs1),.rs2(rs2),.write_reg(rd),.w_data(reg_in),.reg_write(reg_write),
              .rs1_out(src1_out),.rs2_out(src2_out));
              
              
              wire [31:0] alu_in1,alu_in2;
              assign alu_in1= (A_sel)? current_addr:src1_out;
              assign alu_in2= (B_sel)?Imm_out:src2_out;  
              
              wire [31:0] store_out;
              
              ALU alu(.inp1(alu_in1),.inp2(alu_in2),.alu_ctrl(alu_control),.result(alu_out));
              assign result=alu_out;
              
              wire [31:0] dm_out,load_out;
              
              data_mem DATA (.w_data(store_out),.w_en(dm_write),.clk(clk),.w_addr(alu_out),.r_data(dm_out));
              
//              load_unit LU (.dm_sel(dm_sel),.data(dm_out),.d_out(load_out));
              
//              store_unit SU (.data(src2_out),.store_sel(store_sel),.data_out(store_out));
              
              load LU (.dm_sel(dm_sel),.data(dm_out),.d_out(load_out),.addr(alu_out[1:0]));
              
              store SU (.data(src2_out),.store_sel(store_sel),.data_out(store_out),.addr(alu_out[1:0]),.r_data(dm_out));
              wire [31:0] load_in;
              assign load_in=load_out;
              
              always @(*)
              case (wd_src)
              3'b000:reg_in=alu_out;  //alu op
              3'b001:reg_in=load_in;  //load
              3'b010:reg_in=pc_plus4;    //jal/jalr
              3'b011:reg_in=Imm_out;   //LUI
              3'b100:reg_in=current_addr+Imm_out; //AUIPC
              default:reg_in=0;
              endcase
               
  
              always @(*)
              case (pc_src) 
              2'b00: next_addr=pc_plus4;
              2'b01: next_addr=alu_out;
              2'b10:next_addr=imm_out;
              default: next_addr=32'b0;
              endcase
              
             branch_unit branch_unit (.rs1(src1_out),.rs2(src2_out),.br_sel(br_sel),.branch_taken(br_taken));
              
              
              
              
              
endmodule
