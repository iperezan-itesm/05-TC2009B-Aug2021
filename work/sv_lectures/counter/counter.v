module counter #(parameter N_BITS= 4)
                (input wire clk,
                 input wire n_reset,
                 input wire up,
                 output reg [N_BITS-1:0] count
                );


always @ (posedge clk or negedge n_reset)begin
  if(!n_reset)begin
    count <= 4'b0;
  end else begin
    if(up) begin
      count <= count + 1'b1;
    end else begin
      count <= count - 1'b1;
    end
  end
end

endmodule
