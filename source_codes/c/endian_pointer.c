/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
main () {                                       // endian_pointer.c
    int n = 0x76543210;                         // a word
    if (*(unsigned char *)&n == 0x10)           // char starting address
         printf("little endian\n");             // stored 0x10
    else printf("big endian\n");                // stored 0x76
}
