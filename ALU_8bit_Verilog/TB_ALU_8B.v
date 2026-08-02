`timescale 1ns / 1ps
module TB_ALU_8B();
    reg[7:0] a, b;
    reg[3:0] op_sel;
    wire[7:0] alu_out;
    integer i;
    ALU_8B uut(
        .a(a),
        .b(b),
        .op_sel(op_sel),
        .alu_out(alu_out)
    );
    initial
    begin
        op_sel = 4'b0000;
        a = 8'd45;
        b = 8'd12;   
        $monitor("op_sel=%d | a=%d | b=%d | alu_out=%d", op_sel, a, b, alu_out);      
        for(i = 0; i < 16; i = i + 1)
        begin
            op_sel = i;       
            a = 8'd45;  b = 8'd12;  #10;
            a = 8'd128; b = 8'd5;   #10;
            a = 8'd0;   b = 8'd255; #10;
            a = 8'd23;  b = 8'd0;   #10;
            a = 8'd99;  b = 8'd99;  #10;
        end    
        $finish;  
    end

endmodule