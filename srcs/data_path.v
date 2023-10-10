module data_path ( input [31:0] rs1,
		   input [31:0] rs2,
		   input [3:0] alu_control,
		   input [2:0] store_sel,
		   input [2:0] dm_sel,
		   input [2:0] imm_sel,
		   input [2:0] br_sel,
		   input reg_write,
		   input dm_write,
		   input wd_src,
		   input pc_src,
		   input [31:0]  pc_start
		 );

	wire br_taken;
	reg [31:0] pc_next,pc_now,next_pc;
	reg [31:0] inp1,inp2,result;
	reg [3:0] alu_ctrl;
	wire zero_flag,carry_flag;
	reg [31:0] imm;

	pc_add pc_4( .pc_data(pc_now),
		    .next_pc(next_pc);
	pc_now = pc_start
	ALU alu( .inp1(inp1),
		 .inp2(inp2),
		 .alu_ctrl(alu_ctrl),
		 .result(result),
		 .zero_flag(zero_flag),
		 .carry_flag(carry_flag));
	
	pc_mux pcmux( .PC_src(pc_src),
		      .imm(imm),
		      .PC_plus4(next_pc),
		      .pc_next(result),
		      .PC_data(pc_next));

      		      
