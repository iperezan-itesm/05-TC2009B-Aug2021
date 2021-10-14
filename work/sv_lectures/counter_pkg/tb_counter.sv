`timescale 1ns/100ps

import counter_pkg::*;

module tb_counter;

//localparam  N_BITS = 8;
// Declare internal signal (glue logic)
logic       clk;
logic       asyn_n_rst; // asynchronous active-low reset
logic       ripple;
logic [N_BITS-1:0] count; // 3bit - 0 to 7

// Instantiate DUT
counter   #(.N_BITS(N_BITS))
dut_counter(.clk(clk),
                    .asyn_n_rst(asyn_n_rst),
                    .ripple(ripple),
                    .count(count)
                    );

// Drive values to our signals
always begin // Tclk = 10 ns
  clk = 1'b0;
  #5; // 5 ns
  clk = 1'b1;
  #5; // 5 ns
end
// Reset
initial begin
  asyn_n_rst = 1'b1;
  #13;
  asyn_n_rst = 1'b0;
  #13;
  asyn_n_rst = 1'b1;
end





endmodule
