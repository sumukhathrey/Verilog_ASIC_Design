# Verilog


[Click here](https://www.chipverify.com/verilog/verilog-tutorial) to visit website with extensive documentation of verilog

[Click here](http://www.eng.auburn.edu/~nelsovp/courses/elec4200/VHDL/Verilog_Overview_4200.pdf) to visit an exceptional compilation of basic verilog for ASIC design

---
## Types of Verilog Modelling
Verilog is one of the Hardware Description Language (HDL) used to model the electronics systems at the following abstraction levels:

  1. Register Transfer Level (RTL) - An abstraction level, where the circuits are modelled as the flow of data between registers. This is achieved through always blocks and assign statements. The RTL should be written in a way such that it is completely synthesizable, i.e., can be translated/synthesized to gate level

  2. Behavioral - An abstraction level, which mimics the desired functionality of the hardware but is not necessarily synthesizable. Behavioral verilog is often used to represent analog block, place holder code, testbench code, and most importantly for modelling hardware for behavioral simulation.

  3. Structural - Logic described by gates and modules only. No always blocks or assign statements. This is a representative of the real gates in the hardware. 



---


## Verilog Coding Style

Here, we will try to create exaples of hardware using RTL model and test it using an appropriate testbench. 

The basic structure of code we will follow for hardware modelling the design is as follows:

```verilog
module design_name (input <input_port_names>,
       output <output_port_names>);
       
       //internal registers and wires
       reg <reg_names>;
       wire <wire_names>;
       
       //combinational logic for next-state-logic
       always @ (*) begin
            //Combinational Statements using blocking assignments
       end
       
       //sequential logic for state-memory
       always @ (posedge clk) begin
            //Sequential Statements with non-blocking assignments
            //Reset statement necessary
       end
       
       //combinational logic for output-functional-logic
       assign <output_post_name> = <reg_name/wire_name>;
endmodule
```

The basic structure of code we will follow for creating a testbench to test the design is as follows:

```verilog
module design_name_tb ();
       
       //internal registers and wires
       reg <reg_names>;     // All design inputs should be registers
       wire <wire_names>;   // All design outputs can be wires
       
       //initialize the design
       design_name <instant_name> (.input_port_names(reg_names), .output_port_names(wire_names));
       
       //If the design has clock, create a clock (here clock period = 2ns)
       always #1 clk = ~clk 
       
       //test vectors input
       initial begin
              // initialize all inputs to initial values
              
              // write the input vectors here
              
              #5 $stop; //terminate the simulation
       end
endmodule
```

---


## Basic hardware components

### - Half adder
### - Full adder
### [Shifter / Rotator](https://github.com/sumukhathrey/Verilog/tree/main/Shifter_Rotator)
### [Sorting network](https://github.com/sumukhathrey/Verilog/tree/main/Sorting_Network)
### D flip flop
### [Divide by 2](https://github.com/sumukhathrey/Verilog/tree/main/Divide_by_2)
### [Serial in parallel out (SIPO)](https://github.com/sumukhathrey/Verilog/tree/main/SIPO)
### [Parallel in serial out (PISO)](https://github.com/sumukhathrey/Verilog/tree/main/PISO)
### [MOD-N counter](https://github.com/sumukhathrey/Verilog/tree/main/Mod-N_Counter)
### [Sequence Detector (1010)](https://github.com/sumukhathrey/Verilog/tree/main/Sequence_Detector_1010)

A simple sequence detector can be modelled in several ways -
  1. Non-overlapping - Here, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010001`, i.e. the sequence is detected in a non-overlapping fashion. Once a sequence is detected, the sequence needs to be repeated completely from the start to be dected again.
  2. Overlapping - Again, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010101`, i.e. the sequence is detected in an overlapping fashion. Once a sequence is detected, a new sequence can be detected using a part of the previously detected sequence when applicable.

### [Register File](https://github.com/sumukhathrey/Verilog/tree/main/Register_File)
### [Synchronous FIFO](https://github.com/sumukhathrey/Verilog/tree/main/Synchronous_FIFO)
### [Synchronous FIFO with odd depth](https://github.com/sumukhathrey/Verilog/tree/main/Synchronous_FIFO_odd_depth)
### [Asynchronous FIFO](https://github.com/sumukhathrey/Verilog/tree/main/Asynchronous_FIFO)
### Asynchronous FIFO with odd depth
### [Last in first out (LIFO)](https://github.com/sumukhathrey/Verilog/tree/main/LIFO)
### [Gray counter](https://github.com/sumukhathrey/Verilog/tree/main/Gray_Counter)
### [Finonacci counter](https://github.com/sumukhathrey/Verilog/tree/main/Fibonacci)
### [Round robin arbiter](https://github.com/sumukhathrey/Verilog/tree/main/Round_Robin_Arbiter)



