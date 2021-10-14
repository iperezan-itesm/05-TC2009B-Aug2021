/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module encoder8ep (d,ena,n,g);           // 8-3 priority encoder with enable
    input  [7:0] d;                      // input:   d, 8 bits
    input        ena;                    // input:   enable
    output [2:0] n;                      // outputs: n, log_2 8 = 3 bits
    output       g;                      // output:  g = 1 if d is not 0
    assign       g = ena & |d;           // if there is at least a 1 in d
    assign       n = enc(ena, d);        // call a function enc
    function [2:0] enc;                  // the function enc
        input       e;                   // input of the function
        input [7:0] d;                   // input of the function
        casex ({e,d})                    // cases, x: don't care
            9'b1_1xxxxxxx: enc = 3'd7;   // d[7] has the highest priority
            9'b1_01xxxxxx: enc = 3'd6;   // d[6] is active, ignore d[5:0]
            9'b1_001xxxxx: enc = 3'd5;   // d[5] is active, ignore d[4:0]
            9'b1_0001xxxx: enc = 3'd4;   // d[4] is active, ignore d[3:0]
            9'b1_00001xxx: enc = 3'd3;   // d[3] is active, ignore d[2:0]
            9'b1_000001xx: enc = 3'd2;   // d[2] is active, ignore d[1:0]
            9'b1_0000001x: enc = 3'd1;   // d[1] is active, ignore d[0]
            default:       enc = 3'd0;   // d[0] has the lowest priority
        endcase
    endfunction
endmodule
