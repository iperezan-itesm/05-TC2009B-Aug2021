// Timescale for defining simulation step and precision
`timescale 1ns/100ps
// Import ALU package
import alu_pkg::*;

// Testbenches do not have in/out ports
module tb_alu;

// Parameter for defining bit widths
localparam DATA_WIDTH = 4;
// Maximum and minimum possible values
localparam MAX_VALUE =  (1<<(DATA_WIDTH-1)) - 1;
localparam MIN_VALUE = -(1<<(DATA_WIDTH-1));

// Glue logic signals for connecting stimuli and DUT
logic    signed [DATA_WIDTH-1:0]      a;
logic    signed [DATA_WIDTH-1:0]      b;
alu_op_t                             op;
logic    signed [DATA_WIDTH-1:0] result;
logic                                 z;
logic                                 n;
logic                                 v;
logic                                 c;

// DUT instantiation
// Connect all testbench signals to DUT ports
alu #(.DATA_WIDTH(DATA_WIDTH))
dut_alu(.a(a),
        .b(b),
        .op(op),
        .result(result),
        .z(z),
        .n(n),
        .v(v),
        .c(c)
       );

// Generate stimuli
initial begin
  repeat(100) begin
    a = $random;
    b = $random;
    op = alu_op_t'($random);
    #1;
  end
  $stop;
end

// Signal for
logic signed [DATA_WIDTH:0] result_tb;

always@(a,b,op)begin
  case(op)
    ALU_ADD: result_tb = a + b;
    ALU_SUB: result_tb = a - b;
    ALU_AND: result_tb = a & b;
    ALU_OR:  result_tb = a | b;
    default: result_tb = 0;
  endcase

// Small delay for comparing DUT results with testbench results
  #0.5;
  assert (result == result_tb[DATA_WIDTH-1:0])                     else $error("ERROR: Result");
  assert (n == (result_tb[DATA_WIDTH-1]))                          else $error("ERROR: N Flag");
  assert (z == (result_tb[DATA_WIDTH-1:0] == 0))                   else $error("ERROR: Z flag");

  if(op == ALU_ADD || op == ALU_SUB)begin
    assert (v == (result_tb > MAX_VALUE || result_tb < MIN_VALUE)) else $error("ERROR: V flag");
    assert (c == result_tb[DATA_WIDTH])                            else $error("ERROR: C flag");
  end else begin
    assert (v == 1'b0)                                             else $error("ERROR: V flag");
    assert (c == 1'b0)                                             else $error("ERROR: C flag");
  end
end

endmodule
