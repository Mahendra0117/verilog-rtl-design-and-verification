`timescale 1ns / 1ps

module TB_ALU_8B();

    reg [7:0] A;
    reg [7:0] B;
    reg [3:0] opcode;
    
    wire [7:0] alu_out;
    wire carry_out;
    wire zero;

    // Instantiate the Device Under Test (DUT)
    ALU_8B dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .alu_out(alu_out),
        .carry_out(carry_out),
        .zero(zero)
    );

    initial begin
        // Initialize Inputs
        A = 8'd0;
        B = 8'd0;
        opcode = 4'h0;

        #10;

        // Test Case 0: Addition
        $display("\n--- Test Case 0: Addition ---");
        A = 8'd150; B = 8'd120; opcode = 4'h0; #10; // Out = 14 (270 - 256), Carry = 1, Zero = 0
        A = 8'd10;  B = 8'd20;  opcode = 4'h0; #10; // Out = 30, Carry = 0, Zero = 0
        A = 8'd0;   B = 8'd0;   opcode = 4'h0; #10; // Out = 0, Carry = 0, Zero = 1

        // Test Case 1: Subtraction
        $display("\n--- Test Case 1: Subtraction ---");
        A = 8'd50;  B = 8'd30;  opcode = 4'h1; #10; // Out = 20, Carry = 0, Zero = 0
        A = 8'd10;  B = 8'd20;  opcode = 4'h1; #10; // Out = 246 (-10), Carry = 1 (borrow), Zero = 0
        A = 8'd15;  B = 8'd15;  opcode = 4'h1; #10; // Out = 0, Carry = 0, Zero = 1

        // Test Case 2: Multiplication
        $display("\n--- Test Case 2: Multiplication ---");
        A = 8'd12;  B = 8'd8;   opcode = 4'h2; #10; // Out = 96, Carry = 0, Zero = 0
        A = 8'd255; B = 8'd2;   opcode = 4'h2; #10; // Out = 254 (510 & 8'hFF), Carry = 0, Zero = 0
        A = 8'd0;   B = 8'd45;  opcode = 4'h2; #10; // Out = 0, Zero = 1

        // Test Case 3: Division with Zero-Divisor Protection
        $display("\n--- Test Case 3: Division (including Zero-Divisor Check) ---");
        A = 8'd100; B = 8'd4;   opcode = 4'h3; #10; // Out = 25, Carry = 0, Zero = 0
        A = 8'd50;  B = 8'd0;   opcode = 4'h3; #10; // Out = 0 (Safe division check), Carry = 0, Zero = 1
        A = 8'd3;   B = 8'd5;   opcode = 4'h3; #10; // Out = 0, Zero = 1

        // Test Case 4: Logical AND
        $display("\n--- Test Case 4: Logical AND ---");
        A = 8'hF0;  B = 8'h3C;  opcode = 4'h4; #10; // Out = 8'h30, Zero = 0

        // Test Case 5: Logical OR
        $display("\n--- Test Case 5: Logical OR ---");
        A = 8'hF0;  B = 8'h3C;  opcode = 4'h5; #10; // Out = 8'hFC, Zero = 0

        // Test Case 6: Logical XOR
        $display("\n--- Test Case 6: Logical XOR ---");
        A = 8'hF0;  B = 8'h3C;  opcode = 4'h6; #10; // Out = 8'hCC, Zero = 0

        // Test Case 7: Logical NAND
        $display("\n--- Test Case 7: Logical NAND ---");
        A = 8'hF0;  B = 8'h3C;  opcode = 4'h7; #10; // Out = 8'hCF, Zero = 0

        // Test Case 8: Logical NOR
        $display("\n--- Test Case 8: Logical NOR ---");
        A = 8'hF0;  B = 8'h3C;  opcode = 4'h8; #10; // Out = 8'h03, Zero = 0

        // Test Case 9: Logical XNOR
        $display("\n--- Test Case 9: Logical XNOR ---");
        A = 8'hF0;  B = 8'h3C;  opcode = 4'h9; #10; // Out = 8'h33, Zero = 0

        // Test Case 10: Logical NOT A
        $display("\n--- Test Case 10: Logical NOT A ---");
        A = 8'hAA;              opcode = 4'hA; #10; // Out = 8'h55, Zero = 0

        // Test Case 11: Shift Left Logical
        $display("\n--- Test Case 11: Logical Shift Left (A << 1) ---");
        A = 8'b10010110;        opcode = 4'hB; #10; // Out = 8'b00101100, Carry = 1, Zero = 0
        A = 8'b00110011;        opcode = 4'hB; #10; // Out = 8'b01100110, Carry = 0, Zero = 0

        // Test Case 12: Shift Right Logical
        $display("\n--- Test Case 12: Logical Shift Right (A >> 1) ---");
        A = 8'b10010111;        opcode = 4'hC; #10; // Out = 8'b01001011, Carry = 1, Zero = 0
        A = 8'b01100110;        opcode = 4'hC; #10; // Out = 8'b00110011, Carry = 0, Zero = 0

        // Test Case 13: Rotate Left
        $display("\n--- Test Case 13: Rotate Left (A ROL 1) ---");
        A = 8'b10000001;        opcode = 4'hD; #10; // Out = 8'b00000011, Carry = 0, Zero = 0

        // Test Case 14: Rotate Right
        $display("\n--- Test Case 14: Rotate Right (A ROR 1) ---");
        A = 8'b10000001;        opcode = 4'hE; #10; // Out = 8'b11000000, Carry = 0, Zero = 0

        // Test Case 15: Compare (A == B)
        $display("\n--- Test Case 15: Compare (A == B) ---");
        A = 8'd22;  B = 8'd22;  opcode = 4'hF; #10; // Out = 8'hFF, Zero = 0
        A = 8'd22;  B = 8'd33;  opcode = 4'hF; #10; // Out = 8'h00, Zero = 1

        $display("\n--- Simulation Complete ---");
        $finish;
    end

    // Monitor ALU operations
    initial begin
        $monitor("Time=%0t ns | Op=%h | A=%d (Hex:%h) | B=%d (Hex:%h) | Out=%d (Hex:%h) | Carry=%b | Zero=%b", 
                 $time, opcode, A, A, B, B, alu_out, alu_out, carry_out, zero);
    end

endmodule
