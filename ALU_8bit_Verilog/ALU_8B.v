`timescale 1ns / 1ps

module ALU_8B(
    input [7:0] A,
    input [7:0] B,
    input [3:0] opcode,
    output reg [7:0] alu_out,
    output reg carry_out,
    output zero
);

    // The zero flag is asserted when the output of the ALU is exactly zero
    assign zero = (alu_out == 8'd0);

    always @(*) begin
        // Defensive default assignments to prevent latch synthesis
        alu_out   = 8'd0;
        carry_out = 1'b0;

        case (opcode)
            4'h0: begin // Addition
                {carry_out, alu_out} = A + B;
            end
            4'h1: begin // Subtraction
                {carry_out, alu_out} = A - B;
            end
            4'h2: begin // Multiplication (8-bit output, product LSBs)
                alu_out = A * B;
                carry_out = 1'b0;
            end
            4'h3: begin // Safe Division (Division-by-zero protection)
                if (B != 8'd0) begin
                    alu_out = A / B;
                end else begin
                    alu_out = 8'd0; // Safe return value on division by zero
                end
                carry_out = 1'b0;
            end
            4'h4: begin // Logical AND
                alu_out = A & B;
                carry_out = 1'b0;
            end
            4'h5: begin // Logical OR
                alu_out = A | B;
                carry_out = 1'b0;
            end
            4'h6: begin // Logical XOR
                alu_out = A ^ B;
                carry_out = 1'b0;
            end
            4'h7: begin // Logical NAND
                alu_out = ~(A & B);
                carry_out = 1'b0;
            end
            4'h8: begin // Logical NOR
                alu_out = ~(A | B);
                carry_out = 1'b0;
            end
            4'h9: begin // Logical XNOR
                alu_out = ~(A ^ B);
                carry_out = 1'b0;
            end
            4'hA: begin // Logical NOT A
                alu_out = ~A;
                carry_out = 1'b0;
            end
            4'hB: begin // Logical Shift Left (A << 1)
                {carry_out, alu_out} = {A, 1'b0};
            end
            4'hC: begin // Logical Shift Right (A >> 1)
                alu_out = A >> 1;
                carry_out = A[0]; // The shifted-out bit is captured in carry_out
            end
            4'hD: begin // Rotate Left A by 1
                alu_out = {A[6:0], A[7]};
                carry_out = 1'b0;
            end
            4'hE: begin // Rotate Right A by 1
                alu_out = {A[0], A[7:1]};
                carry_out = 1'b0;
            end
            4'hF: begin // Compare (A == B)
                alu_out = (A == B) ? 8'hFF : 8'h00; // Returns 255 if equal, else 0
                carry_out = 1'b0;
            end
            default: begin
                alu_out   = 8'd0;
                carry_out = 1'b0;
            end
        endcase
    end

endmodule
