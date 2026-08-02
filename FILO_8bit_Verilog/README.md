# 8-Bit FILO Buffer (RTL Design & Verification)

This repository contains the RTL design (`FILO.v`) and functional testbench (`FILO_TB.v`) for a synchronous 8-bit wide, 16-deep FILO (First-In, Last-Out) stack memory buffer implemented in Verilog HDL.

---

## 📌 Project Overview
A FILO (First-In, Last-Out) buffer, commonly referred to as a **stack**, is a fundamental data structure in digital systems and computer architecture. It is widely used in CPU subroutines, recursion handling, undo operations, and depth-based parsing logic.

This design implements a **Synchronous Stack Controller** with:
- **Parameterizable-ready structure** containing a memory array of 16 entries of 8-bit width.
- **Dynamic status flags** (`empty`, `full`) to track stack status.
- **Robust boundary protection** with `overflow` and `underflow` flags to safeguard against invalid operations (e.g. pushing when full or popping when empty).
- **Simultaneous Push/Pop handling** allowing top-of-stack data bypass/replacement.
- **Status monitoring** using an internal state counter (`count`) representing current occupancy.

---

## ⚙️ Design Specifications & Ports

### Port List
| Port Name  | Direction | Width  | Description |
|------------|-----------|--------|-------------|
| `clk`      | Input     | 1 bit  | System clock signal |
| `rst`      | Input     | 1 bit  | Synchronous active-high reset |
| `push`     | Input     | 1 bit  | Push enable (performs write if stack is not full) |
| `pop`      | Input     | 1 bit  | Pop enable (performs read if stack is not empty) |
| `in`       | Input     | 8-bit  | Data input bus |
| `out`      | Output    | 8-bit  | Data output register |
| `count`    | Output    | 5-bit  | Element counter tracking stack occupancy (0 to 16) |
| `full`     | Output    | 1 bit  | Active-high status flag indicating stack is full |
| `empty`    | Output    | 1 bit  | Active-high status flag indicating stack is empty |
| `overflow` | Output    | 1 bit  | Active-high error flag indicating push-on-full event |
| `underflow`| Output    | 1 bit  | Active-high error flag indicating pop-on-empty event |

### Internal Registers & Control Signals
* `mem`: Memory array of size `[15:0]` containing 8-bit registers.
* `sp` (4-bit): Stack pointer indexing the current top-most occupied register. It is constrained to stay within the range `[0, 15]` to prevent rollover, ensuring high reliability.

---

## 📁 File Structure
```
FILO_8bit_Verilog/
├── FILO.v          # RTL Source Code for the 8-Bit FILO Stack
├── FILO_TB.v       # Functional Testbench for Vivado/ModelSim
└── README.md       # Project Documentation (this file)
```

---

## 🔍 Simulation & Verification

The testbench (`FILO_TB`) validates the design under simulation across multiple scenarios:
1. **Reset Phase:** Initializes all internal registers and state counters.
2. **Sequential Pushes:** Pushes five values (`10, 20, 30, 40, 50`) sequentially.
3. **Sequential Pops:** Pops all five values and verifies they emerge in reverse order: `50, 40, 30, 20, 10` (validating First-In, Last-Out operation).
4. **Full & Overflow Verification:** Pushes 16 elements to fill the stack and verifies the `full` flag. Then attempts a 17th push to verify the `overflow` error flag.
5. **Empty & Underflow Verification:** Pops all 16 elements to verify the `empty` flag, followed by a 17th pop to verify the `underflow` error flag.
6. **Simultaneous Push & Pop on Empty/Full:** Checks edge cases where push and pop are asserted together when empty or full.
7. **Simultaneous Push & Pop (Bypass):** Pushes and pops simultaneously when partially filled to verify that the top element is cleanly replaced by the incoming data in a single cycle.

### Running the Simulation
You can run this project in any standard Verilog simulator (e.g., Xilinx Vivado, ModelSim, QuestaSim, or Icarus Verilog).

#### Command Line (Icarus Verilog Example)
```bash
# Compile design and testbench
iverilog -o filo_sim FILO.v FILO_TB.v

# Run simulation
vvp filo_sim
```
