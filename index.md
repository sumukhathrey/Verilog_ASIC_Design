
# Verilog


[Click here](https://www.chipverify.com/verilog/verilog-tutorial) to visit website with extensive documentation of verilog

[Click here](http://www.eng.auburn.edu/~nelsovp/courses/elec4200/VHDL/Verilog_Overview_4200.pdf) to visit an exceptional compilation of basic verilog for ASIC design

---

## Contents

- [Types of Verilog Modelling](#types-of-verilog-modelling)

- [Verilog Coding Style](#verilog-coding-style)

- [Basic hardware components](#basic-hardware-components)

  |                 |                 |                 |                 |
  | --------------- | --------------- | --------------- | --------------- |
  | [Half adder](#half-adder) | [Full adder](#full-adder) | [Shifter / Rotator](#shifter-rotator) | [Sorting network](#sorting-network) | 
  | [D flip-flop](#d-flip-flop) |[Divide by 2](#divide-by-2) | [Serial in parallel out (SIPO)](#serial-in-parallel-out-sipo) | [Parallel in serial out (PISO)](#parallel-in-serial-out-piso) | 
  | [MOD-N counter](#mod-n-counter) | [Sequence Detector (1010)](#sequence-detector-1010) | [Register File](#register-file) | [Synchronous FIFO](#ynchronous-fifo) |
  | [Synchronous FIFO with odd depth](#synchronous-fifo-with-odd-depth) | [Asynchronous FIFO](#asynchronous-fifo) |  Asynchronous FIFO with odd depth | [Last in first out (LIFO)](#last-in-first-out-lifo) | 
  | [Gray counter](#gray-counter) | [Fibonacci counter](#fibonacci-counter) | [Round robin arbiter](#round-robin-arbiter)


- Pipelined CPU

- Multicycle CPU

- Tomasulo CPU
 
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

### Half adder
### Full adder
### Shifter / Rotator

   [Click here to execute](https://github.com/sumukhathrey/Verilog/tree/main/Shifter_Rotator)
    
### [Sorting network](https://github.com/sumukhathrey/Verilog/tree/main/Sorting_Network)
### D flip flop
### [Divide by 2](https://github.com/sumukhathrey/Verilog/tree/main/Divide_by_2)
### [Serial in parallel out (SIPO)](https://github.com/sumukhathrey/Verilog/tree/main/SIPO)

  Typically in a Serial in Parallel out circuit, there are as many flops as the size of the parallel out. The input data is shifted in with clk and when all the data bits are available, the serially loaded data is read through the parallel port.
  
  Here, say we have 8-bit parallel port, so it takes 8 clk cycles to serially load 8-bits of data and the data is available for 1 clock cycle and then new data starts coming in resulting in the output being stable for only 1 clock cycle. 
  
  If there is a need to keep the output data stable until we have the next valid data, we need to use a 2-step architecture as shown below. The data is clocked in to the serial registers at the serial_clk then when valid data is loaded, the serial_clk and parallel_clk are asserted together. This way the data loaded into the output registers stay constant until the next valid data is loaded serially.
  
  
### [Parallel in serial out (PISO)](https://github.com/sumukhathrey/Verilog/tree/main/PISO)
### [MOD-N counter](https://github.com/sumukhathrey/Verilog/tree/main/Mod-N_Counter)
### [Sequence Detector (1010)](https://github.com/sumukhathrey/Verilog/tree/main/Sequence_Detector_1010)

  A simple sequence detector can be modelled in several ways -
    1. Non-overlapping - Here, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010001`, i.e. the sequence is detected in a non-overlapping fashion. Once a sequence is detected, the sequence needs to be repeated completely from the start to be dected again.
    2. Overlapping - Again, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010101`, i.e. the sequence is detected in an overlapping fashion. Once a sequence is detected, a new sequence can be detected using a part of the previously detected sequence when applicable.

   Also, the state machine being used to detect the sequence can be mealy or a moore state machine. This will change the total number of states at some cost to the output functional logic
   <img src="https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/SeqDet_1010_Moore_NonOverlap.jpg" width="500" height="800">
   ![Sequence Detector 1010 Moore Non-Overlap](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/SeqDet_1010_Moore_NonOverlap.jpg)
   ![Sequence Detector 1010 Moore Overlap](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/SeqDet_1010_Moore_Overlap.jpg)
   ![Sequence Detector 1010 Mealy Non-Overlap](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/SeqDet_1010_Mealy_NonOverlap.jpg)
   ![Sequence Detector 1010 Mealy Overlap](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/SeqDet_1010_Mealy_Overlap.jpg)
  
   The sequence can also be detected using a simple n-bit shift register, where "n" represents the length of the sequence to be detected (in this case 4) and a comparator can be used to check the state of these n-bit registers. However, consider a sequence which has 20 bits, then we will need a 20 bit shift register which happens to be extremely costly in terms of area. The same can be acheived using a state machine with just 5 flip-flops and some additional combinational logic.

### [Register File](https://github.com/sumukhathrey/Verilog/tree/main/Register_File)
### [Synchronous FIFO](https://github.com/sumukhathrey/Verilog/tree/main/Synchronous_FIFO)

   [![N_Solid](https://github.com/sumukhathrey/Verilog/blob/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/KpjL)

### [Synchronous FIFO with odd depth](https://github.com/sumukhathrey/Verilog/tree/main/Synchronous_FIFO_odd_depth)
### [Asynchronous FIFO](https://github.com/sumukhathrey/Verilog/tree/main/Asynchronous_FIFO)
### Asynchronous FIFO with odd depth
### [Last in first out (LIFO)](https://github.com/sumukhathrey/Verilog/tree/main/LIFO)
### [Gray counter](https://github.com/sumukhathrey/Verilog/tree/main/Gray_Counter)
### [Fibonacci counter](https://github.com/sumukhathrey/Verilog/tree/main/Fibonacci)
### [Round robin arbiter](https://github.com/sumukhathrey/Verilog/tree/main/Round_Robin_Arbiter)




Website Version: 1.08.005
