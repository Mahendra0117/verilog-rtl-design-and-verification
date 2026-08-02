`timescale 1ns / 1ps

module FILO_TB;

    reg [7:0] in;
    reg clk;
    reg rst;
    reg push;
    reg pop;

    wire full;
    wire empty;
    wire [4:0] count;
    wire [7:0] out;

    FILO uut (
        .in(in),
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .full(full),
        .empty(empty),
        .count(count),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        push = 0;
        pop = 0;
        in = 8'd0;

        #20;
        rst = 0;

        #10;
        in = 8'hAA; 
        push = 1; 
        #10;
        
        in = 8'hBB; 
        push = 1; 
        #10;
        
        in = 8'hCC; 
        push = 1; 
        #10;
        
        push = 0; 
        #20;

        pop = 1; 
        #10;
        
        pop = 0; 
        #20;

        in = 8'hDD; 
        push = 1; 
        pop = 1; 
        #10;
        
        push = 0; 
        pop = 0; 
        #20;
        
        pop = 1;
        #30;
        
        pop = 0;

        #50;
        $finish;
    end

endmodule
