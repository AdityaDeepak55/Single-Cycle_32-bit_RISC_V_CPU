`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 12:09:53 PM
// Design Name: 
// Module Name: seg_7_control
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


module seg7_driver(
    input clk_100MHz,
    input reset,
    input dm_write,
    input [15:0] data_in,
    output reg [0:6] seg,       // segment pattern 0-f
    output reg [3:0] digit     // digit select signals
    );
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2 
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter A     = 7'b000_1000;  // A
    parameter B     = 7'b110_0000;  // B
    parameter C     = 7'b011_0001;  // C
    parameter D     = 7'b100_0010;  // D
    parameter E     = 7'b011_0000;  // E
    parameter F     = 7'b011_1000;  // F
    
    // To select each digit in turn
    reg [1:0] digit_select;     // 2 bit counter for selecting each of 4 digits
    reg [16:0] digit_timer;     // counter for digit refresh
    reg [15:0] displayed_data;
  always @(posedge clk_100MHz or posedge reset)
    begin
        if(reset==1)
            displayed_data <= 0;
        else if (dm_write==1)
            displayed_data <= data_in;
    end
    
    // Logic for controlling digit select and digit timer
    always @(posedge clk_100MHz or posedge reset) begin
        if(reset) begin
            digit_select <= 0;
            digit_timer <= 0; 
        end
        else                                        // 1ms x 4 displays = 4ms refresh period
            if(digit_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
                digit_timer <= 0;                   // 10ns x 100,000 = 1ms
                digit_select <=  digit_select + 1;
            end
            else
                digit_timer <=  digit_timer + 1;
    end
    
    // Logic for driving the 4 bit anode output based on digit select
    always @(digit_select) begin
        case(digit_select) 
            2'b00 : digit = 4'b1110;   // Turn on ones digit
            2'b01 : digit = 4'b1101;   // Turn on tens digit
            2'b10 : digit = 4'b1011;   // Turn on hundreds digit
            2'b11 : digit = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    // Logic for driving segments based on which digit is selected and the value of each digit
    always @*
        case(digit_select)
            2'b00 : begin       // ONES DIGIT
                        case(displayed_data[3:0])
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F;                       
                          endcase
                    end
                    
            2'b01 : begin       // TENS DIGIT
                        case(displayed_data[7:4])
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F; 
                        endcase
                    end
                    
            2'b10 : begin       // HUNDREDS DIGIT
                        case(displayed_data[11:8])
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F; 
                            
                        endcase
                    end
                    
            2'b11 : begin       // MINUTES ONES DIGIT
                        case(displayed_data[15:12])
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F; 
                        endcase
                    end
        endcase

endmodule