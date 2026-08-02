`timescale 1ns / 1ps

module FILO(
    input [7:0] in,
    input clk,
    input rst,
    input push,
    input pop,
    output reg [4:0] count = 5'b00000,
    output full,
    output empty,
    output reg overflow = 1'b0,
    output reg underflow = 1'b0,
    output reg [7:0] out = 8'd0
);

    // 16-deep memory array of 8-bit registers
    reg [7:0] mem [15:0];
    
    // 4-bit stack pointer to address the active top of stack (0 to 15)
    reg [3:0] sp = 4'b0000;

    // Dynamic full/empty flag assignments
    assign full  = (count == 5'd16);
    assign empty = (count == 5'd0);

    always @(posedge clk) begin
        if (rst) begin
            count     <= 5'd0;
            sp        <= 4'd0;
            out       <= 8'd0;
            overflow  <= 1'b0;
            underflow <= 1'b0;
        end else begin
            case ({pop, push})
                2'b01: begin // Push operation
                    underflow <= 1'b0;
                    if (full) begin
                        overflow <= 1'b1; // Trigger overflow flag when trying to push to a full stack
                    end else begin
                        overflow <= 1'b0;
                        if (empty) begin
                            mem[0] <= in;
                            sp     <= 4'd0; // Reset pointer to bottom of stack
                        end else begin
                            mem[sp + 1] <= in;
                            sp          <= sp + 1; // Move pointer up
                        end
                        count <= count + 1;
                    end
                end
                
                2'b10: begin // Pop operation
                    overflow <= 1'b0;
                    if (empty) begin
                        underflow <= 1'b1; // Trigger underflow flag when trying to pop from an empty stack
                    end else begin
                        underflow <= 1'b0;
                        out       <= mem[sp]; // Retrieve current top of stack
                        if (count > 5'd1) begin
                            sp <= sp - 1; // Move pointer down
                        end
                        count <= count - 1;
                    end
                end
                
                2'b11: begin // Simultaneous Push and Pop operation
                    if (empty) begin
                        // Pop fails (underflow), push succeeds
                        mem[0]    <= in;
                        sp        <= 4'd0;
                        count     <= 5'd1;
                        overflow  <= 1'b0;
                        underflow <= 1'b1;
                    end else if (full) begin
                        // Push fails (overflow), pop succeeds
                        out       <= mem[sp];
                        sp        <= sp - 1;
                        count     <= count - 1;
                        overflow  <= 1'b1;
                        underflow <= 1'b0;
                    end else begin
                        // Read current top value and write new value to same address. 
                        // Stack depth (count) and stack pointer remain unchanged.
                        out       <= mem[sp];
                        mem[sp]   <= in;
                        overflow  <= 1'b0;
                        underflow <= 1'b0;
                    end
                end
                
                default: begin
                    // Clear transient status flags in idle cycles
                    overflow  <= 1'b0;
                    underflow <= 1'b0;
                end
            endcase
        end
    end

endmodule
