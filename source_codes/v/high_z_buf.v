/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module high_z_buf (in1,in2,in3,out1);              // same as high_z_oc.v
    input  in1, in2, in3;                          // three input signals
    output out1;                                   // one output signal
    // bufif1 (out,  in, ctl);
    bufif1 i1 (out1, 0,  in1);                     // tri-state buffer:
    bufif1 i2 (out1, 0,  in2);                     // ctl==1: out=in 
    bufif1 i3 (out1, 0,  in3);                     // ctl==0: out=high_z
endmodule
