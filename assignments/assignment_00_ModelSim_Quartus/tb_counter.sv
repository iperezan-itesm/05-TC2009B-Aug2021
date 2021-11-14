// ============================================================================
// INSTRUCTIONS
//   1.- Modify the code in order to instantiate an 8-bit counter.
//       HINT: You only have to modify one line of code.
//   2.- Answer the questions in this file tb_counter.sv and in counter.sv
// ============================================================================

// Q: What does the code in line 10 do?
// A:
`timescale 1ns/100ps

module tb_counter;

localparam DUT_N_BITS = 3;

logic                  clk;
logic                  asyn_n_rst,
logic [DUT_N_BITS-1:0] dut_count;

// Q: What does the code in lines 22 to 27 do?
// A:
always begin
    clk = 1'b0;
    #5
    clk = 1'b1;
    #5;
end

// Q: What does the code in lines 31 to 37 do?
// A:
initial begin
    asyn_n_rst = 1'b1;
    #12;
    asyn_n_rst = 1'b0;
    #10;
    asyn_n_rst = 1'b1;
end

// Q: What does the code in lines 41 to 45 do?
// A:
counter   #(.N_BITS(DUT_N_BITS))
dut_counter(.clk(clk)
            .asyn_n_rst(asyn_n_rst),
            .count(dut_count)
           );
