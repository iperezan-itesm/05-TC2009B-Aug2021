/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module tlb_8_entry (pte_in,tlbwi,tlbwr,index,vpn,       // 8-entry fully tlb
                     clk,clrn,pte_out,tlb_hit);
    input  [23:0] pte_in;           // page table entry from cp0 entrylo reg
    input         tlbwi;            // write tlb by index
    input         tlbwr;            // write tlb by random
    input   [2:0] index;            // tlb entry index from cp0 index reg
    input  [19:0] vpn;              // virtual page #
    input         clk, clrn;        // clock and reset
    output [23:0] pte_out;          // physical page frame # and attributes
    output        tlb_hit;          // tlb hit
    wire    [2:0] random;           // random #
    wire    [2:0] w_idx;            // random # or index
    wire    [2:0] ram_idx;          // ram address
    wire    [2:0] vpn_index;        // matched address
    wire          tlbw = tlbwi | tlbwr;
    rand3   rdm (clk,clrn,random);                     // random # generator
    mux2x3  w_address (index,random,tlbwr,w_idx);           // write address
    mux2x3  ram_address (vpn_index,w_idx,tlbw,ram_idx);       // ram address
    ram8x24 rpn (ram_idx,pte_in,clk,tlbw,pte_out);                    // ram
    cam8x21 valid_tag (clk,vpn,w_idx,tlbw,vpn_index,tlb_hit);         // cam
endmodule
