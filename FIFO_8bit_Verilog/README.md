# 8-Bit FIFO Buffer (RTL Design & Verification)

This repository contains the RTL design (`FIFO_8bit.v`) and functional testbench (`tb_FIFO.v`) for a synchronous 8-bit wide, 16-deep FIFO (First-In, First-Out) memory buffer implemented in Verilog HDL.

---

## 📌 Project Overview
A FIFO buffer is a critical component in digital systems and System-on-Chip (SoC) architectures, commonly used for clock domain crossing (CDC), rate matching, and data buffering between asynchronous processing blocks. 

This design implements a **Synchronous FIFO Controller** with:
- **Parameterizable-ready structure** containing a memory array of 16 entries of 8-bit width.
- **Synchronous status flags** (`empty`, `full`) generated dynamically from an internal occupancy tracking counter.
- **Simultaneous Read/Write handling** enabling steady-state bypass throughput.
- **Status monitoring** using an internal state counter (`count`) representing current FIFO element count.

---

## ⚙️ Design Specifications & Ports

### Port List
| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `clk`     | Input     | 1 bit | System clock signal |
| `rst`     | Input     | 1 bit | Synchronous active-high reset |
| `wr_en`   | Input     | 1 bit | Write enable (performs write if FIFO is not full) |
| `rd_en`   | Input     | 1 bit | Read enable (performs read if FIFO is not empty) |
| `in`      | Input     | 8-bit | Data input bus |
| `out`     | Output    | 8-bit | Data output register |
| `count`   | Output    | 5-bit | Element counter tracking occupancy |
| `full`    | Output    | 1 bit | Active-high status flag indicating FIFO is full |
| `empty`   | Output    | 1 bit | Active-high status flag indicating FIFO is empty |

### Internal Registers & Control Signals
* `mem`: Memory array of size `[15:0]` containing 8-bit registers.
* `wr_ptr` (4-bit): Write pointer indexing the next write address. Automatically rolls over from `15` to `0` due to natural bit width overflow.
* `rd_ptr` (4-bit): Read pointer indexing the next read address. Automatically rolls over from `15` to `0`.

---

## 📁 File Structure
```
FIFO_8bit_Verilog/
├── FIFO_8bit.v     # RTL Source Code for the 8-Bit FIFO Buffer
├── tb_FIFO.v       # Functional Testbench for Vivado/ModelSim
└── README.md       # Project Documentation (this file)
```

---

## 🔍 Simulation & Verification

The testbench (`tb_FIFO_8bit`) validates the design by performing a series of operations under simulation:
1. **Reset Phase:** Asserting `rst` high to initialize pointers, counters, and registers.
2. **Sequential Writes:** Writing five consecutive values (`10, 20, 30, 40, 50`) to verify memory writing and counter increments.
3. **Sequential Reads:** Reading data out of the FIFO while checking that the outputs match the exact FIFO order (First-In, First-Out).
4. **Single Write:** Validating single-cycle write behaviour.
5. **Simultaneous Read & Write:** Stress-testing concurrent write and read operations to verify bypass stability and steady-state behavior.

### Running the Simulation
You can run this project in any standard Verilog simulator (e.g., Xilinx Vivado, ModelSim, QuestaSim, or Icarus Verilog).

#### Command Line (Icarus Verilog Example)
```bash
# Compile design and testbench
iverilog -o fifo_sim FIFO_8bit.v tb_FIFO.v

# Run simulation
vvp fifo_sim
```

---

## 🚀 Future Improvements
* **Flag Logic Optimization:** Adjusting the `full` flag threshold logic to trigger precisely at occupancy `16` (`5'b10000`) instead of `31` (`5'b11111`) to prevent over-filling beyond memory boundary.
* **Parameterized Width & Depth:** Utilizing parameter declarations for `DATA_WIDTH` and `FIFO_DEPTH` to make the module scalable.
