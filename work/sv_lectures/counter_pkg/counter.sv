// Counter 0 - 7
// When reaching 7, count should be set back to 0
// There's a ripple bit for connecting several counters in a chain

//import counter_pkg::N_BITS;
//import counter_pkg::*;

module counter #(parameter N_BITS=3)
               (input logic        clk,
                input logic        asyn_n_rst, // asynchronous active-low reset
                output logic       ripple,
                output logic [N_BITS-1:0] count // 3bit - 0 to 7
               );

always_ff @ (posedge clk, negedge asyn_n_rst) begin
  if(!asyn_n_rst)begin
    count <= 'b0; // -> All count bits equal `{default:'1};
  end else begin
    count <= count + 1'b1;
  end
end

assign ripple = (&count);
/*
bit0 & bit1 & bit2 & bit3 ...... bitN = 1
*/
// assign ripple = count == 3'b111 ? 1 : 0;


// if (count == 3'b111) - if (1)
//    ripple = 1;
//  else
//    ripple = 0;


endmodule


/*
// generate
genvar i;
generate
  for(i=0; i<10; i++)
     // signal declaration
     // mdoule declaration
     counter dut(.a(a[i]);
endgenerate
*/
