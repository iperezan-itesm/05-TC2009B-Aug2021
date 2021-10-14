/************************************************
  The MIPS ASM code shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
/*
main() {
    int  num;   // an integer variable num
    int *ptr;   // a pointer variable ptr pointing to num
    num =  1;   // let the value of num be a 1
    ptr = &num; // let the value of ptr be the address of num
    printf ("The address of num is %p\n", ptr); // print ptr out
}
*/
.data                                   # data segment
$LC0:                                   # address of string
    .ascii "The address of num is %p\n" # string
.text                                   # code segment
main:                                   # program entry
    subi  $sp, $sp, 32                  # reserve stack space
    sw    $ra, 24($sp)                  # save return address
    li    $2,  0x00000001               # num = 1
    sw    $2,  16($sp)                  # store num into stack
    la    $4,  $LC0                     # $4: address of string
    addi  $5,  $sp, 16                  # $5: ptr = &num
    jal   printf                        # call printf
    lw    $ra, 24($sp)                  # restore return address
    addi  $sp, $sp, 32                  # release stack space
    jr    $ra                           # return to operating system
.end                                    # end of program
