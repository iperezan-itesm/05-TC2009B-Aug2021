/*
 * getcal.s
 * getcals(): gets calendar in integer format
 * Input: $4: the pointer to the beginning of an
 * integer array where the month, data, year, day,
 * hour, minute, and second are stored in sequence.
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  calendar         # address of calendar
    jal   getcal                # get calendar
print_calendar:
    la    $3,  calendar         # address of calendar
    la    $4,  calendar_msg     # address of parameter
    lw    $5,  0x00($3)         # load month
    lw    $6,  0x04($3)         # load date
    lw    $7,  0x08($3)         # load year
    lw    $2,  0x10($3)         # load hour
    sw    $2,  16($sp)          # put into stack
    lw    $2,  0x14($3)         # load minute
    sw    $2,  20($sp)          # put into stack
    lw    $2,  0x18($3)         # load second
    sw    $2,  24($sp)          # put into stack
    lw    $2,  0x0c($3)         # load day
    sw    $2,  28($sp)          # put into stack
    jal   printf                # printf out calendar
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
calendar:
    .word    0                  # month
    .word    0                  # date
    .word    0                  # year
    .word    0                  # day
    .word    0                  # hour
    .word    0                  # minute
    .word    0                  # second
calendar_msg:
    .asciiz  "%d %d %d %02d:%02d:%02d [%d]\n"
.end
