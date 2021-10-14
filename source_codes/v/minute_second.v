/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module minute_second (clk,m1,m0,s1,s0,dots);                 // what's this?
    input        clk;                                        // 50MHz
    output [6:0] m1, m0;
    output [6:0] s1, s0;
    output [3:0] dots;

    reg          sec_clk = 1;
    reg   [24:0] clk_cnt = 0;
    always @ (posedge clk) begin
        if (clk_cnt == 25'd24999999) begin
            clk_cnt <= 0;
            sec_clk <= ~sec_clk;
        end else begin
            clk_cnt <= clk_cnt + 1;
        end
    end

    reg [2:0] min1 = 0, sec1 = 0;
    reg [3:0] min0 = 0, sec0 = 0;
    always @ (posedge sec_clk) begin
        if (sec0 == 4'd9) begin
            sec0 <= 0;
            if (sec1 == 3'd5) begin
                sec1 <= 0;
                if (min0 == 4'd9) begin
                    min0 <= 0;
                    if (min1 == 3'd5) begin
                        min1 <= 0;
                    end else begin
                        min1 <= min1 + 1;
                    end
                end else begin
                    min0 <= min0 + 1;
                end
            end else begin
                sec1 <= sec1 + 1;
            end 
        end else begin
            sec0 <= sec0 + 1;
        end
    end

    assign m1 = seg7({1'b0,min1});
    assign s1 = seg7({1'b0,sec1});
    assign m0 = seg7(min0);
    assign s0 = seg7(sec0);
    assign dots = {1'b1,sec_clk,2'b11};

    //   0
    // 5   1
    //   6
    // 4   2
    //   3
    function [6:0] seg7;
        input [3:0] q;
        case (q)
            4'd0 : seg7 = 7'b1000000;
            4'd1 : seg7 = 7'b1111001;
            4'd2 : seg7 = 7'b0100100;
            4'd3 : seg7 = 7'b0110000;
            4'd4 : seg7 = 7'b0011001;
            4'd5 : seg7 = 7'b0010010;
            4'd6 : seg7 = 7'b0000010;
            4'd7 : seg7 = 7'b1111000;
            4'd8 : seg7 = 7'b0000000;
            4'd9 : seg7 = 7'b0010000;
            default: seg7 = 7'b1111111;
        endcase
    endfunction
endmodule
