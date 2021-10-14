`timescale 1ns/1ps

import traffic_light_pkg::*;

module tb_traffic_light;

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

trafic_light_t tf;

trafic_light_t tf_test;

// casting:
//         to_data_type'(from_data_type)
initial begin
  tf_test = RED;
  #10;
  tf_test = trafic_light_t'(2'b01);
  #10;
  tf_test = trafic_light_t'(2'b00);

end

traffic_light
dut_traffic_light (.clk(clk),
                   .asyn_n_reset(asyn_n_reset),
                   .tf(tf)
                  );
endmodule
