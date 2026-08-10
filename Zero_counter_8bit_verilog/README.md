# 8-Bit Zero Counter in Verilog

## Overview
This repository contains the RTL design and testbench for a digital logic module that counts the number of zero bits in an 8-bit input vector. The project was implemented using behavioral Verilog and verified via exhaustive simulation.

## Features
- **Synchronous Design**: Operates on the positive edge of the clock.
- **Behavioral Modeling**: Utilizes a `for` loop within an `always` block to iterate through the input bits.
- **Exhaustive Verification**: The testbench sweeps through all 256 possible 8-bit input combinations to ensure 100% functional coverage.

## File Structure
- `Number_of_zeros.v`: The main RTL module containing the counting logic.
- `TB_number_of_zeros.v`: The testbench used to verify the design.

## How it Works
The `Number_of_zeros` module takes an 8-bit input (`in`), a clock signal (`clk`), and an active-high reset (`reset`). On every positive clock edge:
1. If `reset` is high, the 4-bit `count` output is cleared to 0.
2. If `reset` is low, the module loops through the 8 bits of the input. For every bit that evaluates to 0, the `count` is incremented.

## Simulation
The provided testbench instantiates the module, generates a 10ns clock, and applies a reset. It then sequentially applies values from `8'b00000000` to `8'b11111111` (0 to 255) to the input. Simulation waveforms confirm that the 4-bit output accurately tracks the number of zeros for every input combination.

## Technologies Used
- Verilog (Hardware Description Language)
- RTL Simulation / Waveform Viewer
