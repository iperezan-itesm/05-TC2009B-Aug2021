/************************************************
************************************************/
module regfile #(parameter DATA_WIDTH=32, // Number of bits per register
                 parameter NUM_REGS=32)   // Number of registers
                (input  logic                        clk, // clock signal
                 input  logic       [DATA_WIDTH-1:0] d,   // data of write port
                 input  logic [$clog2(NUM_REGS)-1:0] ra,  // read address a
                 input  logic [$clog2(NUM_REGS)-1:0] rb,  // read address b
                 input  logic [$clog2(NUM_REGS)-1:0] rd,  // write address 
                 input  logic                        we,  // write enable
                 output logic       [DATA_WIDTH-1:0] qa,  // output port for address a 
                 output logic       [DATA_WIDTH-1:0] qb   // output port for address b
                );   
              
// Create registers
logic    [DATA_WIDTH-1:0] register [NUM_REGS]; // DATA_WIDTHxNUM_REGS register file

// Process for storing data in regfile
always @(posedge clk)begin  
   register[0]  <= 0;      // reg[0] is always 0 by design
   if ((rd != 0) && we)    // we can't write to reg[0] 
       register[rd] <= d;  // write d to reg[rd]
end

// Process for reading data from regfile
always_comb
begin  
  qa = register[ra]; // read port A
  qb = register[rb]; // read port B
end

endmodule
