/* Testbench for divide_clk_by_2 */
// Simulation step
`timescale 1ns/100ps

// Testbench modules do not have I/O ports
module tb_divide_clk_by_2;

// Glue logic
logic clk;
logic asyn_n_rst;
logic clk_div2;

// Generate a clock signal with period of 10ns
always begin:clock
    clk = 1'b1; #5; // 5ns
    clk = 1'b0; #5; // 5ns
end

// Generate a reset pulse
initial begin:reset
    asyn_n_rst = 1'b1;
    #13 // 13 ns
    asyn_n_rst = 1'b0;
    #10 // 10 ns
    asyn_n_rst = 1'b1;
end

// Instantiate design under test
divide_clk_by_2 dut_divide_clk_by_2 (.clk(clk),
                                     .asyn_n_rst(asyn_n_rst),
                                     .clk_div2(clk_div2)
                                    );
initial begin
  repeat(100)
    @(posedge clk)begin
      // Do nothing
    end
  $stop;
end
endmodule:tb_divide_clk_by_2
