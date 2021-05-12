
# Contents

- [Types of Verilog Modelling](#types-of-verilog-modelling)

- [Verilog Coding Style](#verilog-coding-style)

- [Latches in Verilog](#latches-in-verilog)

- [Basic hardware components](#basic-hardware-components)

	| [Adders](#adders) | [Shifter and Rotator](#shifter-and-rotator) | [Multiplier](#multiplier) |
	| ------- | ------- | ------- |
	| [Divider](#divider) | [Sorting network](#sorting-network) | [D flip-flop](#d-flip-flop) | 
	| [Serial in parallel out (SIPO)](#serial-in-parallel-out-sipo) | [Parallel in serial out (PISO)](#parallel-in-serial-out-piso) | [Counters](#counters) | 
	| [MOD-N counters](#mod-n-counters) | [Gray counter](#gray-counter) | [Fibonacci counter](#fibonacci-counter) | 
	| [Frequency Dividers](#frequency-dividers) | [Linear feedback shift register (LFSR)](#linear-feedback-shift-register-LFSR) | [Sequence Detector](#sequence-detector) |
	| [Register File](#register-file) | [First-in-first-out (FIFO)](#first-in-first-out-fifo) | [Last-in-first-out (LIFO)](#last-in-first-out-lifo) |
	| [Round robin arbiter](#round-robin-arbiter) |  |  |

- Single-cycle CPU

- Multi-cycle CPU

- Pipelined CPU

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

## Adders

### Half adder

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
   

### Full adder

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

## Shifter and Rotator

   ![shifter](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Shifter_Rotator/right_shifter.png)
   
   ![shifter_lr](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Shifter_Rotator/right_left_shifter.png)
   
   ![rotator](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Shifter_Rotator/right_rotator.png)
   
   ![rotator_lr](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Shifter_Rotator/right_left_rotator.png)
   
   ![rotator_shifter](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Shifter_Rotator/shifter_rotator.png)


   Additional information can be found at [Design alternatives for barrel shifters](https://www.princeton.edu/~rblee/ELE572Papers/Fall04Readings/Shifter_Schulte.pdf)
   
[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Multiplier

## Divider
    
## Sorting network
	
   Sorting is a very important task generally performed through software, however, in hing sorting demand operations such as artificial intelligence and databases it becomes a necessity to implement sorting through hardware to speedup the process. This is implemented in hardware through a basic building block called ***compare and swap (CAS)*** block. The CAS block is connected in a certain way called bitonic network to sort the given set of numbers.

   ![sorting_networks_cas_blocks](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sorting_Network/cas_block.png)
   
   Figure 1: Compare and Swap Block
   
   The CAS block has two inputs, ***A*** and ***B*** and has two outputs ***O1 = max(A,B)*** and ***O2 = min(A,B)***. A CAS block is made up of an n-bit comparator, two n-bit multiplexers to select from inputs A and B where n-bit is the data width of A and B. There can be two configurations of the CAS block to sort the numbers in an ascending or descending order.
   
   To differentiate between the ascending and decending order CAS blocks, we use arrows to depict the type of sort. The arrow-head indicates port with ***max*** output and the arrow-root indicates the port with the ***min*** output.
   
```verilog
module comapre_and_swap(input [3:0] data1, data2,
                        output [3:0] max, min);
  
  // Comparator output declaration
  wire data1_greater_than_data2;
  
  // Comparator output = 1 if data1 > data2
  // Comparator output = 0 if data1 <= data2
  assign data1_greater_than_data2 = data1 > data2;
  
  // max data 
  assign max = (data1_greater_than_data2 == 1'b1) ? data1 : data2;
  
  // min data 
  assign min = (data1_greater_than_data2 == 1'b1) ? data2 : data1;
  
endmodule
```

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
   
```verilog
module sort_network_8x4 (input [3:0] data_in [0:7],
                         output [3:0] data_sort [0:7]);
  
  // wire declarations for all the sorting intermediaries
  wire [3:0] stage1 [0:7];
  
  wire [3:0] stage2_0 [0:7];
  wire [3:0] stage2_1 [0:7];
  
  wire [3:0] stage3_0 [0:7];
  wire [3:0] stage3_1 [0:7];
  wire [3:0] stage3_2 [0:7];
  
  
  //------------------------------------------------------------------------
  // Stage 0 has only one level of sorting
  //------------------------------------------------------------------------
  comapre_and_swap u1 (data_in[0], data_in[1], stage1[1], stage1[0]);
  comapre_and_swap u2 (data_in[2], data_in[3], stage1[2], stage1[3]);
  comapre_and_swap u3 (data_in[4], data_in[5], stage1[5], stage1[4]);
  comapre_and_swap u4 (data_in[6], data_in[7], stage1[6], stage1[7]);
  
  //------------------------------------------------------------------------
  //Stage 1 has 2 levels of sorting
  //------------------------------------------------------------------------
  comapre_and_swap u5 (stage1[0], stage1[2], stage2_0[2], stage2_0[0]);
  comapre_and_swap u6 (stage1[1], stage1[3], stage2_0[3], stage2_0[1]);
  comapre_and_swap u7 (stage1[4], stage1[6], stage2_0[4], stage2_0[6]);
  comapre_and_swap u8 (stage1[5], stage1[7], stage2_0[5], stage2_0[7]);
  
  comapre_and_swap u9 (stage2_0[0], stage2_0[2], stage2_1[2], stage2_1[0]);
  comapre_and_swap u10 (stage2_0[1], stage2_0[3], stage2_1[3], stage2_1[1]);
  comapre_and_swap u11 (stage2_0[4], stage2_0[6], stage2_1[4], stage2_1[6]);
  comapre_and_swap u12 (stage2_0[5], stage2_0[7], stage2_1[5], stage2_1[7]);
  
  //------------------------------------------------------------------------
  // Stage 2 has 3 levels of sorting
  //------------------------------------------------------------------------
  comapre_and_swap u13 (stage2_1[0], stage2_1[4], stage3_0[4], stage3_0[0]);
  comapre_and_swap u14 (stage2_1[1], stage2_1[5], stage3_0[5], stage3_0[1]);
  comapre_and_swap u15 (stage2_1[2], stage2_1[6], stage3_0[6], stage3_0[2]);
  comapre_and_swap u16 (stage2_1[3], stage2_1[7], stage3_0[7], stage3_0[3]);
  
  comapre_and_swap u17 (stage3_0[0], stage3_0[2], stage3_1[2], stage3_1[0]);
  comapre_and_swap u18 (stage3_0[1], stage3_0[3], stage3_1[3], stage3_1[1]);
  comapre_and_swap u19 (stage3_0[4], stage3_0[6], stage3_1[6], stage3_1[4]);
  comapre_and_swap u20 (stage3_0[5], stage3_0[7], stage3_1[7], stage3_1[5]);
  
  comapre_and_swap u21 (stage3_1[0], stage3_1[1], stage3_2[1], stage3_2[0]);
  comapre_and_swap u22 (stage3_1[2], stage3_1[3], stage3_2[3], stage3_2[2]);
  comapre_and_swap u23 (stage3_1[4], stage3_1[5], stage3_2[5], stage3_2[4]);
  comapre_and_swap u24 (stage3_1[6], stage3_1[7], stage3_2[7], stage3_2[6]);
  
  // Sorted data is assigned to output
  assign data_sort = stage3_2;
  
endmodule
```

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/9JEa)

   The information found here was referred from an outstanding paper [Low-Cost Sorting Network Circuits Using Unary Processing](https://ieeexplore.ieee.org/document/8338366)
   
   Additional information about sorting networks can be found [here](http://staff.ustc.edu.cn/~csli/graduate/algorithms/book6/chap28.htm) and [here](http://www.cs.kent.edu/~batcher/sort.pdf)
   
   
[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)
   
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

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Serial in parallel out (SIPO)

  Typically in a Serial in Parallel out circuit, there are as many flops as the size of the parallel out. The input data is shifted in with clk and when all the data bits are available, the serially loaded data is read through the parallel port.
  
  Here, say we have 8-bit parallel port, so it takes 8 clk cycles to serially load 8-bits of data and the data is available for 1 clock cycle and then new data starts coming in resulting in the output being stable for only 1 clock cycle. 
  
  ![sipo_basic](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/SIPO/sipo_basic.png)
  
  Figure 1: Basic serial-in-parallel-out circuit
  
```verilog
module sipo_1 (input load, clk, rst,
               input data_in,
               output [7:0] data_out);
  
  // SIPO register array to read and shift data
  reg [7:0] data_reg;
  
  always @ (posedge clk or negedge rst) begin
    if (~rst)
      data_reg <= 8'h00; // Reset SIPO register on reset
    else if (load)
      data_reg <= {data_in, data_reg[7:1]}; // Load data to the SIPO register by right shifts
  end
  
  // Assign the SIPO register data to data_out wires
  assign data_out = data_reg;
  
endmodule
```
  
  If there is a need to keep the output data stable until we have the next valid data, we need to use a 2-step architecture as shown below. The data is clocked in to the serial registers at the serial_clk then when valid data is loaded, the serial_clk and parallel_clk are asserted together. This way the data loaded into the output registers stay constant until the next valid data is loaded serially.
  
  ![sipo_capture_reg](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/SIPO/sipo_capture_reg.png)
  
  Figure 2: Serial-in-parallel-out circuit with capture register
  
```verilog
module sipo_2 (input load, clk, rst,
               input data_in,
               output reg [7:0] data_out);
  
  // SIPO register array to read and shift data
  reg [7:0] data_reg;
  
  always @ (posedge clk or negedge rst) begin
    if (~rst) begin
      data_reg <= 8'h00; // Reset SIPO register on reset
      data_out <= 8'h00; // Reset capture register
    end
    else begin
      if (load)
        data_reg <= {data_in, data_reg[7:1]}; // Load data to the SIPO register by right shifts
      else
        data_out <= data_reg; // Assign SIPO register data to capture register
    end
  end
  
endmodule
```
  
[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)
  
## Parallel in serial out (PISO)

![piso_block](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/PISO/piso_block.png)

![piso_basic](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/PISO/piso.png)

```verilog
module piso (input load, clk, rst,
             input [7:0] data_in,
             output reg data_out);
  
  // PISO register array to load and shift data
  reg [7:0] data_reg;
  
  always @ (posedge clk or negedge rst) begin
    if (~rst)
      data_reg <= 8'h00; // Reset PISO register array on reset
    else begin
      
      // Load the data to the PISO register array and reset the serial data out register
      if (load)
      	{data_reg, data_out} <= {data_in, 1'b0};
      // Shift the loaded data 1 bit right; into the serial data out register
      else
      	{data_reg, data_out} <= {1'b0, data_reg[7:0]};
    end
  end
  
endmodule
```

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Counters

### Synchronous counter

### Asynchronous/Ripple counter

### Ring counter

### Johnson counter

### Sequence counter

## MOD-N Counters

### MOD-3 counter

### MOD-5 counter

### MOD-6 counter

### MOD-7 counter

### MOD-8 counter

### MOD-9 counter

### MOD-11 counter

### MOD-12 counter

## Gray counter

The gray code is a type of binary number ordering such that each number differes from its previous and the following number by exactly 1-bit. Gray codes are used in cases when the binary numbers transmitted by a digital system may result in a fault or ambuiguity or for implementing error corrections.

The most simple implementation of a gray code counter will be a binary counter followed by a ***binary to gray*** converter. However, the datapath is huge resulting in a very low clock frequency. This is a good motive to pursue a design to implement a gray counter with a smaller datapath.

Consider a 4-bit gray code `gray[3:0]` in the following table.

![gray_code_table](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Gray_Counter/gray_code_table.png)

The ***count*** column gives the decimal value for the corrseponding gray code, ***gray[3:0]*** represent the binary encoded gray code, and ***gray[-1]*** is a place-holder and used to actually implement the gray code counter.

From the table the following observations can be made - 
1. ***gray[-1]*** flips every clock cycle, and is preset to `1'b1`
2. ***gray[0]*** flips everytime `gray[-1] == 1`
3. ***gray[1]*** flips everytime `(gray[0] == 1) & (gray[-1] == 0)`
4. ***gray[2]*** flips everytime `(gray[1] == 1) & (gray[0] == 0) & (gray[-1] == 0)`
5. ***gray[3]*** flips twice for a cycle which means we need additional condition to account for this. It flips when and `(gray[3] == 1) or (gray[2] == 0)` and `(gray[1] == 0) & (gray[0] == 0) & (gray[-1] == 0)`

The ***red arrow*** in the table shows the bit getting flipped and the highlighed bits show the condition for the flip.

The same has been shown here in the following circuit. ***gray[3:-1]*** is represented by the flip-flops and the logic when these flip make up the combinational logic.

![gray_counter_circuit1](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Gray_Counter/gray_counter.png)

```verilog
module gray_counter(input clk, rst,
                    output [3:0] gray_count);
  
  // D flip flops to store the gray count and the placeholder value
  reg [3:-1] q;
  
  // register declaration for combinational logic
  reg all_zeros_below[2:-1];
  
  // Combinational logic to compute if the value below any bit of the gray count is 0
  always @ (*) begin
    all_zeros_below[-1] = 1;
    for (integer i = 0; i<3; i= i+1) begin
      all_zeros_below[i] = all_zeros_below[i-1] & ~q[i-1];
    end
  end
  
  always @ (posedge clk) begin
    if (rst) q[3:-1] <= 5'b0000_1;
    
    else begin
      // The placegolder value toggles every clock
      q[-1] <= ~q[-1];
      
      // The bits [n-1:0] toggle everytime the sequence below it is 1 followed by all zeros (1000...)
      for (integer i = 0; i<3; i= i+1) begin
        q[i] <= (q[i-1] & all_zeros_below[i-1]) ? ~q[i] : q[i];
      end
      
      // The MSB flips when either the nth/(n-1)th bit is 1 followed by all zeros (X1000... or 1X000...)
      q[3] <= ((q[3] | q[2]) & all_zeros_below[2]) ? ~q[3] : q[3];
    end
  end
  
  // The flip flop value is connected to the gray counter output.
  assign gray_count = q[3:0];
  
endmodule
```

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/Q6Zk)

![gray_counter_wave](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Gray_Counter/gray_counter_wave.png)

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Fibonacci counter

![fibonacci_counter](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Fibonacci/fibonacci_counter.png)

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Frequency Dividers

The frequency dividers can be implemented through the means of counters.

### Divide by 2

The most basic a 1-bit counter also doubles up as a divide-by-2 circuit since for any given clock frequency, the output of the 1 bit counter is 1/2 the frequency of the cock signal. 

A synchronous active-high reset divide-by-2 circuit can be written in verilog as:

```verilog
module div_by_2 (input clk, rst,
                 output clk_out);
  
  // Register to store the current count value
  reg Q;
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 1'b0;	// If reset, set Q to 0
    else
      Q <= ~Q;		// If not reset, set Q to the next count value
  end
  
  // The clk/2 is set when Q == 1
  assign clk_out = Q;
  
endmodule 
```

Synthesized divide-by-2 circuit is as shown below - 

![div_by_2](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_2.png)

### Divide by 3

![div_by_3_waveform](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_3_waveform.png)

```verilog

```

### Divide by 4

![div_by_4](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_4_waveform.png)

```verilog
module div_by_4 (input clk, rst,
                 output clk_out);
  
  // Registers to store the current count value and wire to compute the next count value
  reg [1:0] Q, Q_next;
  
  // Combinational logic to compute the next state logic (count value)
  always @ (*) begin
    case(Q)
      2'b00: Q_next = 2'b01;
      2'b01: Q_next = 2'b10;
      2'b10: Q_next = 2'b11;
      2'b11: Q_next = 2'b00;
      default: Q_next = 2'b00;
    endcase
  end
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 2'h0;	// If reset, set Q to 0
    else
      Q <= Q_next;	// If not reset, set Q to the next count value
  end
  
  // The clk/4 is set when Q[1] == 1
  assign clk_out = Q[1];
  
endmodule
```

### Divide by 5

![div_by_5_table](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_5_table.png)

![div_by_5_waveform](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_5_waveform.png)

```verilog
module div_by_5 (input clk, rst,
                 output clk_out);
  
  // Registers to store the current count value and wire to compute the next count value
  reg [2:0] Q, Q_next;
  
  // Register to delay Q[1] signal by 0.5 clock period
  reg Q_delay_0_5tp;
  
  // Combinational logic to compute the next state logic (count value)
  always @ (*) begin
    if (Q == 3'd4)
      Q_next = 3'h0;	// If counted to 4, set Q to 0
    else
      Q_next = Q + 1; 	// If not counted to 4, set Q to Q + 1
  end
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 3'h0;	// If reset, set Q to 0
    else
      Q <= Q_next;	// If not reset, set Q to the next count value
  end
  
  // Always block to delay Q[1] by 0.5 clock cycle
  always @ (negedge clk) begin
    if (rst)
      Q_delay_0_5tp <= 1'b0;
    else
      Q_delay_0_5tp <= Q[1];
  end
  
  // The clk/5 is set when Q[1]_delayed_by_0.5_cycle == 1 or Q[2] == 1
  assign clk_out = Q_delay_0_5tp | Q[2];
  
endmodule
```

### Divide by 6

![div_by_6_table](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_6_table.png)

![div_by_6_waveform](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_6_waveform.png)

```verilog
module div_by_6 (input clk, rst,
                 output clk_out);
  
  // Registers to store the current count value and wire to compute the next count value
  reg [2:0] Q, Q_next;
  
  // Registers to delay Q[1] signal by 1 clock period
  reg Q_delay_1tp;
  
  
  // Combinational logic to compute the next state logic (count value)
  always @ (*) begin
    if (Q == 3'd5)
      Q_next = 3'h0;	// If counted to 5, set Q to 0
    else
      Q_next = Q + 1; 	// If not counted to 5, set Q to Q + 1
  end
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 3'h0;	// If reset, set Q to 0
    else
      Q <= Q_next;	// If not reset, set Q to the next count value
  end
  
  // Always block to delay Q[1] by 1 clock cycle
  always @ (posedge clk) begin
    if (rst) begin
      Q_delay_1tp <= 1'b0;
    end
    else begin
      Q_delay_1tp <= Q[1];
    end
  end
  
  // The clk/6 is set when Q[1]_delayed_by_1_cycle == 1 or Q[2] == 1
  assign clk_out = Q_delay_1tp | Q[2];
  
endmodule
```

### Divide by 9

![div_by_9_table](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_9_table.png)

![div_by_9_waveform](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_9_waveform.png)

```verilog
module div_by_9 (input clk, rst,
                 output clk_out);
  
  // Registers to store the current count value and wire to compute the next count value
  reg [3:0] Q, Q_next;
  
  // Register to delay Q[2] signal by 0.5 clock period
  reg Q_delay_0_5tp;
  
  // Combinational logic to compute the next state logic (count value)
  always @ (*) begin
    if (Q == 4'd8)
      Q_next = 4'h0;	// If counted to 8, set Q to 0
    else
      Q_next = Q + 1; 	// If not counted to 8, set Q to Q + 1
  end
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 4'h0;	// If reset, set Q to 0
    else
      Q <= Q_next;	// If not reset, set Q to the next count value
  end

  
  // Always block to delay Q[2] by 1.5 clock cycle
  always @ (negedge clk) begin
    if (rst)
      Q_delay_0_5tp <= 1'b0;
    else
      Q_delay_0_5tp <= Q[2];
  end
  
  // The clk/9 is set when Q[2]_delayed_by_0.5_cycle == 1 or Q[3] == 1
  assign clk_out = Q_delay_0_5tp | Q[3];
  
endmodule
```

### Divide by 11

![div_by_11_table](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_11_table.png)

![div_by_11_waveform](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_11_waveform.png)

```verilog
module div_by_11 (input clk, rst,
                 output clk_out);
  
  // Registers to store the current count value and wire to compute the next count value
  reg [3:0] Q, Q_next;
  
  // Register to delay Q[2] signal by 1 clock period
  reg Q_delay_1tp;
  
  // Register to delay Q[2] signal by 1.5 clock period
  reg Q_delay_1_5tp;
  
  // Combinational logic to compute the next state logic (count value)
  always @ (*) begin
    if (Q == 4'd10)
      Q_next = 4'h0;	// If counted to 10, set Q to 0
    else
      Q_next = Q + 1; 	// If not counted to 10, set Q to Q + 1
  end
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 4'h0;	// If reset, set Q to 0
    else
      Q <= Q_next;	// If not reset, set Q to the next count value
  end
  
  // Always block to delay Q[2] by 1 clock cycle
  always @ (posedge clk) begin
    if (rst)
      Q_delay_1tp <= 1'b0;
    else
      Q_delay_1tp <= Q[2];
  end
  
  // Always block to delay Q[2] by 1.5 clock cycle
  always @ (negedge clk) begin
    if (rst)
      Q_delay_1_5tp <= 1'b0;
    else
      Q_delay_1_5tp <= Q_delay_1tp;
  end
  
  // The clk/11 is set when Q[2]_delayed_by_1.5_cycle == 1 or Q[3] == 1
  assign clk_out = Q_delay_1_5tp | Q[3];
  
endmodule
```

### Divide by 12

![div_by_12_table](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_12_table.png)

![div_by_12_waveform](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Frequency_Dividers/div_by_12_waveform.png)

```verilog
module div_by_12 (input clk, rst,
                 output clk_out);
  
  // Registers to store the current count value and wire to compute the next count value
  reg [3:0] Q, Q_next;
  
  // Registers to delay Q[2] signal by 2 clock period
  reg Q_delay_1tp, Q_delay_2tp;
  
  
  // Combinational logic to compute the next state logic (count value)
  always @ (*) begin
    if (Q == 4'd11)
      Q_next = 4'h0;	// If counted to 11, set Q to 0
    else
      Q_next = Q + 1; 	// If not counted to 11, set Q to Q + 1
  end
  
  // State memory
  always @ (posedge clk) begin
    if (rst)
      Q <= 4'h0;	// If reset, set Q to 0
    else
      Q <= Q_next;	// If not reset, set Q to the next count value
  end
  
  // Always block to delay Q[2] by 2 clock cycle
  always @ (posedge clk) begin
    if (rst) begin
      Q_delay_1tp <= 1'b0;
      Q_delay_2tp <= 1'b0;
    end
    else begin
      Q_delay_1tp <= Q[2];
      Q_delay_2tp <= Q_delay_1tp;
    end
  end
  
  // The clk/12 is set when Q[2]_delayed_by_2_cycle == 1 or Q[3] == 1
  assign clk_out = Q_delay_2tp | Q[3];
  
endmodule
```

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Linear Feedback Shift Register (LFSR)

## Sequence Detector

  A simple sequence detector can be modelled in several ways -
    1. Non-overlapping - Here, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010001`, i.e. the sequence is detected in a non-overlapping fashion. Once a sequence is detected, the sequence needs to be repeated completely from the start to be dected again.
    2. Overlapping - Again, consider a sequence detector for sequence 1010. For the input sequence `10101010` the output will be `00010101`, i.e. the sequence is detected in an overlapping fashion. Once a sequence is detected, a new sequence can be detected using a part of the previously detected sequence when applicable.

   Also, the state machine being used to detect the sequence can be mealy or a moore state machine. This will change the total number of states at some cost to the output functional logic
   
### Sequence Detector - 1010

   ![seqD_1010](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/seqD_1010.png)
   
   Figure: Sequence Detector 1010 - Moore and Mealy; non-overlapping and overlapping state machines. 
   
```verilog
// Code your design here
module seq_1010(input din, clk, rst,
                output dout);
  
  // Parameterized state values for ease
  parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
  
  // RState memory definition
  reg [2:0] state, next_state;
  
  // Next State Logic - combinational logic to compute the next state based on the current state and input value
  always @ (*) begin
    case (state)
      S0: next_state = din ? S1 : S0;
      S1: next_state = din ? S1 : S2;
      S2: next_state = din ? S3 : S0;
      S3: next_state = din ? S1 : S4;
      S4: next_state = din ? S1 : S0; // This transition for non-overlaping sequence detector (If uncommented, comment the next line)
      //S4: next_state = din ? S3 : S0; // This transition for overlaping sequence detector (If uncommented, comment the previous line)
      default: next_state = S0;
    endcase
  end
  
  // State Memory - Assign the computed next state to the state memory on the clock edge
  always @ (posedge clk) begin
    if (rst) state <= 3'b000;
    else state <= next_state;
  end
  
  // Output functional logic - The states for which the output should be '1'
  assign dout = state == S4;
endmodule
```

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/iK_p)

![moore_1010_wave1](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/moore_1010_non_overlap.png)

Figure: Sequence Detector 1010 - Moore non-overlapping waveform. 


![moore_1010_wave2](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/moore_1010_overlap.png)

Figure: Sequence Detector 1010 - Moore overlapping waveform. 
    
   
```verilog
// Code your design here
module seq_1010(input din, clk, rst,
                output reg dout);
  
  // Parameterized state values for ease
  parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
  
  // RState memory definition
  reg [1:0] state, next_state;
  
  // Next State Logic - combinational logic to compute the next state based on the current state and input value
  always @ (*) begin
    case (state)
      S0: next_state = din ? S1 : S0;
      S1: next_state = din ? S1 : S2;
      S2: next_state = din ? S3 : S0;
      S3: next_state = din ? S1 : S0;// This transition for non-overlaping sequence detector (If uncommented, comment the next line)
      //S3: next_state = din ? S1 : S2; // This transition for overlaping sequence detector (If uncommented, comment the previous line)
      default: next_state = S0;
    endcase
  end
  
  // State Memory - Assign the computed next state to the state memory on the clock edge
  always @ (posedge clk) begin
    if (rst) state <= 2'b00;
    else state <= next_state;
  end
  
  // Output functional logic - The states for which the output should be '1'
  always @ (posedge clk) begin
    if (rst) dout <= 1'b0;
    else begin
      if (~din & (state == S3)) dout <= 1'b1;
      else dout <= 1'b0;
    end
  end
endmodule
```

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/HbJV)

![mealy_1010_wave1](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/mealy_1010_non_overlap.png)

Figure: Sequence Detector 1010 - Mealy non-overlapping waveform. 

![mealy_1010_wave2](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/mealy_1010_overlap.png)

Figure: Sequence Detector 1010 - Mealy overlapping waveform. 

   The sequence can also be detected using a simple n-bit shift register, where "n" represents the length of the sequence to be detected (in this case 4) and a comparator can be used to check the state of these n-bit registers. However, consider a sequence which has 20 bits, then we will need a 20 bit shift register which happens to be extremely costly in terms of area. The same can be acheived using a state machine with just 5 flip-flops and some additional combinational logic.
   
### Sequence Detector - 1001

![seqD_1001](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Sequence_Detector_1010/seqD_1001.png)
   
[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Register File

Register File is a type of memory block (typically used in a CPU), a m-set of storage cells to store data n-bit wide. It is used to hold data and fetch data based on the need. To perform this function, the register has the ***write operation*** to enable writing data to the register locations and ***read operation*** to enable reading the register locations. To write and read data the register file has ***write pointer*** and ***read pointer*** inputs which can be in a binary encoded or one-hot coded fashion. The number of writes and reads that can be performed in a clock cycle decide the number of ***write port*** and ***read ports*** needed in a register file.

The most common use of a register file is in a CPU in which we can perform a write to store the computed data and 2 reads to fetch data operands to operate on in a clock cycle. For this reason, we will design a register file with 1 write port and 2 read ports. 

At the transistor level, register file can be an array of flip flops. However, in larger designs this is costlier and it is implemented through SRAM cells. However, with an SRAM cell array there is additional considerations of read and write cycles.

![register_file](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Register_File/register_file.png)

Figure: Register file with 1 write port and 2 read ports

Register file operations include:
1. ***Register File Read Operation:*** A ***read address*** value is provided on the ***read address port*** to select the register to be read from. The ***read data*** is available immediately through the mux coming out on the ***read data port***.
2. ***Register File Write Operation:*** A ***write address*** value is provided on the ***write address port*** to select the register to which data is to be written and ***write data*** value is provided on the ***write data port*** which is the data to be written to.

```verilog
module RegisterFile ( input clk, srst, reg_write,
                     input [7:0] w_data,
                     input [2:0] r_addr1, r_addr2, w_addr,
                     output [7:0] r_data1, r_data2);
  
  // Register memory array - 8 locations of 8 bits each
  reg [7:0] register [0:7];
  
  integer i;
    
  always @ (posedge clk) begin
    if (srst) begin
      
      // Initialize all registers to value 0
      for(i = 0; i < 8; i=i+1) begin
        register[i] <= 'h0;
      end
    end
    else if (reg_write)
      
      // Write to registers only on condition reg_write
      // On reg_write, write the data to the register address provided on w_addr
      register[w_addr] <= w_data;
    end
  
  // Read data available on 2 read ports based on 2 seperate read addresses
  assign r_data1 = register[r_addr1];
  assign r_data2 = register[r_addr2];
    
endmodule
```

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/hj7Y)

![reg_file_wave](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Register_File/reg_file_wave.png)

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## First-in-first-out (FIFO)

In this day, almost every digital component works on a clock and it is very common that the sub-systems exchange data for computational and operational needs. An intermediary becomes necessary if:
- The data produced and the data consumer operate on different clock frequencies
	- If the data is being produced at a slower speed than the data is being consumed ***(f_write_clk < f_read_clk)*** the data transfer can take place through a single data register followed by asynchronous data synchronization methods (handshake or 2-clock synchronization)
	- If the data is being produced at a higher speed than the data is being consumed ***(f_write_clk > f_read_clk)*** the data transfer needs buffering which can be implemented through an asynchronous FIFO. The depth of the FIFO depends the write and read clock and the maximum data burst length.
- The data producer and the data consumer have a skew between their clocks
	- If the data is being produced at the same speed as the data is being consumed ***(f_write_clk = f_read_clk)*** and there is a skew between the producer and the consumer clock, the data can be transferred through a lock-up latch/register to overcome the skew
- There is a skew between the data production burst and data reception burst
	- If the producer and consumer operate at the same clock but have a large skew between when a burst of data is produced and when the burst of data is consumed. In such scenario, the produced data needs to be buffered and the sequence of transfer needs to be preserved, then a synchronous FIFO can be used. The depth of such FIFO is decided by the maximum burst length


Additional information can be found at [FIFO Architecture, Functions, and Applications](https://www.ti.com/lit/an/scaa042a/scaa042a.pdf)

Additional info on deciding the fifo depth can be found at [CALCULATION OF FIFO DEPTH - MADE EASY](https://hardwaregeeksblog.files.wordpress.com/2016/12/fifodepthcalculationmadeeasy2.pdf)


### Synchronous FIFO

***Synchronous FIFO*** - The type of FIFOs which have common write and read clock are called synchronous FIFO. Synchronous FIFOs are very common in a processor/controller ICs which work on a common system clock. Since all the sub-systems work on the same system clock they can make use of sync-FIFOs with a possible need for skew handling.

![fifo_sync](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Synchronous_FIFO/fifo_sync.png)

```verilog
module fifo(input clk, rst, wen, ren,
            input [7:0] din,
            output full, empty,
            output reg [7:0] dout);
  
  // FIFO memory array - 8 locations of 8 bits each
  reg [7:0] mem [0:7];
  
  // FIFO write and read pointer registers (n+1) bit wide
  reg [3:0] wptr, rptr;
  
  // read enable and write enable qualified signals declaration
  wire wenq, renq;
  
  // Computation of full and empty signals based on the current
  // read and qrite pointers
  assign full = ((wptr ^ rptr) == 4'b1000);
  assign empty = (wptr == rptr);
  
  // read enable qualified and write enable qualified are generated
  // based on the write/read request and full and empty status of FIFO
  assign wenq = ~full & wen;
  assign renq = ~empty & ren;
  
  always @ (posedge clk) begin
    
    if (rst) begin
      // Write and read pointers are initialized to 0
      wptr <= 4'b0000;
      rptr <= 4'b0000;
      
      // FIFO memory is initialized to 0 (not necessary)
      for (integer i = 0; i < 8; i = i + 1)
        mem[i] = 8'h00;
    end
    else begin
      // Write pointer is incremented on valid write request
      // FIFO memory is updated with data for valid write request
      if (wenq) begin
        wptr <= wptr + 1;
        mem[wptr] <= din;
      end
      else begin
        wptr <= wptr;
        mem[wptr] <= mem[wptr[2:0]];
      end
      
      // Read pointer is incremented on valid read request
      if (renq)
        rptr <= rptr + 1;
      else
        rptr <= rptr;
    end
  end

  // Read data port
  assign dout = mem[rptr[2:0]];
  
endmodule
```

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/KpjL)

![fifo_sync_wave](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Synchronous_FIFO/fifo_sync_wave.png)

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

### Synchronous FIFO with odd depth

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/Jmkw)

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)
   
### Asynchronous FIFO

***Asynchronous FIFO*** - The type of FIFOs which have different write and read clock are called asynchronous FIFO. Such FIFO block is typically used when data needs to be transferred across clock-domain-crossing (CDC), where both the producer and the consumer work in different clock domain.

[![Run on EDA](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_run-on-eda-playground.png)](https://www.edaplayground.com/x/fabv)
      
[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

## Last in first out (LIFO)

## Round robin arbiter

[![go_back](https://raw.githubusercontent.com/sumukhathrey/Verilog/main/Docs/Images/button_go_back.png)](#contents)

---

# References


[Click here](https://www.chipverify.com/verilog/verilog-tutorial) to visit website with extensive documentation of verilog

[Click here](http://www.eng.auburn.edu/~nelsovp/courses/elec4200/VHDL/Verilog_Overview_4200.pdf) to visit an exceptional compilation of basic verilog for ASIC design

---

# About and Contact Info

Website Version: 1.08.054
