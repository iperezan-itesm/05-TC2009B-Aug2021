/************************************************
  The MIPS ASM code shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
.text                                      # code segment
main:
    lui   $3,  0xc000                      # vram space: c0000000 - dfffffff
    lui   $4,  0xa000                      # i/o  space: a0000000 - bfffffff
read_kbd:
    lw    $5,  0($4)                       # read kbd: {0,ready,byte}
    andi  $6,  $5,  0x100                  # check if ready
    beq   $6,  $0,  read_kbd               # if no key pressed, wait
    andi  $6,  $5,  0xff                   # ready, get data
    srl   $5,  $6,  4                      # first digit
    addi  $7,  $5, -10
    srl   $7,  $7,  31
    beq   $7,  $0,  abcdef1
    addi  $5,  $5,  0x30                   # to ascii [0-9]
    j     print1
abcdef1:
    addi  $5,  $5,  0x37                   # to ascii [a-f]
print1:
    jal   display                          # display char
    andi  $5,  $6,  0xf                    # second digit
    addi  $7,  $5, -10
    srl   $7,  $7,  31
    beq   $7,  $0,  abcdef2
    addi  $5,  $5,  0x30                   # to ascii [0-9]
    j     print2
abcdef2:
    addi  $5,  $5,  0x37                   # to ascii [a-f]
print2:
    jal   display                          # display char
    addi  $5,  $0,  0x20                   # [Space]
print3:
    jal   display                          # display char
    j     read_kbd                         # check next
display:
    sw    $5,  0($3)                       # to display
    addi  $3,  $3,  4
    jr    $ra
.end
