/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module high_z_nor (in1,in2,in3,out1);              // same as high_z_oc.v
    input  in1, in2, in3;                          // three input signals
    output out1;                                   // one output signal
    assign out1 = (in1 | in2 | in3) ? 0 : 1'bz;    // z: high-impedance
endmodule
