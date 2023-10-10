`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2023 01:03:13
// Design Name: 
// Module Name: riscv_top
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


module riscv_top(input clk_100MHz ,
                 input preset,
                 input rst,
                 output [31:0] result

                  );
                  wire [31:0] instr;
                  wire [4:0] rs1,rs2,rd;
                  wire [3:0] alu_cntrl;
                  wire [2:0] wd_src,dm_sel,store_sel,imm_sel,br_sel;
                  wire [1:0] pc_src;
                  wire br_taken;
                  
                  
                 
                 control_unit CU (.instr(instr),
                     .branch_taken(br_taken),
                     .alu_control(alu_cntrl),
                     .store_sel(store_sel),
                     .dm_sel (dm_sel),
                     .imm_sel(imm_sel),
                     .reg_write(reg_write),
                     .dm_write(dm_write),
                     .wd_src(wd_src),
                     .br_sel(br_sel),
                     .A_sel(A_sel),
                     .B_sel(B_sel),
                     .pc_src(pc_src),
                     .rd(rd),
                     .rs1(rs1),
                     .rs2(rs2),
                     .hlt(hlt)
                     );
                     
                  datapath DU (.clk_in(clk),
                               .hlt(hlt),
                               .preset(preset),
                               .rst(rst),
                               .alu_control(alu_cntrl),
                               .rs1(rs1),
                               .rs2(rs2),
                               .rd(rd),
                               .br_sel(br_sel),
                               .store_sel(store_sel),
                               .dm_sel (dm_sel),
                               .imm_sel(imm_sel),
                               .reg_write(reg_write),
                               .dm_write(dm_write),
                               .wd_src(wd_src),
                               .A_sel(A_sel),
                               .B_sel(B_sel),
                               .pc_src(pc_src),
                               .start_addr(32'h0),
                               .instr(instr),
                               .result(result),
                               .br_taken(br_taken)
                        );
                   clk_wiz_0 clk_manager
                   (.clk_out1(clk),     // output clk_out1
                    .reset(rst),
                    .clk_in1(clk_100MHz)      // input clk_in1
                   );
                        
                    
                     
endmodule
