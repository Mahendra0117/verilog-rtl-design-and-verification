# 8-Bit ALU (RTL Design & Verification)

This repository contains the RTL design (`ALU_8B.v`) and functional testbench (`TB_ALU_8B.v`) for a synchronous-ready 8-bit Arithmetic Logic Unit (ALU) implemented in Verilog HDL.

---

## 📌 Project Overview
An Arithmetic Logic Unit (ALU) is the core combinational block of a Central Processing Unit (CPU) responsible for executing arithmetic, logic, shift, and comparisons. 

This design features:
- A **latch-free purely combinational architecture** using blocking assignments and defensive defaults to prevent synthesis of unintended latches.
- A comprehensive **16-opcode instruction set** supporting arithmetic operations (with safe division), bitwise logic gates, bit shifts, rotates, and comparison checks.
- **Dynamic status flags**: `zero` (detecting when output is zero) and `carry_out` (detecting overflow/borrow from addition/subtraction or shifts).

---

## ⚙️ Design Specifications & Ports

### Opcode Mapping (16 Operations)
| Opcode (Hex) | Operation | Description |
|--------------|-----------|-------------|
| `4'h0`       | `ADD`     | Addition: `A + B` (asserts `carry_out` on overflow) |
| `4'h1`       | `SUB`     | Subtraction: `A - B` (asserts `carry_out` as borrow out) |
| `4'h2`       | `MUL`     | Multiplication: `A * B` (captures lower 8 bits of product) |
| `4'h3`       | `DIV`     | Safe Division: `A / B` (safely returns `0` if `B` is `0` to prevent division-by-zero crashes) |
| `4'h4`       | `AND`     | Bitwise AND: `A & B` |
| `4'h5`       | `OR`      | Bitwise OR: `A \| B` |
| `4'h6`       | `XOR`     | Bitwise XOR: `A ^ B` |
| `4'h7`       | `NAND`    | Bitwise NAND: `~(A & B)` |
| `4'h8`       | `NOR`     | Bitwise NOR: `~(A \| B)` |
| `4'h9`       | `XNOR`    | Bitwise XNOR: `~(A ^ B)` |
| `4'hA`       | `NOT`     | Bitwise NOT A: `~A` |
| `4'hB`       | `LSL`     | Logical Shift Left: `A << 1` (MSB is captured in `carry_out`) |
| `4'hC`       | `LSR`     | Logical Shift Right: `A >> 1` (LSB is captured in `carry_out`) |
| `4'hD`       | `ROL`     | Rotate Left A by 1 bit |
| `4'hE`       | `ROR`     | Rotate Right A by 1 bit |
| `4'hF`       | `COMP`    | Compare: Returns `8'hFF` if `A == B`, else `8'h00` |

### Port List
| Port Name   | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| `A`         | Input     | 8-bit | Operand A input bus |
| `B`         | Input     | 8-bit | Operand B input bus |
| `opcode`    | Input     | 4-bit | Select opcode specifying the ALU operation |
| `alu_out`   | Output    | 8-bit | ALU operation result output bus |
| `carry_out` | Output    | 1-bit | Carry-out / borrow status flag |
| `zero`      | Output    | 1-bit | Zero detector status flag (asserts when `alu_out == 8'd0`) |

---

## 📁 File Structure
```
ALU_8bit_Verilog/
├── ALU_8B.v        # RTL Source Code for the 8-Bit ALU
├── TB_ALU_8B.v     # Behavioral Testbench for Vivado/ModelSim
└── README.md       # Project Documentation (this file)
```

---

## 🔍 Simulation & Verification

The testbench (`TB_ALU_8B`) performs an exhaustive validation of all 16 opcodes by applying diverse test vectors:
1. **Arithmetic Boundaries:** Verifies addition overflow (generating carry-out), subtraction borrow detection, and correct truncation of multiplier output.
2. **Safe Division Check:** Feeds divisor `B = 8'd0` during opcode `4'h3` to ensure that division-by-zero protection returns `0` cleanly and does not cause a simulator crash.
3. **Bitwise Logic Gates:** Drives operands to check operations from `AND` up to `XNOR`.
4. **Shifts & Rotations:** Verifies correct bit alignment and carry capturing for Logical Shift Left/Right and Circular Rotate Left/Right operations.
5. **Comparison:** Verifies output returns `8'hFF` when inputs match, and `8'h00` otherwise.

### Running the Simulation
You can run this project in any standard Verilog simulator (e.g., Xilinx Vivado, ModelSim, QuestaSim, or Icarus Verilog).

#### Command Line (Icarus Verilog Example)
```bash
# Compile design and testbench
iverilog -o alu_sim ALU_8B.v TB_ALU_8B.v

# Run simulation
vvp alu_sim
```
