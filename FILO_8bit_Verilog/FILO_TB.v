`timescale 1ns / 1ps

module FILO_TB();

reg [7:0] in;
reg clk;
reg rst;
reg push;
reg pop;

wire [4:0] count;
wire full;
wire empty;
wire overflow;
wire underflow;
wire [7:0] out;

// Instantiate the Device Under Test (DUT)
FILO dut (
    .in(in),
    .clk(clk),
    .rst(rst),
    .push(push),
    .pop(pop),
    .count(count),
    .full(full),
    .empty(empty),
    .overflow(overflow),
    .underflow(underflow),
    .out(out)
);

// Generate clock (period = 10ns, frequency = 100MHz)
always #5 clk = ~clk;

initial begin
    // Initialize Inputs
    clk = 0;
    rst = 1;
    in = 8'd0;
    push = 0;
    pop = 0;

    #20;
    rst = 0; // Release reset

    // Test Case 1: Sequential Push operations
    $display("\n--- Test Case 1: Pushing 5 elements (10, 20, 30, 40, 50) ---");
    #10;
    push = 1;
    in = 8'd10; #10;
    in = 8'd20; #10;
    in = 8'd30; #10;
    in = 8'd40; #10;
    in = 8'd50; #10;
    push = 0;
    #20;

    // Test Case 2: Sequential Pop operations (Observe reverse order output)
    $display("\n--- Test Case 2: Popping 5 elements (Expected: 50, 40, 30, 20, 10) ---");
    pop = 1;
    #50;
    pop = 0;
    #20;

    // Test Case 3: Fill stack to maximum capacity (16 items)
    $display("\n--- Test Case 3: Filling Stack to Max Capacity (16 items) ---");
    push = 1;
    in = 8'd1;  #10;
    in = 8'd2;  #10;
    in = 8'd3;  #10;
    in = 8'd4;  #10;
    in = 8'd5;  #10;
    in = 8'd6;  #10;
    in = 8'd7;  #10;
    in = 8'd8;  #10;
    in = 8'd9;  #10;
    in = 8'd10; #10;
    in = 8'd11; #10;
    in = 8'd12; #10;
    in = 8'd13; #10;
    in = 8'd14; #10;
    in = 8'd15; #10;
    in = 8'd16; #10;
    push = 0;
    #10;

    // Test Case 4: Force stack overflow
    $display("\n--- Test Case 4: Testing Overflow Condition (Push when full) ---");
    push = 1;
    in = 8'd99; // Should trigger overflow flag and be ignored
    #10;
    push = 0;
    #20;

    // Test Case 5: Empty stack completely
    $display("\n--- Test Case 5: Emptying Stack (Popping 16 items) ---");
    pop = 1;
    #160;
    pop = 0;
    #20;

    // Test Case 6: Force stack underflow
    $display("\n--- Test Case 6: Testing Underflow Condition (Pop when empty) ---");
    pop = 1; // Should trigger underflow flag
    #10;
    pop = 0;
    #20;

    // Test Case 7: Simultaneous Push and Pop on Empty Stack
    $display("\n--- Test Case 7: Simultaneous Push and Pop on Empty Stack ---");
    push = 1;
    pop = 1;
    in = 8'd88; // Should perform push to empty, pop should fail and trigger underflow
    #10;
    push = 0;
    pop = 0;
    #20;

    // Test Case 8: Simultaneous Push and Pop on Partially Filled Stack
    $display("\n--- Test Case 8: Simultaneous Push and Pop on Partially Filled Stack (Expected: pop 88, push 77) ---");
    // Currently stack has 1 item (88). Let's push/pop simultaneously.
    push = 1;
    pop = 1;
    in = 8'd77; // Should return 88 and write 77 to the top of stack
    #10;
    push = 0;
    pop = 0;
    #20;

    // Let's pop to verify the new top is 77
    pop = 1;
    #10;
    pop = 0;
    #20;

    $display("\n--- Simulation Complete ---");
    $finish;
end

// Monitor operations in terminal output
initial begin
    $monitor("Time=%0t ns | rst=%b | push=%b | pop=%b | in=%d | out=%d | count=%d | full=%b | empty=%b | overflow=%b | underflow=%b", 
             $time, rst, push, pop, in, out, count, full, empty, overflow, underflow);
end

endmodule
