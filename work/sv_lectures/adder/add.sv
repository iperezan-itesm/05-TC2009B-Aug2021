module adder (input  logic [3:0] a,
              input  logic [3:0] b,
              output logic [3:0] s,
              output logic       c_out
             );

assign {c_out,s} = a + b;

endmodule:adder
