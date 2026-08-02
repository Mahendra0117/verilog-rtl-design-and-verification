`timescale 1ns / 1ps
module ALU_8B(
     input wire[7:0]a,b,
     input wire[3:0]op_sel,
     output reg [7:0]alu_out
      );
 always@(*)
 begin
 case(op_sel)
     4'b0000:alu_out=a+b;
     4'b0001:alu_out=a-b;
     4'b0010:alu_out=a*b;
     4'b0011:alu_out= (b==0)?8'b0:(a/b);
     4'b0100:alu_out=a&b;
     4'b0101:alu_out=a|b;
     4'b0110:alu_out=~a;
     4'b0111:alu_out=~b;
     4'b1000:alu_out=a^b;
     4'b1001:alu_out=~(a&b);
     4'b1010:alu_out=~(a|b);
     4'b1011:alu_out=a>>1;
     4'b1100:alu_out=a<<1;
     4'b1101:alu_out=b>>1;
     4'b1110:alu_out=b<<1;
     default:alu_out=~(a^b);
         
 endcase
 end
      
endmodule
