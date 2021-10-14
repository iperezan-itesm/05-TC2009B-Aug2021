/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module root_goldschmidt (d,start,clk,clrn,q,busy,ready,count,xn);
    input  [31:0] d;                                       // radicand:
    input         start;                                   //       .1xx...x
    input         clk, clrn;                               //   or: .01x...x
    output [31:0] q;                                       // root: .1xx...x
    output reg    busy;                                    // busy
    output reg    ready;                                   // ready
    output  [2:0] count;                                   // counter
    output [31:0] xn;                                      // 0.1111...1
    reg    [63:0] reg_d;                                   // 0.1xx or 0.01x
    reg    [63:0] reg_x;                                   // 0.1xx or 0.01x
    reg     [2:0] count;
    wire   [63:0] ri  = 64'hc000000000000000 -             // 1+(1-xi)/2 =
                        {1'b0,reg_x[63:1]};                // (3-xi)/2  1.xx
    wire  [127:0] ci  = ri    * ri;                        // ri*ri    0x.xx
    wire  [127:0] dr1 = reg_d * ri;                        // d*ri     0x.xx
    wire  [127:0] xr2 = reg_x * ci[126:63];                // x*ci     0x.xx
    wire   [63:0] xi  = {1'b0,{63{xr2[126]}}|xr2[125:63]}; // let xi<1  0.xx
    assign        q   = reg_d[62:31] + | reg_d[30:0];      // rounding up
    assign        xn  = reg_x[62:31];
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            busy  <= 0;
            ready <= 0;
        end else begin
            if (start) begin
                reg_d <= {1'b0,d,31'b0};                   // 0.1xx...x0. or
                reg_x <= {1'b0,d,31'b0};                   // 0.01x...x0...0
                busy  <= 1;
                ready <= 0;
                count <= 0;
            end else begin
                reg_d <= dr1[126:63];                      // x.xxx...x
                reg_x <= xi;                               // 0.xxx...x
                count <= count + 3'b1;                     // count++
                if (count == 3'h5) begin                   // finish
                    busy  <= 0;
                    ready <= 1;                            // q is ready
                end
            end
        end
    end
endmodule
