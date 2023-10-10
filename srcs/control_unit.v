`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2023 19:53:13
// Design Name: 
// Module Name: control_unit
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


module control_unit( input [31:0] instr,
                     input branch_taken,
                     output reg[3:0] alu_control,
                     output reg [2:0] store_sel,
                     output reg [2:0] dm_sel,
                     output reg [2:0] imm_sel,
                
                     output  reg_write,
                     output reg dm_write,
                     output reg [2:0] wd_src,
                     output reg A_sel,
                     output reg B_sel,
                     output reg [1:0] pc_src,
                     output reg [2:0] br_sel,
                     output [4:0] rd,
                     output [4:0] rs1,
                     output [4:0] rs2,
                     output reg hlt
                     

                    );

  wire [31:25] funct7;
  wire [6:0] opcode;     
  wire [14:12] funct3;
  wire [3:0] alu_in;
     
  assign opcode = instr[6:0];
  assign funct7=instr[31:25];
  assign rs2=instr[24:20];
  assign rs1=instr[19:15];
  assign funct3= instr[14:12];
  assign rd=instr[11:7];
                    
 wire isALUreg;                   
 // instr_decode 
 
    assign isALUreg =  (opcode == 7'b0110011); // rd <- rs1 OP rs2   
    assign isALUimm =  (opcode == 7'b0010011); // rd <- rs1 OP Iimm
    assign isBranch =  (opcode == 7'b1100011); // if(rs1 OP rs2) PC<-PC+Bimm
    assign isJALR   =  (opcode == 7'b1100111); // rd <- PC+4; PC<-rs1+Iimm
    assign isJAL    =  (opcode == 7'b1101111); // rd <- PC+4; PC<-PC+Jimm
    assign isAUIPC  =  (opcode == 7'b0010111); // rd <- PC + Uimm
    assign isLUI    =  (opcode == 7'b0110111); // rd <- Uimm   
    assign isLoad   =  (opcode == 7'b0000011); // rd <- mem[rs1+Iimm]
    assign isStore  =  (opcode == 7'b0100011); // mem[rs1+Simm] <- rs2
    assign isSYSTEM =  (opcode == 7'b1110011); // special
    
    always @(*)
    begin
    if (isSYSTEM)
    hlt=1'b1;
    else hlt=1'b0;
    end

    assign reg_write = isALUreg || isALUimm || isLoad || isLUI || isAUIPC || isJAL || isJALR;
    assign alu_in={funct7[30],funct3};
    
    
   always @(*)
    begin
    if (isALUreg) 
       case (alu_in) 
       4'b0000: alu_control=4'b0010;  //add
       4'b1000:alu_control=4'b0101;   //sub
       4'b0010:alu_control=4'b0110;   //slt
       4'b0011:alu_control=4'b0111;   //sltu
       4'b0100:alu_control=4'b0100;   //xor
       4'b0101:alu_control=4'b1000;    //srl
       4'b0110:alu_control=4'b0001;   //or
       4'b0111:alu_control=4'b0000;   //and
       4'b0001:alu_control=4'b0011;   //sll
       4'b1101:alu_control=4'b1001;   //sra
       default:alu_control=4'b1111;  
       endcase
    else if (isALUimm)
    case (funct3) 
       3'b000: alu_control=4'b0010;  //addi
       3'b010:alu_control=4'b0110;   //slti
       3'b011:alu_control=4'b0111;   //sltiu
       3'b100:alu_control=4'b0100;   //xori
       3'b101:alu_control=4'b1000;    //srli
       3'b110:alu_control=4'b0001;   //ori
       3'b111:alu_control=4'b0000;   //andi
       3'b001:alu_control=4'b0011;   //slli
       default:alu_control=4'b1111;  
    endcase
    else if (isALUimm && funct7[30])
       alu_control=4'b1001;    //srai
    else 
        alu_control=4'b0010;
   end
   always @(*)
    if (isBranch)
       case(funct3)
       3'b000:br_sel=3'b000;
       3'b001:br_sel=3'b001;
       3'b100:br_sel=3'b011;
       3'b101:br_sel=3'b010;
       3'b110:br_sel=3'b100;
       3'b111:br_sel=3'b101;
       default:br_sel=3'b111;
       endcase
    else if (isJAL ||isJALR)
       br_sel=3'b110;
    else br_sel=3'b111;

   always@(*)   
   if (isLoad)
       case(funct3)
       3'b000:dm_sel=3'b010;  //lb
       3'b001:dm_sel=3'b100;  //lh
       3'b010:dm_sel=3'b101;  //lw
       3'b100:dm_sel=3'b000;  //lbu
       3'b101:dm_sel=3'b001;  //lhu
       default:dm_sel=3'b111;
       endcase
   else
       dm_sel=3'b111;
       
    always@(*) 
    if (isStore)
       case(funct3)
       2'b00:store_sel=2'b00;  //lb
       2'b01:store_sel=2'b01;  //lh
       2'b10:store_sel=2'b10;  //lw
       default:store_sel=2'b11;
       endcase
    else 
    store_sel=2'b11; 
        

    
   
   always @(*)
   begin
   if (isALUimm || isLoad)
     imm_sel=3'b000;
   else if (isBranch)
     imm_sel=3'b010;
   else if (isStore)
     imm_sel=3'b001;
   else if (isJAL || isJALR)
     imm_sel=3'b100;
   else if( isLUI || isAUIPC) 
     imm_sel=3'b011;
   else 
     imm_sel=3'b111;
   end
   
   
   
   always @ (*)
   begin
   if (isStore)
     dm_write=1'b1;
   else dm_write=1'b0;
   end
   
   
   always @ (*)
   begin
   if (isALUreg) 
   begin
      A_sel= 1'b0;   //rs1
      B_sel=1'b0;    //rs2
   end
   else if (isBranch || isAUIPC || isJAL)
   begin
      A_sel=1'b1;   //pc
      B_sel=1'b1;   //imm
   end
   else if( isJALR || isALUimm || isLoad || isStore )
   begin
      A_sel=1'b0;    //rs1
      B_sel=1'b1;    //immediate
   
   end
   else 
   begin
      A_sel=1'b0;   
      B_sel=1'b0;   
   end
   end
      
      
    always @ (*)
    begin
    if (isALUreg || isALUimm )
     wd_src=3'b000;
    else if (isLoad)
     wd_src=3'b001;
    else if (isJAL || isJALR)
     wd_src=3'b010;
    else if (isLUI)
     wd_src=3'b011;
    else if (isAUIPC)
     wd_src=3'b100;
    else 
    wd_src=3'b111;
    end
    
//    branch_unit br_unit (.rs1(rs1),.rs2(rs2),.br_sel(br_sel),.branch_taken(br_taken));

    
    always @ (*)
    begin
    if (isJALR)
      pc_src=2'b01;  //load alu_out to to pc
    else if (isJAL || branch_taken)
      pc_src=2'b10;  //load pc+imm to pc
    else 
      pc_src=2'b00;   //pc=pc+4
    end
      
    
  
      
     
   
    
   
   
   
   
   
 
endmodule
