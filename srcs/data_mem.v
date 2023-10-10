module data_mem(  input [31:0] w_data, 
                  input w_en,
                  input clk, 
                  input [31:0] w_addr,
                  output [31:0] r_data
                  );
 

reg [31:0] data_mem [0:63];  /*256B mem*/
 initial $readmemh ("data.mem",data_mem);

always @(posedge clk)
 begin 
   if (w_en)
     data_mem[w_addr>>2]<=w_data  ;
 end
 
 assign r_data = data_mem[w_addr>>2];                
 endmodule
  