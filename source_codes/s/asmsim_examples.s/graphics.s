/*
 * graphics.s
 * Draws and fills graphics objects on VGA. Currently supports:
 *     drawline()
 *     drawoval()
 *     drawrect()
 *     drawrect3d()
 *     drawstring()
 *     filloval()
 *     fillrect()
 *     fillrect3d()
 *     paint()
 * Note that only paint() paints VGA, others do in off-screen buffer
 * The parameters of each function call can be found in this example
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  g_bgcolor        # back ground color
    jal   fillrect              # fill rectangle
draw_line:                      # draw in off-screen buffer
    la    $4,  g_drawline       # draw a line parameters
    jal   drawline              # draw a line
draw_oval:
    la    $4,  g_drawoval       # draw a oval parameters
    jal   drawoval              # draw a oval
draw_rect:
    la    $4,  g_drawrect       # draw a rect parameters
    jal   drawrect              # draw a rect
draw_3d_rect:
    la    $4,  g_drawrect3d     # draw a rect parameters
    jal   drawrect3d            # draw a rect
fill_oval:
    la    $4,  g_filloval       # fill a oval parameters
    jal   filloval              # fill a oval
fill_rect:
    la    $4,  g_fillrect       # fill a rect parameters
    jal   fillrect              # fill a rect
fill_3d_rect:
    la    $4,  g_fillrect3d     # fill a rect parameters
    jal   fillrect3d            # fill a rect
draw_my_canvas_string:
    la    $4,  g_drawstring     # draw the string parameters
    jal   drawstring            # draw the string
paint_on_canvas:
    jal   paint                 # paint off-screen buffer
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
g_bgcolor:
    .word    0xefafaf           # color
    .word    0                  # x
    .word    0                  # y
    .word    640                # w
    .word    480                # h
g_drawline:
    .word    0xff0000           # color
    .word    0                  # x1
    .word    0                  # y1
    .word    639                # x2
    .word    479                # y2
g_drawoval:
    .word    0x004400           # color
    .word    410                # x
    .word    110                # y
    .word    150                # w
    .word    100                # h
g_drawrect:
    .word    0x0000ff           # color
    .word    400                # x
    .word    390                # y
    .word    80                 # w
    .word    50                 # h
g_drawstring:
    .word    0x000000           # color
    .word    230                # x
    .word    80                 # y
    .word    0x020128           # font name_type_size
    .ascii   "myCanvas"         # string
g_filloval:
    .word    0x00ffff           # color
    .word    10                 # x
    .word    110                # y
    .word    150                # w
    .word    100                # h
g_drawrect3d:
    .word    0xffff00           # color
    .word    250                # x
    .word    220                # y
    .word    50                 # w
    .word    80                 # h
g_fillrect:
    .word    0xff00ff           # color
    .word    50                 # x
    .word    350                # y
    .word    80                 # w
    .word    50                 # h
g_fillrect3d:
    .word    0x007f00           # color
    .word    350                # x
    .word    220                # y
    .word    80                 # w
    .word    50                 # h
.end
