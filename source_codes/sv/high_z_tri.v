/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module high_z_tri (in1,in2,in3,out1);              // same as high_z_oc.v
    input  in1, in2, in3;                          // three input signals
    output out1;                                   // one output signal
    tri    out1;                                   // tri
    assign out1 = in1 ? 0 : 1'bz;                  // tri-state signal
    assign out1 = in2 ? 0 : 1'bz;                  // can be assigned
    assign out1 = in3 ? 0 : 1'bz;                  // multiple times
endmodule
