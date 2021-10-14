/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
main() {                                        // endian_union.c
    union {                                     // union:
        int intword;                            // to assess a word
        unsigned char characters[sizeof (int)]; // with different names
    } u;                                        // union u
    u.intword = 0x76543210;                     // access as an integer
    if (u.characters[sizeof (int) - 1] == 0x76) // access as array of byte
         printf("little endian\n");             // high byte in high address
    else printf("big endian\n");                // high byte in low address
}
