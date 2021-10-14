/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module root_nonrestoring (d,load,clk,clrn,q,r,busy,ready,count);
    input  [31:0] d;                                            // radicand
    input         load;                                         // start
    input         clk, clrn;                                    // clk,reset
    output [15:0] q;                                            // root
    output [16:0] r;                                            // remainder
    output reg    busy;                                         // busy
    output reg    ready;                                        // ready
    output  [3:0] count;                                        // counter
    reg    [31:0] reg_d;
    reg    [15:0] reg_q;
    reg    [17:0] reg_r;
    reg     [3:0] count;
    wire   [15:0] add_sub;
    wire          g_or   =  reg_d[31]  | reg_d[30];             // or   gate
    wire          g_xnor =  reg_d[31] ~^ reg_d[30];             // xnor gate
    wire          g_not  = ~reg_d[30];                          // not  gate
    wire   [17:0] r18 = {add_sub,g_xnor,g_not};
    // clas16 (sub,       a,          b,    ci,  s)
    clas16 as (~reg_r[17],reg_r[15:0],reg_q,g_or,add_sub);
    assign q = reg_q;
    assign r = reg_r[17]?                                       // adjust
               reg_r[16:0] + {reg_q[15:0],1'b1} : reg_r[16:0];  // remainder
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            busy  <= 0;
            ready <= 0;
        end else begin
            if (load) begin
                reg_d <= d;                                     // load d
                reg_q <= 0;
                reg_r <= 0;
                busy  <= 1;
                ready <= 0;
                count <= 0;
             end else if (busy) begin
                reg_d <= {reg_d[29:0],2'b0};                    // << 2
                reg_q <= {reg_q[14:0],~add_sub[15]};            // << 1
                reg_r <=  r18;
                count <=  count + 4'b1;                         // count++
                if (count == 4'hf) begin                        // finish
                    busy  <= 0;
                    ready <= 1;                                 // q,r ready
                end
            end
        end
    end
endmodule
