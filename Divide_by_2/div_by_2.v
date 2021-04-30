module div_by_2(input clk, rst,
                output div);
  
  reg Q;
  
  always @ (posedge clk) begin
    if (rst)
      Q <= 1'b0;
    else
      Q <= ~Q;
  end
  
  assign div = Q;
  
endmodule
