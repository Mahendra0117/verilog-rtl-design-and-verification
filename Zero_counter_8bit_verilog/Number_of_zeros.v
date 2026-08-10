`timescale 1ns / 1ps
module Number_of_zeros(
        input [7:0]in,
        input clk,reset,
        output reg [3:0]count );
  integer i;
 always@(posedge clk)
 begin
 if(reset)begin
    count<=4'b0;
    end
 else begin
    for(i=0;i<8;i=i+1)
        begin
            if(in[i] == 0)
                begin
                    count=count+1'b1;
                end
        end
    end    
 end        
endmodule
