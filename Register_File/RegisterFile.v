module RegisterFile ( input CLK, RST, RegWrite,
                     input [0:63] W_DATA,
                     input [0:4] R_ADDR1, R_ADDR2, W_ADDR,
                     input [0:7] W_MASK,
                     output [0:63] OUT1,OUT2);
    
  reg [0:63] REGISTER [0:32];
    
    integer i;
    
    always @(posedge CLK) begin
        if (RST) begin
          for(i = 0; i < 32; i=i+1) begin
                REGISTER[i] <= 64'h0;
            end
        end
      else if (RegWrite & W_ADDR != 5'd0)
        for (i = 0; i < 8 ; i= i+1) begin
          REGISTER[W_ADDR][8*i+:8] <= W_MASK[i] == 1'b1 ? W_DATA[8*i+:8] : REGISTER[W_ADDR][8*i+:8];
        end
    end
    
  assign OUT1 = (RegWrite & (W_ADDR == R_ADDR1) & (W_ADDR != 5'd0)) ? W_DATA : REGISTER[R_ADDR1];
  assign OUT2 = (RegWrite & (W_ADDR == R_ADDR2) & (W_ADDR != 5'd0)) ? W_DATA : REGISTER[R_ADDR2];
    
endmodule
