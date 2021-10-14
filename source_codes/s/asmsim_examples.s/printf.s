/*
 * printf.s
 * The printf() function prints output to STDOUT, according
 * to format and other arguments passed to printf().
 * Inputs: $4: address of the string in which %d, $x, ... may
 * be included. The corresponding data are given in $5, $6, ...
 * The current version of this simulator supports %d, %x, and %s.
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  print_dec        # prepare to print out
    la    $6,  a_word           # address of the word
    lw    $5,  0($6)            # load the word
    move  $6,  $5               # the same
    jal   printf                # print out in dec
print_out_in_hexadecimal:
    la    $4,  print_hex        # prepare to print out
    la    $6,  a_word           # address of the word
    lw    $5,  0($6)            # load the word
    move  $6,  $5               # the same
    jal   printf                # print out in hex
print_out_in_string:
    la    $4,  print_ascii      # prepare to print out
    la    $6,  a_word           # address of the word
    lw    $5,  0($6)            # load the word
    jal   printf                # print out in string
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
print_dec:                      # a string address
    .ascii "0x%x in decimal: %d\n"
print_hex:                      # a string address
    .ascii "0x%x in hexadecimal: 0x%x\n"
print_ascii:                    # a string address
    .ascii "0x%x in string: %s\n"
a_word:                         # the word address
    .word 0x476f6f64            # the word
.end
