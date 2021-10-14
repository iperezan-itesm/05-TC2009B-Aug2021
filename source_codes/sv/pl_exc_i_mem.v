/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pl_exc_i_mem (a,inst);         // instruction memory, rom
    input  [31:0] a;                  // address
    output [31:0] inst;               // instruction
    wire   [31:0] rom [0:63];         // rom cells: 64 words * 32 bits
    // rom[word_addr] = instruction   // (pc) label      instruction
    assign rom[6'h00] = 32'h0800001d; // (00) main:      j    start
    assign rom[6'h01] = 32'h00000000; // (04)            nop
    // common entry of exc and intr
    assign rom[6'h02] = 32'h401a6800; // (08) exc_base:  mfc0 $26, c0_cause
    assign rom[6'h03] = 32'h335b000c; // (0c)            andi $27, $26, 0xc
    assign rom[6'h04] = 32'h8f7b0020; // (10)            lw $27,j_table($27)
    assign rom[6'h05] = 32'h00000000; // (14)            nop
    assign rom[6'h06] = 32'h03600008; // (18)            jr   $27
    assign rom[6'h07] = 32'h00000000; // (1c)            nop
    // 0x00000030: intr handler
    assign rom[6'h0c] = 32'h00000000; // (30) int_entry: nop
    assign rom[6'h0d] = 32'h42000018; // (34)            eret
    assign rom[6'h0e] = 32'h00000000; // (38)            nop
    // 0x0000003c: syscall handler
    assign rom[6'h0f] = 32'h00000000; // (3c) sys_entry: nop
    assign rom[6'h10] = 32'h401a7000; // (40) epc_plus4: mfc0 $26, c0_epc
    assign rom[6'h11] = 32'h235a0004; // (44)            addi $26, $26, 4
    assign rom[6'h12] = 32'h409a7000; // (48)            mtc0 $26, c0_EPC
    assign rom[6'h13] = 32'h42000018; // (4c) e_return:  eret
    assign rom[6'h14] = 32'h00000000; // (50)            nop
    // 0x00000054: unimpl handler
    assign rom[6'h15] = 32'h00000000; // (54) uni_entry: nop
    assign rom[6'h16] = 32'h08000010; // (58)            j    epc_plus4
    assign rom[6'h17] = 32'h00000000; // (5c)            nop
    // 0x00000068: overflow handler
    assign rom[6'h1a] = 32'h00000000; // (68) ovf_entry: nop
    assign rom[6'h1b] = 32'h0800002f; // (6c)            j    exit
    assign rom[6'h1c] = 32'h00000000; // (70)            nop
    // start: enable exc and intr
    assign rom[6'h1d] = 32'h2008000f; // (74) start:     addi $8, $0, 0xf
    assign rom[6'h1e] = 32'h40886000; // (78) exc_ena:   mtc0 $8, c0_status
    // unimplemented instruction
    assign rom[6'h1f] = 32'h0128001a; // (7c) unimpl:    div  $9, $8
    assign rom[6'h20] = 32'h00000000; // (80)            nop
    // system call
    assign rom[6'h21] = 32'h0000000c; // (84) sys:       syscall
    assign rom[6'h22] = 32'h00000000; // (88)            nop
    // loop code for testing intr
    assign rom[6'h23] = 32'h34040050; // (8c) int:       ori  $4, $1, 0x50
    assign rom[6'h24] = 32'h20050004; // (90)            addi $5, $0, 4
    assign rom[6'h25] = 32'h00004020; // (94)            add  $8, $0, $0
    assign rom[6'h26] = 32'h8c890000; // (98) loop:      lw   $9, 0($4)
    assign rom[6'h27] = 32'h01094020; // (9c)            add  $8, $8, $9
    assign rom[6'h28] = 32'h20a5ffff; // (a0)            addi $5, $5, -1
    assign rom[6'h29] = 32'h14a0fffc; // (a4)            bne  $5, $0, loop
    assign rom[6'h2a] = 32'h20840004; // (a8)            addi $4, $4, 4 # DS
    assign rom[6'h2b] = 32'h8c080048; // (ac) ov:        lw   $8, 0x48($0)
    assign rom[6'h2c] = 32'h8c09004c; // (b0)            lw   $9, 0x4c($0)
    // jump to start forever
    assign rom[6'h2d] = 32'h0800001d; // (b4) forever:   j    start
    // overflow in delay slot
    assign rom[6'h2e] = 32'h01094020; // (b8)            add  $9, $9, $8 #ov
    // if not overflow, go to start
    // exit, should be jal $31 to os
    assign rom[6'h2f] = 32'h0800002f; // (bc) exit:      j    exit
    assign rom[6'h30] = 32'h00000000; // (c0)            nop
    assign inst = rom[a[7:2]];        // use 6-bit word address to read rom
endmodule
