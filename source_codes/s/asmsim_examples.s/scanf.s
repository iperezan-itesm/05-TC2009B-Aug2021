/*
 * scanf.s
 * The scanf() function reads input from STDIN, according
 * to format and other arguments passed to scanf().
 * Inputs: $4: address of the string: %d, $x, or %s
 *         $5: the address where the value is stored
 * The current version of this simulator supports %d, %x, and %s.
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  input_msg_dec    # input message address
    jal   printf                # print out message
input_an_integer_dec:
    la    $4,  format_dec       # %d: decimal format
    la    $5,  n                # n: the place to store integer
    jal   scanf                 # input integer in dec
print_out_the_integer_dec:
    la    $4,  output_msg_dec   # output message address
    la    $5,  n                # n: the place of the integer
    lw    $5,  0($5)            # load the integer
    jal   printf                # print out message
print_out_msg_hex:
    la    $4,  input_msg_hex    # input message address
    jal   printf                # print out message
input_an_integer_hex:
    la    $4,  format_hex       # %x: hexadecimal format
    la    $5,  n                # n: the place to store integer
    jal   scanf                 # input integer in hex
print_out_the_integer_hex:
    la    $4,  output_msg_hex   # output message address
    la    $5,  n                # n: the place of the integer
    lw    $5,  0($5)            # load the integer
    jal   printf                # print out message
print_out_msg_str:
    la    $4,  input_msg_str    # input message address
    jal   printf                # print out message
input_a_string:
    la    $4,  format_str       # %s: string format
    la    $5,  s                # s: the place to store string
    jal   scanf                 # input string
print_out_the_string:
    la    $4,  output_msg_str   # output message address
    jal   printf                # print out message
    la    $4,  s                # s: the place of the string
    jal   printf                # print out message
    la    $4,  enter            # the place of the string [enter]
    jal   printf                # print out message
print_out_the_string_all_in_one:
    la    $4,  output_msg_s1    # output message address
    la    $5,  s                # s: the place of the string
    jal   printf                # print out message
return_to_caller(os):           # exit()
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
input_msg_dec:
    .ascii "Input an integer: "
input_msg_hex:
    .ascii "Input an integer in hex: "
input_msg_str:
    .ascii "Input a string: "
format_dec:
    .ascii "%d"                 # "for decimal"
format_hex:
    .ascii "%x"                 # "for hexadecimal"
format_str:
    .ascii "%s"                 # "for string"
output_msg_dec:
    .ascii "The integer you inputted is %d\n"
output_msg_hex:
    .ascii "The integer you inputted is %x\n"
output_msg_str:
    .ascii "The string you inputted is "
output_msg_s1:
    .ascii "The string you inputted is %s (1 printf call)\n"
n:
    .word  0                    # the integer
enter:
    .ascii "(3 printf calls)\n" # the character [enter]
s:
    .ascii "                "   # the string in the last
.end
