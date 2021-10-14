/*
 * getchar.s
 * getchar(): gets a character from STDIN
 * Output: $2: the ASCII of the character
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  input_char_msg   # address of message
    jal   printf                # print out message
    jal   getchar               # input a character
    la    $4,  a_word           # address of word
    sw    $2,  0($4)            # store the character
print_out_the_string:
    la    $4,  output_msg       # output message address
    jal   printf                # print out message
    move  $4,  $2               # prepare to print
    jal   putchar               # print out character
    la    $4,  enter            # the place of the string [enter]
    jal   printf                # print out message
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
input_char_msg:
    .ascii   "Input a character (no need to press [Enter] key): "
a_word:                         # the word address
    .word  0                    # the word
output_msg:
    .ascii "The character you inputted is "
enter:
    .ascii "\n"                 # the character [enter]
.end
