
# Contents

- [Types of Verilog Modelling](#types-of-verilog-modelling)

- [Verilog Coding Style](#verilog-coding-style)

- [Latches in Verilog](#latches-in-verilog)

- [Basic hardware components](#basic-hardware-components)

  | [Half adder](#half-adder) | [Full adder](#full-adder) | [Shifter / Rotator](#shifter-rotator) |
  | --------------- | --------------- | --------------- |
  | [Sorting network](#sorting-network) | [D flip-flop](#d-flip-flop) |[Divide by 2](#divide-by-2) | 
  | [Serial in parallel out (SIPO)](#serial-in-parallel-out-sipo) | [Parallel in serial out (PISO)](#parallel-in-serial-out-piso) | [MOD-N counter](#mod-n-counter) | 
  | [Sequence Detector (1010)](#sequence-detector-1010) | [Register File](#register-file) | [Synchronous FIFO](#ynchronous-fifo) |
  | [Synchronous FIFO with odd depth](#synchronous-fifo-with-odd-depth) | [Asynchronous FIFO](#asynchronous-fifo) |  Asynchronous FIFO with odd depth | 
  | [Last in first out (LIFO)](#last-in-first-out-lifo) | [Gray counter](#gray-counter) | [Fibonacci counter](#fibonacci-counter) | 
  | [Round robin arbiter](#round-robin-arbiter) | | |



- Pipelined CPU

- Multicycle CPU

- Tomasulo CPU
 
---

# Types of Verilog Modelling
Verilog is one of the Hardware Description Language (HDL) used to model the electronics systems at the following abstraction levels:

  1. Register Transfer Level (RTL) - An abstraction level, where the circuits are modelled as the flow of data between registers. This is achieved through always blocks and assign statements. The RTL should be written in a way such that it is completely synthesizable, i.e., can be translated/synthesized to gate level

  2. Behavioral - An abstraction level, which mimics the desired functionality of the hardware but is not necessarily synthesizable. Behavioral verilog is often used to represent analog block, place holder code, testbench code, and most importantly for modelling hardware for behavioral simulation.

  3. Structural - Logic described by gates and modules only. No always blocks or assign statements. This is a representative of the real gates in the hardware. 



---


# Verilog Coding Style

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

# Latches in Verilog

The latch is modelled in verilog as 

```verilog
module d_latch (input en, d,
                output q);
    always @ (*) begin
        if (clk)
            q = d;
    end
endmodule
```

However, sometines a latch can be inferred in a verilog code unexpectedly due to incorrect coding practice such as when a combinational logic has undefined states. These can be - 
1. Signal missing in the sensitivity list

    ```verilog
    always @(a or b)
    begin
      out = a + b + c;  // Here, a latch is inferred for c, 
                        // since it is missing from sensitivity list
    end
    ```


2. Coverage not provided for all cases in an if-statement or case-statement

	In the following case , we have a case where q = d for en = 1. However, the tool does not know what to do when en = 0, and infers a latch
   ```verilog
   always @(d or q)    
   begin               
     if (en) q = d;    // Condition missing for en = 0; previous value 	
     	  	      // will be held through latch
   end
   ```
	Similarly, in the following case, if default case is missing in case statement and we don't have coverage for all possible cases, a latch is inferred.
   ```verilog
   always @(d or q)    
   begin               
	    case (d)
	  	  2'b00: q = 0;
	  	  2'b01: q = 1;
	  	  2'b10: q = 1; // default condition missing; latch will be 									  
	  			// inferred for condition d = 2'b11 to hold the
	  			// previous value
	    endcase
   end
   ```
   
 ***Note: Latches are only generated by combinational always blocks, the sequential always block will never generate a latch.***
 
 
---


# Basic hardware components

## Half adder
   The half adder circuit is realized as shown in Figure 1. The block has two inputs ***a*** & ***b***, and two outputs ***sum*** and ***cout***
   
   ![half_adder](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/half_adder.png)
   
   The same can be written in verilog as - 
   
   ```verilog
   module half_adder (input a, b,
   		      output sum, cout);
		assign sum = a ^ b;
		assign cout = a & b;
   endmodule
   ```
   
   ```verilog
   module full_adder (input a, b,
   		      output sum, cout);
		assign {cout, sum} = a + b;
   endmodule
   ```

## Full adder

   The half adder circuit is realized as shown in Figure 1. The block has two inputs ***a***, ***b*** & ***cin***, and two outputs ***sum*** and ***cout***
   
   ![full_adder](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/full_adder.png)
   
   The same can be written in verilog in many different ways- 
   
   ```verilog
   module full_adder (input a, b, cin,
   		      output sum, cout);
		wire x, y, z;
		assign x = a ^ b;
		assign sum = x ^ cin;
		assign y = a & b;
		assign z = x & cin;
		assign cout = y | z;
   endmodule
   ```
   
   ```verilog
   module full_adder (input a, b, cin,
   		      output sum, cout);
		assign {cout, sum} = a + b + cin;
   endmodule
   ```
   
   ```verilog
   module full_adder (input a, b, cin,
   		      output sum, cout);
		assign sum = a ^ b ^ cin;
		assign cout = (a & b) | ((a ^ b) & cin);
   endmodule
   ```

## Shifter / Rotator

   [Click here to execute](https://github.com/sumukhathrey/Verilog/tree/main/Shifter_Rotator)
    
## Sorting network
	
   Sorting is a very important task generally performed through software, however, in hing sorting demand operations such as artificial intelligence and databases it becomes a necessity to implement sorting through hardware to speedup the process. This is implemented in hardware through a basic building block called ***compare and swap (CAS)*** block. The CAS block is connected in a certain way called bitonic network to sort the given set of numbers.

   ![sorting_networks_cas_blocks](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sorting_Network/sorting_network_blocks.png)
   
   Figure 1: Compare and Swap Block
   
   The CAS block has two inputs, ***A*** and ***B*** and has two outputs ***O1 = max(A,B)*** and ***O2 = min(A,B)***. A CAS block is made up of an n-bit comparator, two n-bit multiplexers to select from inputs A and B where n-bit is the data width of A and B. There can be two configurations of the CAS block to sort the numbers in an ascending or descending order.
   
   To differentiate between the ascending and decending order CAS blocks, we use arrows to depict the type of sort. The arrow-head indicates port with ***max*** output and the arrow-root indicates the port with the ***min*** output.
   
   ![sorting_networks_components](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sorting_Network/sorting_network_blocks.png)
   
   Figuren 2: Ascending and descending CAS blocks
   
### Bitonic Sorting Networks
   
   A sorting network is a combination of CAS blocks, where each CAS block takes two inputs and swaps it if required, based on its ascending or descending configuration. ***Bitonic sorting networks*** uses the procedure of ***bitonic merge (BM)***, given two equal size sets of input data, sorted in opposing directions, the BM procedure will create a combined set of sorted data. It recursively merges an ascending and a descending set of size N /2 to make a sorted set of size N. Figure 3 and Figure 4 shows the CAS network for a 4-input and 8-input bitonic sorting network made up of ascending and descending BM units. 
   
   The total number of CAS blocks in any N-input bitonic sorting is N × log2 ( N ) × (log2( N ) + 1)/4. The following table shows the CAS blocks needed for N-input bitonic networks.
   
   | Input data numbers |  8 | 16 | 32 | 256 |
   | ------------------ | -- | -- | -- | --- |
   | CAS blocks needed in sorting network | 24 | 80 | 240 | 4608 | 
   
   ![sorting_networks_4nos](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sorting_Network/sorting_network_4nos.png)
   
   Figure 3: Sorting 4 numbers using CAS blocks in ascending and descending order
   
   ![sorting_networks_8nos](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sorting_Network/sorting_network_8nos.png)
   
   Figure 4: Sorting 8 numbers using CAS blocks in ascending order
   
   The information found here was referred from an outstanding paper [Low-Cost Sorting Network Circuits Using Unary Processing](https://ieeexplore.ieee.org/document/8338366)
   
   Additional information about sorting networks can be found [here](http://staff.ustc.edu.cn/~csli/graduate/algorithms/book6/chap28.htm) and [here](http://www.cs.kent.edu/~batcher/sort.pdf)
   
## D flip flop


![dff](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/dff.png)

Verilog code for D flip-flop with active-high synchronous reset - 

```verilog
module dff (input d, clk, srst,
	    output reg Q); 
    always @ (posedge clk) begin
        if (srst)
            Q <= 1'b0; 
	else 
	    Q <= d; 
    end 
endmodule 
```


Verilog code for D flip-flop with active-low asynchronous reset - 

```verilog
module dff (input D, clk, arst,
	    output reg Q); 
    always @ (posedge clk or negedge arst) begin
        if (~arst)
            Q <= 1'b0; 
	else 
	    Q <= D; 
    end 
endmodule 
```


Verilog code for D flip-flop with active-low asynchronous reset - 

```verilog
module dff (input D, clk, arst, srst
	    output reg Q); 
    always @ (posedge clk or negedge arst) begin
        if (~arst)
            Q <= 1'b0; 
	else if (srst)
	    Q <= 1'b0;
	else 
	    Q <= D; 
    end 
endmodule 
```


## Divide by 2

Synthesized divide by 2 circuit is as shown below - 

![div_by_2](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Divide_by_2/div_by_2.png)


## Serial in parallel out (SIPO)

  Typically in a Serial in Parallel out circuit, there are as many flops as the size of the parallel out. The input data is shifted in with clk and when all the data bits are available, the serially loaded data is read through the parallel port.
  
  Here, say we have 8-bit parallel port, so it takes 8 clk cycles to serially load 8-bits of data and the data is available for 1 clock cycle and then new data starts coming in resulting in the output being stable for only 1 clock cycle. 
  
  ![sipo_basic](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/SIPO/sipo_basic.png)
  
  Figure 1: Basic serial-in-parallel-out circuit
  
  If there is a need to keep the output data stable until we have the next valid data, we need to use a 2-step architecture as shown below. The data is clocked in to the serial registers at the serial_clk then when valid data is loaded, the serial_clk and parallel_clk are asserted together. This way the data loaded into the output registers stay constant until the next valid data is loaded serially.
  
  ![sipo_capture_reg](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/SIPO/sipo_capture_reg.png)
  
  Figure 2: Serial-in-parallel-out circuit with capture register
  
## Parallel in serial out (PISO)
## MOD-N counter
## Sequence Detector (1010)

  A simple sequence detector can be modelled in several ways -
    1. Non-overlapping - Here, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010001`, i.e. the sequence is detected in a non-overlapping fashion. Once a sequence is detected, the sequence needs to be repeated completely from the start to be dected again.
    2. Overlapping - Again, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010101`, i.e. the sequence is detected in an overlapping fashion. Once a sequence is detected, a new sequence can be detected using a part of the previously detected sequence when applicable.

   Also, the state machine being used to detect the sequence can be mealy or a moore state machine. This will change the total number of states at some cost to the output functional logic
   
   
   ![moore_1010](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/moore_1010.png)
   
   Figure: Sequence Detector 1010 - Moore non-overlapping and overlapping state machine. 
   
   
   ![mealy_1010](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/mealy_1010.png)
   
   Figure: Sequence Detector 1010 - Mealy non-overlapping and overlapping state machine.  
   
  
   The sequence can also be detected using a simple n-bit shift register, where "n" represents the length of the sequence to be detected (in this case 4) and a comparator can be used to check the state of these n-bit registers. However, consider a sequence which has 20 bits, then we will need a 20 bit shift register which happens to be extremely costly in terms of area. The same can be acheived using a state machine with just 5 flip-flops and some additional combinational logic.

## Register File


![register_file](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Register_File/register_file.png)

Figure: Register file with 1 write port and 2 read ports

## Synchronous FIFO

   [![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/KpjL)

## Synchronous FIFO with odd depth

   [![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/Jmkw)
   
## Asynchronous FIFO

   [![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/fabv)

## Asynchronous FIFO with odd depth
## Last in first out (LIFO)
## Gray counter
## Fibonacci counter
## Round robin arbiter

---

# References


[Click here](https://www.chipverify.com/verilog/verilog-tutorial) to visit website with extensive documentation of verilog

[Click here](http://www.eng.auburn.edu/~nelsovp/courses/elec4200/VHDL/Verilog_Overview_4200.pdf) to visit an exceptional compilation of basic verilog for ASIC design

---

# About and Contact Info

Website Version: 1.08.054
