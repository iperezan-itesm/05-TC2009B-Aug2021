/* Testbench for divide_clk_by_2 */
// Simulation step
`timescale 1ns/100ps

// Testbench modules do not have I/O ports
module tb_divide_clk_by_2;

// Glue logic
logic clk, an_rst, clk_div2;

// Generate a clock signal
always begin
    clk = 1'b1; #1
    clk = 1'b0; #1;
end

// Generate a reset pulse
initial begin
    an_rst = 1'b1; #4
    an_rst = 1'b0; #2
    an_rst = 1'b1;
end

// Instantiate design under test
divide_clk_by_2 dut (.clk(clk), .an_rst(an_rst), .clk_div2(clk_div2));

endmodule
