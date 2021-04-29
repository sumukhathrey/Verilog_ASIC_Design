`timescale 1ns/1ns

module test_RegisterFile();
    
    reg CLK, RST;
  
  always #1 CLK = ~CLK;
    reg W_EN;
  reg [0:63] W_DATA;
  reg [0:4] W_ADDR, R_ADDR1, R_ADDR2;
  reg [0:63] R_DATA1, R_DATA2;
  reg [0:7] W_MASK;
    integer i;
    
    RegisterFile  REG1 (.CLK(CLK),
                        .RST(RST),
                        .RegWrite(W_EN),
                        .W_ADDR(W_ADDR),
                        .W_DATA(W_DATA),
                        .R_ADDR1(R_ADDR1),
                        .R_ADDR2(R_ADDR2),
                        .OUT1(R_DATA1),
                        .OUT2(R_DATA2),
                        .W_MASK(W_MASK));
    initial begin
        check_REGISTER;
    end
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end
  
  	task check_REGISTER(); begin
        RST = 1'b1;
        CLK = 1'b0;
        W_EN = 1'b0;
        W_ADDR = 5'b0;
        R_ADDR1 = 5'b0;
        R_ADDR2 = 5'b0;
        W_DATA = 64'h0;
      	W_MASK = 8'hFF;
        
        #4 RST = 1'b0;
        
        #2 W_EN = 1'b1; W_ADDR = 5'h0; W_DATA = 64'hFFFF;
      for (i = 0; i < 32; i=i+1) begin
            #2 W_ADDR = i; W_DATA = i+65536;
        end
        
        #2 W_EN = 1'b0; W_ADDR = 0; W_DATA = 0;
        
        #2
        
      for (i = 0; i < 32; i=i+1) begin
            #2 R_ADDR1 = i; R_ADDR2 = i;
        end
        
        #2 W_EN = 1'b1; W_ADDR = 5; W_DATA = 25; R_ADDR1 = 5; R_ADDR2 = 5;
        
        #2 W_EN = 1'b0; W_ADDR = 0; W_DATA = 0; R_ADDR1 = 4; R_ADDR2 = 4;
        
        #2 R_ADDR1 = 5; R_ADDR2 = 5;
      
        #5 $stop;
        end
    endtask
  

endmodule
  
  
