module PISO #(parameter N = 8) (input clk, load,
                                input [N-1:0] Din,
                                output Dout);
  
  reg [N-1:0] Q;
  
  always @ (posedge clk) begin
    if (load)
      Q <= Din;
    else
      Q <= {1'b0, Q[N-1:1]};
  end
  
  assign Dout = Q;
  
endmodule
