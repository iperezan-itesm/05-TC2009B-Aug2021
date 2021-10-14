/*
 * gettimer.s
 * gettimer(): gets the system timer in ms
 * Output: $2: the timer
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    jal   gettimer              # gettimer
    la    $4,  timer            # adrress of timer
    sw    $2,  0($4)            # restore timer
    la    $4,  timer_msg        # adrress of timer message
    la    $5,  timer            # adrress of timer
    lw    $5,  0($5)            # load timer
    jal   printf                # print out timer
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
timer:
    .word    0
timer_msg:
    .ascii "The current timer shows %d\n"
.end
