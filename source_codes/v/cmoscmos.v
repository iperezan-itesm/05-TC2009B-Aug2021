/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cmoscmos (drain, source, n_gate, p_gate);                // cmos gate
    input  source, n_gate, p_gate;
    output drain;
    pmos p1 (drain, source, p_gate);     // pmos name (drain, source, gate);
    nmos n1 (drain, source, n_gate);     // nmos name (drain, source, gate);
endmodule
