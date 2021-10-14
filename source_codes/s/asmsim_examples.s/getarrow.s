/*
 * getarrow.s
 * getarrow(): gets pressed arrow key info.
 * Output: $2: key code:
 * 0x8000: Up
 * 0x8100: Left
 * 0x8200: Down
 * 0x8300: Right
 * 0xff00: Esc
 * 0x00xx: ASCII
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  arrow_msg        # address of message
    jal   printf                # print out message
wait_for_pressing_an_arrow_key:
    jal   getarrow              # get an arrow key code
store_key_code:
    la    $4,  arrow_code       # address of arrow key code
    sw    $2,  0($4)            # store arrow key code
print_bey_code:
    la    $4,  print_msg        # address of message
    la    $5,  arrow_code       # address of arrow key code
    lw    $5,  0($5)            # load arrow key code
    jal   printf                # print out message
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
arrow_msg:
    .ascii   "Press an arrow key: "
arrow_code:                     # word address
    .word  0                    # word 
print_msg:
    .ascii   "The key code is: 0x%x\n"
.end
