/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module counter_6 (u,clk,clrn,q,a,b,c,d,e,f,g);   // a counter with 7-seg LED
    input        clk, clrn;              // clk, clear (active low)
    input        u;                      // u==1: count up; u==0: count down
    output [2:0] q;                      // 3-bit counter output
    output       a, b, c, d, e, f, g;    // seven-segment LED control
    reg    [2:0] q;                      // register type
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) q <= 0;               // if clrn is asserted, counter=0
        else if (u) q <= (q + 1) % 6;    // if counter up, q++
        else if (q != 0) q <= q - 1;     // else           q--
             else        q <= 3'd5;
    end
    assign {g,f,e,d,c,b,a} = seg7(q);    // call function to get LED control
    function  [6:0] seg7;                // the function, 7-bit return value
        input [2:0] q;                   // input argument
        case (q)                         // cases:
            3'd0 : seg7 = 7'b1000000;    // 0's LED control, 0: light on
            3'd1 : seg7 = 7'b1111001;    // 1's LED control, 1: light off
            3'd2 : seg7 = 7'b0100100;    // 2's LED control
            3'd3 : seg7 = 7'b0110000;    // 3's LED control
            3'd4 : seg7 = 7'b0011001;    // 4's LED control
            3'd5 : seg7 = 7'b0010010;    // 5's LED control
            default: seg7 = 7'b1111111;  // default: all segments light off
        endcase
    endfunction
endmodule
