; Program that turns green LED on on FRDM-KL25Z board
; Commented portions of the code correspond to red LED
; This code can only turn one LED at the time
; Modifications should take place in order to light both LEDs at the same time

; Compiler directives
  AREA prg_1,CODE,READONLY
  ENTRY
  EXPORT __main

; constants example
SIM_BASE              EQU  0x40047000 ; Base address
SIM_SCGC5_OFFSET      EQU  0x1038     ; Offset
SIM_SCGC5             EQU  (SIM_BASE+SIM_SCGC5_OFFSET)
SIM_SCGC5_PORTB_MASK  EQU  0x400

; loop example
loop
    B loop
  END
