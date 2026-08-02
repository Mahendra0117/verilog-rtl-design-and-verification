`timescale 1ns / 1ps


module FIFO_8bit(
         input [7:0]in,
         input clk,rst,
         input  rd_en,wr_en,
         output reg [4:0]count = 5'b00000,
         output  full,empty,
         output reg [7:0] out = 8'd0);
         
reg [7:0]mem[15:0];
reg [3:0]rd_ptr,wr_ptr;
            assign full = (count == 5'b11111);
            assign empty = (count == 5'b00000) ;
always@(posedge clk)
begin
        if(rst)
        begin
            count<=5'b00000;
            wr_ptr<=5'b0000;
            rd_ptr<=5'b0000;
            out<=1'd0;
        end else 
        begin
        case({rd_en , wr_en}) 
      
        2'b10: if(!empty)
              begin
              out<=mem[rd_ptr];
              rd_ptr<=rd_ptr+1;
              count<=count-1;
              
              end
        2'b01: if(!full)
              begin
              mem[wr_ptr]<=in;
              wr_ptr<=wr_ptr+1;
              count<=count+1;
              
              end
         2'b11: if(!empty & !full)
               begin
               wr_ptr<=wr_ptr+1;
               rd_ptr<=rd_ptr+1;
               out<=mem[rd_ptr];
               mem[wr_ptr]<=in;
               count<=count;
                
               end     
        endcase
        end
         
        
end
        
endmodule
