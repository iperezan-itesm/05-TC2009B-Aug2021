import traffic_light_pkg::*;

module traffic_light (input logic clk,
                      input logic asyn_n_reset,
                      output trafic_light_t tf
                     );

//trafic_light_t tf, next_tf;

trafic_light_t next_tf;


always_ff@(posedge clk, negedge asyn_n_reset)begin
  if(!asyn_n_reset)
    tf <= GREEN;
  else
    tf <= next_tf;
end

always_comb begin
  case(tf)
    GREEN: next_tf = YELLOW;
    YELLOW: next_tf = RED;
    RED: next_tf = GREEN;
    default: next_tf = GREEN;
  endcase
end
endmodule
