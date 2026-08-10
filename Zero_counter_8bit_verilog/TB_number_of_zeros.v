`timescale 1ns / 1ps

module TB_number_of_zeros();

reg [7:0] in;
reg clk;
reg reset;
wire [3:0] count;
integer i;
Number_of_zeros DUT (
    .in(in),
    .clk(clk),
    .reset(reset),
    .count(count)
);
always #5 clk = ~clk;

initial begin
$monitor("Time=%0t | Reset=%b | In=%b | Clk=%b | Count=%d",$time, reset, in, clk, count);

    clk = 0;
    in = 8'b00000000;
    reset = 1;
    #10;
    reset = 0;
     for(i = 0; i < 256; i = i + 1) begin
        in = i;
        #10;
    end
    $finish;
end

endmodule