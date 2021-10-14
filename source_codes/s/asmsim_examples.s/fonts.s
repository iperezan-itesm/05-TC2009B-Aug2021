/*
 * fonts.s
 * Displays text on VGA (using a user-defined font_table)
 * The font_table stores characters' fonts (8x8 pixels for each)
 */
`define _Video_RAM 0xd0000000   # 0xd0000000 - 0xd007ffff
 # 1024(640) * 512(480) = 2^{10} * 2^{9} = 2^{19}
 # character: 32-bit: 24-bit RGB, 0, 7-bit ASCII
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    jal   refresh_vga_manu      # refresh VGA manually
#   jal   refresh_vga_auto      # refresh automatically
    lui   $6,  0xffff           # char color = white
    ori   $6,  $6,  0xff00      # char color = white
    li    $7,  0xa7233500       # for changing color
fill_text:
    ori   $5,  $0,  0x20        # char = <Space>
write_a_char:
    or    $4,  $6,  $5          # color,ascii
    jal   display_char          # put pixels to video_ram
    addi  $5,  $5,  1           # next char
    andi  $8,  $5,  0x7f        # if (ascii != 0x80)
    bne   $8,  $0,  write_a_char
coffee_break:
    jal   paint                 # update VGA manually
    li    $4,  100              # sleep time (ms)
    jal   sleep                 # ZZZ...zzz...
full_fill:
    sub   $6,  $6,  $7          # change color
    la    $4,  text_row         # address of row pointer
    lw    $5,  0($4)            # text row pointer
    subi  $8,  $5,  60          # if (text_row < 60)
    bltz  $8,  fill_text        # continue
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
display_char:                   # on vram, $4: {color,ascii}
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    sw    $5,  52($sp)          # save $5
    sw    $6,  48($sp)          # save $6
    sw    $7,  44($sp)          # save $7
    sw    $8,  40($sp)          # save $8
    sw    $9,  36($sp)          # save $9
    sw    $10, 32($sp)          # save $10
    sw    $11, 28($sp)          # save $11
    sw    $12, 24($sp)          # save $12
    sw    $13, 20($sp)          # save $13
    sw    $14, 16($sp)          # save $14
    sw    $15, 12($sp)          # save $15
    move  $fp, $sp              # new frame pointer
    la    $5,  text_row
    lw    $6,  0($5)            # $6: text_row pointer
    lw    $7,  4($5)            # $7: text_col pointer
    andi  $15, $4,  0x7f        # get ascii, mask color
    subi  $15, $15, 0x20        # - <Space>
    sll   $15, $15, 3           # 8-byte fonts per char
    la    $10, font_table       # font_table address
    add   $10, $10, $15         # font address of this char
    lw    $11, 0($10)           # get the 1st 32-bit fonts
get_char_font:
    addi  $8,  $0,  0           # font_row = 0
font_row:
    addi  $9,  $0,  0           # font_col = 0
font_col:
    andi  $14, $8,  3           # the last 2 bits of font_row
    sll   $14, $14, 3           # 8 pixels per font row
    add   $14, $14, $9          # {font_row[1:0],font_col}: 0 - 31
    addi  $15, $0,  31          # change to
    sub   $14, $15, $14         # 31 - 0 for shift
    srlv  $14, $11, $14         # $14 <- ($11 >>> $14)
    andi  $14, $14, 1           # check LSB of shifted font
    beq   $14, $0,  to_write    # if (LSB == 1)
    srl   $14, $4,  8           # use char color; else black
to_write:
    sll   $12, $6,  3           # text_row * 8
    add   $12, $12, $8          # vram_row = text_row * 8 + font_row
    sll   $13, $7,  3           # text_col * 8
    add   $13, $13, $9          # vram_col = text_col * 8 + font_col
    sll   $15, $12, 10          # vram_row << 10
    or    $15, $15, $13         # + vram_col
    la    $12, _Video_RAM       # + vram base address
    add   $15, $15, $12         # = vram address
    sw    $14, 0($15)           # write pixel to vram
font_col_go_on:
    addi  $9,  $9,  1           # font_col++
    subi  $14, $9,  8           # if (font_col < 8)
    bltz  $14, font_col         # goto next font column
font_row_go_on:
    addi  $8,  $8,  1           # font_row++
    addi  $14, $0,  4           # need 2nd half fonts?
    bne   $14, $8,  row_continue
    lw    $11, 4($10)           # get the 2nd 32-bit fonts
row_continue:
    subi  $14, $8,  8           # if (font_row < 8)
    bltz  $14, font_row         # goto next font row
    addi  $7,  $7,  1           # col++
    ori   $11, $0,  80          # if (text_col < 80)
    bne   $11, $7,  update_col  # goto next column
    addi  $6,  $6,  1           # row++
    sw    $6,  0($5)            # update text_row pointer
    addi  $7,  $0,  0           # col = 0
update_col:
    sw    $7,  4($5)            # update text_row pointer
return_to_caller:               # return
    move  $sp, $fp              # restore stack pointer
    lw    $5,  52($sp)          # restore $5
    lw    $6,  48($sp)          # restore $6
    lw    $7,  44($sp)          # restore $7
    lw    $8,  40($sp)          # restore $8
    lw    $9,  36($sp)          # restore $9
    lw    $10, 32($sp)          # restore $10
    lw    $11, 28($sp)          # restore $11
    lw    $12, 24($sp)          # restore $12
    lw    $13, 20($sp)          # restore $13
    lw    $14, 16($sp)          # restore $14
    lw    $15, 12($sp)          # restore $15
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return
.data                           # data segment
text_row:
    .word 0                     # text row pointer
text_col:
    .word 0                     # text col pointer
font_table:
    .word 0x00000000,0x00000000 # <SPACE> 20
    .word 0x18181818,0x00181800 #    !    21
    .word 0x6c6c4800,0x00000000 #    "    22
    .word 0x6c6cfe6c,0xfe6c6c00 #    #    23
    .word 0x187ed87e,0x1b7e1800 #    $    24
    .word 0x62660c18,0x30664600 #    %    25
    .word 0x386c6876,0xdccc7600 #    &    26
    .word 0x18183000,0x00000000 #    '    27
    .word 0x0c183030,0x30180c00 #    (    28
    .word 0x30180c0c,0x0c183000 #    )    29
    .word 0x006c38fe,0x386c0000 #    *    2a
    .word 0x0018187e,0x18180000 #    +    2b
    .word 0x00000000,0x00181810 #    ,    2c
    .word 0x0000007e,0x00000000 #    -    2d
    .word 0x00000000,0x00181800 #    .    2e
    .word 0x02060c18,0x30604000 #    /    2f
    .word 0x3c666e76,0x66663c00 #    0    30
    .word 0x18183818,0x18183c00 #    1    31
    .word 0x7c06063c,0x60607c00 #    2    32
    .word 0x7c06063c,0x06067c00 #    3    33
    .word 0x6666667e,0x06060600 #    4    34
    .word 0x7e60607c,0x06067c00 #    5    35
    .word 0x3c60607c,0x66663c00 #    6    36
    .word 0x7e060c18,0x18181800 #    7    37
    .word 0x3c66663c,0x66663c00 #    8    38
    .word 0x3c66663e,0x06063c00 #    9    39
    .word 0x00181800,0x18180000 #    :    3a
    .word 0x00001818,0x00181810 #    ;    3b
    .word 0x0c183060,0x30180c00 #    <    3c
    .word 0x00007e00,0x7e000000 #    =    3d
    .word 0x30180c06,0x0c183000 #    >    3e
    .word 0x3c66061c,0x18001800 #    ?    3f
    .word 0x3c666e6a,0x6e603e00 #    @    40
    .word 0x3c66667e,0x66666600 #    A    41
    .word 0x7c66667c,0x66667c00 #    B    42
    .word 0x3c666060,0x60663c00 #    C    43
    .word 0x7c666666,0x66667c00 #    D    44
    .word 0x7e60607c,0x60607e00 #    E    45
    .word 0x7e60607c,0x60606000 #    F    46
    .word 0x3c66606e,0x66663c00 #    G    47
    .word 0x6666667e,0x66666600 #    H    48
    .word 0x3c181818,0x18183c00 #    I    49
    .word 0x3e0c0c0c,0x0c6c3800 #    J    4a
    .word 0x666c7870,0x786c6600 #    K    4b
    .word 0x60606060,0x60607e00 #    L    4c
    .word 0xc6eefed6,0xc6c6c600 #    M    4d
    .word 0x6666767e,0x6e666600 #    N    4e
    .word 0x3c666666,0x66663c00 #    O    4f
    .word 0x7c66667c,0x60606000 #    P    50
    .word 0x3c666666,0x6e663e00 #    Q    51
    .word 0x7c66667c,0x66666600 #    R    52
    .word 0x3e60603c,0x06067c00 #    S    53
    .word 0x7e181818,0x18181800 #    T    54
    .word 0x66666666,0x66663c00 #    U    55
    .word 0x66666666,0x3c3c1800 #    V    56
    .word 0xc6c6d6d6,0xfeee4400 #    W    57
    .word 0x66663c18,0x3c666600 #    X    58
    .word 0x6666663c,0x18181800 #    Y    59
    .word 0x7e060c18,0x30607e00 #    Z    5a
    .word 0x3c303030,0x30303c00 #    [    5b
    .word 0x40603018,0x0c060200 #    \    5c
    .word 0x3c0c0c0c,0x0c0c3c00 #    ]    5d
    .word 0x10386c00,0x00000000 #    ^    5e
    .word 0x00000000,0x000000ff #    _    5f
    .word 0x18180c00,0x00000000 #    `    60
    .word 0x00003c06,0x3e663a00 #    a    61
    .word 0x60607c66,0x66667c00 #    b    62
    .word 0x00003c66,0x60663c00 #    c    63
    .word 0x06063e66,0x66663e00 #    d    64
    .word 0x00003c66,0x7c603c00 #    e    65
    .word 0x0e18183e,0x18181800 #    f    66
    .word 0x00003e66,0x663e063c #    g    67
    .word 0x60607c66,0x66666600 #    h    68
    .word 0x18001818,0x18181800 #    i    69
    .word 0x18001818,0x18181870 #    j    6a
    .word 0x6060666c,0x786c6600 #    k    6b
    .word 0x30303030,0x30301c00 #    l    6c
    .word 0x0000ccfe,0xd6c6c600 #    m    6d
    .word 0x00007c66,0x66666600 #    n    6e
    .word 0x00003c66,0x66663c00 #    o    6f
    .word 0x00007c66,0x667c6060 #    p    70
    .word 0x00003e66,0x663e0606 #    q    71
    .word 0x00003638,0x30303000 #    r    72
    .word 0x00003e60,0x3c067c00 #    s    73
    .word 0x18183c18,0x18180c00 #    t    74
    .word 0x00006666,0x66663c00 #    u    75
    .word 0x00006666,0x663c1800 #    v    76
    .word 0x0000c6d6,0xd67c2800 #    w    77
    .word 0x0000663c,0x183c6600 #    x    78
    .word 0x00006666,0x663e067c #    y    79
    .word 0x00007e0c,0x18307e00 #    z    7a
    .word 0x1c303060,0x30301c00 #    {    7b
    .word 0x18181818,0x18181800 #    |    7c
    .word 0x380c0c06,0x0c0c3800 #    }    7d
    .word 0x00324c00,0x00000000 #    ~    7e
    .word 0xffffffff,0xffffffff #  <DEL>  7f
.end
