/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pl_inst_mem (a,inst);           // instruction memory, rom
    input  [31:0] a;                   // rom address
    output [31:0] inst;                // rom content = rom[a]
    wire   [31:0] rom [0:63];          // rom cells: 64 words * 32 bits
    // rom[word_addr] = instruction    // (pc) label   instruction
    assign rom[6'h00] = 32'h3c010000;  // (00) main:   lui  $1, 0         
    assign rom[6'h01] = 32'h34240050;  // (04)         ori  $4, $1, 80    
    assign rom[6'h02] = 32'h0c00001b;  // (08) call:   jal  sum           
    assign rom[6'h03] = 32'h20050004;  // (0c) dslot1: addi $5, $0,  4    
    assign rom[6'h04] = 32'hac820000;  // (10) return: sw   $2, 0($4)     
    assign rom[6'h05] = 32'h8c890000;  // (14)         lw   $9, 0($4)     
    assign rom[6'h06] = 32'h01244022;  // (18)         sub  $8, $9, $4    
    assign rom[6'h07] = 32'h20050003;  // (1c)         addi $5, $0,  3    
    assign rom[6'h08] = 32'h20a5ffff;  // (20) loop2:  addi $5, $5, -1    
    assign rom[6'h09] = 32'h34a8ffff;  // (24)         ori  $8, $5, 0xffff
    assign rom[6'h0a] = 32'h39085555;  // (28)         xori $8, $8, 0x5555
    assign rom[6'h0b] = 32'h2009ffff;  // (2c)         addi $9, $0, -1    
    assign rom[6'h0c] = 32'h312affff;  // (30)         andi $10,$9,0xffff
    assign rom[6'h0d] = 32'h01493025;  // (34)         or   $6, $10, $9   
    assign rom[6'h0e] = 32'h01494026;  // (38)         xor  $8, $10, $9   
    assign rom[6'h0f] = 32'h01463824;  // (3c)         and  $7, $10, $6   
    assign rom[6'h10] = 32'h10a00003;  // (40)         beq  $5, $0, shift 
    assign rom[6'h11] = 32'h00000000;  // (44) dslot2: nop                
    assign rom[6'h12] = 32'h08000008;  // (48)         j    loop2         
    assign rom[6'h13] = 32'h00000000;  // (4c) dslot3: nop                
    assign rom[6'h14] = 32'h2005ffff;  // (50) shift:  addi $5, $0, -1    
    assign rom[6'h15] = 32'h000543c0;  // (54)         sll  $8, $5, 15    
    assign rom[6'h16] = 32'h00084400;  // (58)         sll  $8, $8, 16    
    assign rom[6'h17] = 32'h00084403;  // (5c)         sra  $8, $8, 16    
    assign rom[6'h18] = 32'h000843c2;  // (60)         srl  $8, $8, 15    
    assign rom[6'h19] = 32'h08000019;  // (64) finish: j    finish        
    assign rom[6'h1a] = 32'h00000000;  // (68) dslot4: nop                
    assign rom[6'h1b] = 32'h00004020;  // (6c) sum:    add  $8, $0, $0    
    assign rom[6'h1c] = 32'h8c890000;  // (70) loop:   lw   $9, 0($4)     
    assign rom[6'h1d] = 32'h01094020;  // (74) stall:  add  $8, $8, $9    
    assign rom[6'h1e] = 32'h20a5ffff;  // (78)         addi $5, $5, -1    
    assign rom[6'h1f] = 32'h14a0fffc;  // (7c)         bne  $5, $0, loop  
    assign rom[6'h20] = 32'h20840004;  // (80) dslot5: addi $4, $4,  4    
    assign rom[6'h21] = 32'h03e00008;  // (84)         jr   $31           
    assign rom[6'h22] = 32'h00081000;  // (88) dslot6: sll  $2, $8, 0     
    assign inst = rom[a[7:2]];         // use 6-bit word address to read rom
endmodule
