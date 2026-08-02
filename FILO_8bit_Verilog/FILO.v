`timescale 1ns / 1ps
module FILO(
       input [7:0]in,
       input clk,rst,
       input push,pop,
       output full,empty,
       output reg [4:0]count = 5'b00000,
       output reg [7:0]out = 8'd0
            );
  reg [3:0] ptr;         
  reg [7:0]mem[15:0];
 assign full =(count==5'd16) ;
 assign empty =(count==5'd0);
  always@(posedge clk)
  begin 
   if(rst)
   begin
      ptr<=4'b0000;
      count<=5'b00000;
      out<=8'd0;  
     
      
   end else 
           if(push & !pop & !full)
         begin
           mem[ptr]<=in;
           ptr<=ptr+1'b1;
           count<=count+1'b1;       
         end else 
           if(pop & !push & !empty)
         begin
           ptr<=ptr-1'b1;
           count<=count-1'b1;
           out<=mem[ptr-1'b1];
         end else 
           if(push & pop)
         begin
            out<=mem[ptr-1'b1];
            mem[ptr-1'b1]<=in;
         end
  end
endmodule
