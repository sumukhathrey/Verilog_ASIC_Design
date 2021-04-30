# Verilog
---
### Types of Verilog Modelling
Verilog is one of the Hardware Description Language (HDL) used to model the electronics systems at the following abstraction levels:

  1. Register Transfer Level (RTL) - An abstraction level, where the circuits are modelled as the flow of data between registers. This is achieved through always blocks and assign statements. The RTL should be written in a way such that it is completely synthesizable, i.e., can be translated/synthesized to gate level

  2. Behavioral - An abstraction level, which mimics the desired functionality of the hardware but is not necessarily synthesizable. Behavioral verilog is often used to represent analog block, place holder code, testbench code, and most importantly for modelling hardware for behavioral simulation.

  3. Structural - Logic described by gates and modules only. No always blocks or assign statements. This is a representative of the real gates in the hardware.
---
