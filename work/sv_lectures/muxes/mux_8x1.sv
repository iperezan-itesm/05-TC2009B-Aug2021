module mux_8x1 (input  logic [3:0] d0,
                input  logic [3:0] d1,
                input  logic [3:0] d2,
                input  logic [3:0] d3,
                input  logic [3:0] d4,
                input  logic [3:0] d5,
                input  logic [3:0] d6,
                input  logic [3:0] d7,
                input  logic [2:0] sel,
                output logic [3:0] out
               );

always_comb begin
  if      (sel==0) out = d0;
  else if (sel==1) out = d1;
  else if (sel==2) out = d2;
  else if (sel==3) out = d3;
  else if (sel==4) out = d4;
  else if (sel==5) out = d5;
  else if (sel==6) out = d6;
  else             out = d7;
end


endmodule:mux_8x1
