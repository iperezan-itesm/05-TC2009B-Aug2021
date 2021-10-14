/*
 * sprintf.s
 * The fprintf() function prints output to a buffer, according
 * to format and other arguments passed to sprintf().
 * Inputs: $4: the buffer address, $5: address of the string in
 * which %d, $x, ... may be included. The corresponding data are
 * given in $6, $7, ... Return: $2: the number of characters.
 * The current version of this simulator supports %d, %x, and %s.
 */
.text                           # code segment
main:                           # program entry
    subu  $sp,  $sp,  104       # reserve stack space
    sw    $ra,  100($sp)        # save return address
    sw    $fp,  96($sp)         # save frame pointer
    move  $fp,  $sp             # new frame pointer
user_main:
    li    $2,  0x7fffffff       # translate 0x7fffffff
    sw    $2,  16($fp)          # and
    li    $2,  -1               # -1
    sw    $2,  20($fp)          # to string
    addu  $2,  $fp,  24
    move  $4,  $2               # result string address
    la    $5,  data_format      # in dec and hex format
    lw    $6,  16($fp)          # 0x7fffffff
    lw    $7,  20($fp)          # -1
    jal   sprintf               # do translation
    sw    $2,  88($fp)          # str length in $2
    addu  $2,  $fp,  24
    la    $4,  string           # printf string address
    move  $5,  $2               # result string address
    lw    $6,  88($fp)          # length
    jal   printf                # print out
return_to_caller(os):           # exit();
    move  $sp,  $fp             # restore stack pointer
    lw    $ra,  100($sp)        # restore frame pointer
    lw    $fp,  96($sp)         # restore return address
    addu  $sp,  $sp,  104       # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
data_format:                    # for sprintf
    .ascii "%d, %x"             # format
string:                         # for printf
    .ascii "str = "%s", length = %d\n"   # printf
.end
