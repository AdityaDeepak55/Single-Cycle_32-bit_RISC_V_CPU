
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2023 15:45:24
// Design Name: 
// Module Name: reg_file
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


module reg_file(  input clk,
                  input [4:0] rs1,
                  input [4:0] rs2,
                  input [4:0] write_reg,
                  input [31:0] w_data,
                  input reg_write,
                  output [31:0] rs1_out,
                  output [31:0] rs2_out);
                  
          
              
   reg [31:0]  cpu_regs [31:0] ;
   initial $readmemh ("init_reg.mem",cpu_regs);
   
   always @(posedge clk)
   begin
        cpu_regs[0] <= 32'h0;
		if (reg_write) cpu_regs[write_reg] <= w_data;

   end


   assign rs1_out =  cpu_regs[rs1[4:0]];
   assign rs2_out = cpu_regs[rs2[4:0]];
                     

              
              
endmodule