/*
 * vram.s
 * writes/reads pixels to/from vram directly with sw/lw instructions
 * video ram address: (y << 10) + x; x: 0 - 639; y: 0 - 479
 * pixel: (r << 16) + (g << 8) + b; 24-bit true color
 */
`define _Video_RAM 0xd0000000   # 0xd0000000 - 0xd007ffff
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    jal   refresh_vga_manu      # refresh VGA manually
#   jal   refresh_vga_auto      # refresh automatically
    la    $4,  _Video_RAM       # vram start address
write_pixels:
    sll   $5,  $0,  0           # color = black
    li    $6,  0                # for (y = 0; y < 240(480); y++)
write_a_row:
    li    $7,  0                # for (x = 0; x < 640; x++)
write_a_col:
    sll   $8,  $6,  10          # y << 10
    add   $8,  $8,  $7          # + x
    add   $9,  $4,  $8          # + base
    sw    $5,  0($9)            # write pixel
    addi  $7,  $7,  1           # x++
    addi  $5,  $5,  109         # 2^24/(640*480) = 54.613333
    subi  $8,  $7,  640         # if (x < 640)
    bltz  $8,  write_a_col      # goto next col
    jal   paint                 # refresh VGA manually
sleep_after_paint:
    move  $10, $4               # save $4
    li    $4,  50               # sleep time (ms)
    jal   sleep                 # do sleep
    move  $4,  $10              # restore $4
    addi  $6,  $6,  1           # y++
    subi  $8,  $6,  240         # if (y < 240 (480))
    bltz  $8,  write_a_row      # goto next row
scroll_up:
    la    $4,  _Video_RAM       # vram start address
scroll_up_60_times:
    li    $3,  0                # for (i = 0; i <  30; i++)
scroll_up_one_time:
    li    $6,  8                # for (y = 8; y < 240(480); y++)
scroll_up_8rows:
    li    $7,  0                # for (x = 0; x < 640; x++)
scroll_up_a_col:
    sll   $8,  $6,  10          # y << 10
    add   $8,  $8,  $7          # + x
    add   $9,  $4,  $8          # + base
    lw    $5,  0($9)            # read a pixel
    subi  $8,  $6,  8           # scroll up 8 rows 
    sll   $8,  $8,  10          # y << 10
    add   $8,  $8,  $7          # + x
    add   $9,  $4,  $8          # + base
    sw    $5,  0($9)            # write the pixel
    addi  $7,  $7,  1           # x++
    subi  $8,  $7,  640         # if (x < 640)
    bltz  $8,  scroll_up_a_col  # goto next col
fill_8rows_with_black:
    la    $14,  _Video_RAM      # vram start address
    sll   $15,  $0,   0         # black
    li    $16,  232             # for (y = 472; y < 240(480); y++)
black_a_row:
    li    $17,  0               # for (x = 0; x < 640; x++)
black_a_col:
    sll   $18,  $16,  10        # y << 10
    add   $18,  $18,  $17       # + x
    add   $19,  $14,  $18       # + base
    sw    $15,  0($19)          # write pixel
    addi  $17,  $17,  1         # x++
    subi  $18,  $17,  640       # if (x < 640)
    bltz  $18,  black_a_col     # goto next col
    addi  $16,  $16,  1         # y++
    subi  $18,  $16,  240       # if (y < 240(480))
    bltz  $18,  black_a_row     # goto next row
    addi  $6,  $6,  1           # y++
    subi  $8,  $6,  240         # if (y < 240(480))
    bltz  $8,  scroll_up_8rows  # goto next row
    jal   paint                 # refresh VGA manually
sleep_for_a_while:
    move  $10, $4               # save $4
    li    $4,  50               # sleep time (ms)
    jal   sleep                 # do sleep
    move  $4,  $10              # restore $4
    addi  $3,  $3,  1           # i++
    subi  $8,  $3,  30          # if (i < 30(60))
    bltz  $8,  scroll_up_one_time # goto next time
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
.end
