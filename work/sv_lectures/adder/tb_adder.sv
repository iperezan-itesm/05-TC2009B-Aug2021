import adder_pkg::*;
module tb_adder;

logic [3:0] a;
logic [3:0] b;
logic [3:0] s;
logic       c_out;

adder dut_adder(.a(a),
                .b(b),
                .s(s),
                .c_out(c_out)
               );

initial begin
  a = 5;
  b = 1;
  #10ns;

  a = 7;
  b = 0;
  #10ns;

  a = 10;
  b = 10;
  #10ns;

  a = 12;
  b = 3;
  #10ns;
end

endmodule:tb_adder;
