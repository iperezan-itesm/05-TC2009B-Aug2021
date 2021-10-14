/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
main() {                       // pointer.c
    int  num;                  // an integer variable num
    int *ptr;                  // a pointer variable ptr pointing to num
    num =  1;                  // let the value of num be a 1
    ptr = &num;                // let the value of ptr be the address of num
    printf ("The address of num is %p\n", ptr);             // print ptr out
}
