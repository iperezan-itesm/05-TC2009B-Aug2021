/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module high_z_oc (in1,in2,in3,out1);               // test open drain buffer
    input  in1, in2, in3;                          // three input signals
    output out1;                                   // one output signal
    wire   not_out1, not_out2, not_out3;
    not   not1 (not_out1, in1);                    // regular not gate
    not   not2 (not_out2, in2);
    not   not3 (not_out3, in3);
    opndrn oc1 (.in(not_out1), .out(out1));        // opndrn is an 
    opndrn oc2 (.in(not_out2), .out(out1));        // open-drain
    opndrn oc3 (.in(not_out3), .out(out1));        // buffer
endmodule
