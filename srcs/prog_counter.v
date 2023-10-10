module prog_counter( input clk,
                     input rst,
                     input preset,
                     input [31:0] start_addr,
                     input [31:0] pc_next,
                     output [31:0] pc_data
                     );
  reg [31:0] reg_pc=32'h0;
  always @( posedge clk)
  begin
  if (rst) reg_pc<=31'b0;
  else if (preset) reg_pc <=start_addr;
  else reg_pc<=pc_next;
  end
  assign pc_data= reg_pc;
  
  
  endmodule