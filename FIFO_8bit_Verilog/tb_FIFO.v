`timescale 1ns / 1ps

module tb_FIFO_8bit();

reg [7:0] in;
reg clk;
reg rst;
reg rd_en;
reg wr_en;

wire [4:0] count;
wire full;
wire empty;
wire [7:0] out;

FIFO_8bit dut (
    .in(in),
    .clk(clk),
    .rst(rst),
    .rd_en(rd_en),
    .wr_en(wr_en),
    .count(count),
    .full(full),
    .empty(empty),
    .out(out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    in = 8'd0;
    rd_en = 0;
    wr_en = 0;

    #20;
    rst = 0;

    #10;
    wr_en = 1;
    in = 8'd10;
    #10 in = 8'd20;
    #10 in = 8'd30;
    #10 in = 8'd40;
    #10 in = 8'd50;
    #10 wr_en = 0;

    #20;
    rd_en = 1;
    #30;
    rd_en = 0;

    #20;
    wr_en = 1;
    in = 8'd111;
    #10 wr_en = 0;

    #20;
    wr_en = 1;
    rd_en = 1;
    in = 8'd222;
    #10;
    in = 8'd255;
    #10;
    wr_en = 0;
    rd_en = 0;

    #50 $finish;
end

initial begin
    $monitor("Time=%0t | rst=%b | wr_en=%b | rd_en=%b | in=%d | out=%d | count=%d | full=%b | empty=%b", 
             $time, rst, wr_en, rd_en, in, out, count, full, empty);
end

endmodule
