`timescale 1ns/1ps

import traffic_light_pkg::*;

module tb_traffic_light ;

logic clk;
logic asyn_n_reset;

always begin
  clk = 0;
  #5;
  clk = 1;
  #5;
end

initial begin
  asyn_n_reset = 1;
  #8;
  asyn_n_reset = 0;
  #8;
  asyn_n_reset = 1;
end

traffic_light_t traffic_light_testbench;
initial begin
  //traffic_light_testbench = 2'b11;
  traffic_light_testbench = traffic_light_t'(2'b10);
end

traffic_light
dut_traffic_light(.clk(clk),
                  .asyn_n_reset(asyn_n_reset)
                );
endmodule
