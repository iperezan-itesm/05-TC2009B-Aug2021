/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module d_cache (  // direct mapping, 2^6 blocks, 1 word/block, write-through
    input  [31:0] p_a,                             // cpu address
    input  [31:0] p_dout,                          // cpu data out  to mem
    output [31:0] p_din,                           // cpu data in from mem
    input         p_strobe,                        // cpu strobe
    input         p_rw,                            // cpu read/write command
    input         uncached,                        // uncached
    output        p_ready,                         // ready (to cpu)
    input         clk, clrn,                       // clock and reset
    output [31:0] m_a,                             // mem address
    input  [31:0] m_dout,                          // mem data out  to cpu
    output [31:0] m_din,                           // mem data in from cpu
    output        m_strobe,                        // mem strobe
    output        m_rw,                            // mem read/write
    input         m_ready                          // mem ready
                );
    reg           d_valid [0:63];                  // 1-bit valid
    reg    [23:0] d_tags  [0:63];                  // 24-bit tag
    reg    [31:0] d_data  [0:63];                  // 32-bit data
    wire   [23:0] tag = p_a[31:8];                 // address tag
    wire   [31:0] c_din;                           // data to cache
    wire    [5:0] index = p_a[7:2];                // block index
    wire          c_write;                         // cache write
    integer       i;
    always @ (posedge clk or negedge clrn)
        if (!clrn) begin
            for (i=0; i<64; i=i+1)
                d_valid[i] <= 0;                   // clear valid
        end else if (c_write)
            d_valid[index] <= 1;                   // write valid
    always @ (posedge clk)  
        if (c_write) begin
            d_tags[index] <= tag;                  // write address tag
            d_data[index] <= c_din;                // write data
        end
    wire          valid = d_valid[index];          // read cache valid
    wire   [23:0] tagout = d_tags[index];          // read cache tag
    wire   [31:0] c_dout = d_data[index];          // read cache data
    wire cache_hit  = p_strobe &   valid & (tagout == tag);    // cache hit
    wire cache_miss = p_strobe & (!valid | (tagout != tag));   // cache miss
    assign m_din    = p_dout;                      // mem <-- cpu data
    assign m_a      = p_a;                         // mem <-- cpu address
    assign m_rw     = p_rw;                        // write through
    assign m_strobe = p_rw | cache_miss;           // also read on miss
    assign p_ready  = ~p_rw & cache_hit |          // read and hit or
                      (cache_miss | p_rw) & m_ready;  // write and mem ready
    assign c_write  = ~uncached & (p_rw | cache_miss & m_ready);    // write
    assign c_din    = p_rw?      p_dout : m_dout;  // data from cpu or mem
    assign p_din    = cache_hit? c_dout : m_dout;  // data from cache or mem
endmodule
