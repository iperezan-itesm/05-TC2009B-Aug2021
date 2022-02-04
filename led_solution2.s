; EIA 203
; ================================================================================
; Program that turns green LED on on FRDM-KL25Z board
; ================================================================================
; Commented portions of the code correspond to red LED
; This code can only turn on one LED at the time
; Modifications should take place in order to light both LEDs at the same time

; ================================================================================
; FRDM-KL25Z LED distribution
; ================================================================================
; FRDM-KL25Z board provices a RGB LED
; Red   LED is connected to PORTB18
; Green LED is connected to PORTB19
; Blue  LED is connected to PORTD1

; ================================================================================
; Assembler directives
; https://www.keil.com/support/man/docs/armasm/armasm_dom1361290002714.htm
; ================================================================================



; Define program area and entry point
  AREA prg_1,CODE,READONLY
;   AREA directive instructs the assembler to assemble a new code or data section.
;   CODE directive instructs the assembler to interpret subsequent instructions as
;     ARM instructions, using either the UAL or the pre-UAL ARM assembly language
;     syntax. Contains machine instructions.
;   READONLY states that once assembled, the machine code is read only and
;     cannot be modified during runtime.
  ENTRY         ; Declare an entry point where the program execution starts
  EXPORT __main ; Make __main visible to the linker

  GET kl25z_defines.s

__main
    ; Configure SCGC on PORTB and PORTD
    ; Enable clock on GPIOB and GPIOD

    ; 1) Load r1 with SIM_SCG5 base address
    ;    Load r2 with SIM_SCGC5_OFFSET
    LDR  r1,=SIM_BASE          ; r1 = 0x40047000
    LDR  r2,=SIM_SCGC5_OFFSET  ; r2 = 0x00001038

    ;    Load r3 with SIM_SCGC5_PORTB_MASK
    ;    Load r4 with SIM_SCGC5_PORTD_MASK
    ;    Load r4 with the OR of SIM_SCGC5_PORTB_MASK and SIM_SCGC5_PORTD_MASK
    LDR r3,=SIM_SCGC5_PORTB_MASK
    LDR r4,=SIM_SCGC5_PORTD_MASK
    ORRS r4,r3,r4

    ;    Store into address (SIM_BASE + SIM_SCGC5_OFFSET) value of (SIM_SCGC5_PORTB_MASK | SIM_SCGC5_PORTD_MASK)
    STR r4,[r1,r2] ; 0x40048038 = 0x00001400

    ; 2) Configure PORTB and PORTD as GPIOs
    ;    PORTB18 as GPIO
    ;    Load r1 with PORTB_PCR_BASE address
    ;    Load r2 with PCR_BIT_OFFSET_18
    ;    Store into address (PORTB_PCR_BASE+PCR_BIT_OFFSET_18) the value of PORTx_PCRn_MUX_GPIO_MASK
    LDR r1,=PORTB_PCR_BASE
    LDR r2,=PCR_BIT_OFFSET_18
    LDR r3,=PORTx_PCRn_MUX_GPIO_MASK
    STR r3,[r1,r2]

    ;    PORTB19 as GPIO
    ;    Load r1 with PORTB_PCR_BASE address
    ;    Load r2 with PCR_BIT_OFFSET_19
    ;    Store into address (PORTB_PCR_BASE+PCR_BIT_OFFSET_19) the value of PORTx_PCRn_MUX_GPIO_MASK
    LDR r1,=PORTB_PCR_BASE
    LDR r2,=PCR_BIT_OFFSET_19
    LDR r3,=PORTx_PCRn_MUX_GPIO_MASK
    STR r3,[r1,r2]

    ;    PORTD13 as GPIO
    ;    Load r1 with PORTD_PCR_BASE address
    ;    Load r2 with PCR_BIT_OFFSET_13
    ;    Store into address (PORTD_PCR_BASE+PCR_BIT_OFFSET_13) the value of PORTx_PCRn_MUX_GPIO_MASK
    LDR r1,=PORTD_PCR_BASE
    LDR r2,=PCR_BIT_OFFSET_01
    LDR r3,=PORTx_PCRn_MUX_GPIO_MASK
    STR r3,[r1,r2]

    ; 3) Configure PORTB18, PORTB19 and PORTD13 as outputs
    ;    Load r1 with PORTB_GPIOx_BASE address
    ;    Load r2 with GPIOx_PDOR_OFFSET
    ;    Load r3 with mask for setting bit 18
    ;    Load r4 with mask for setting bit 19
    ;    OR (r3|r4) to set both bits 18 and 19
    ;    Store into address (PORTB_GPIOx_BASE+GPIOx_PDOR_OFFSET) with value for setting bits 18 and 19
    LDR r1,=PORTB_GPIOx_BASE
    LDR r2,=GPIOx_PDDR_OFFSET
    LDR r3,=SET_BIT_INDEX_18
    LDR r4,=SET_BIT_INDEX_19
    ORRS r3,r4,r3
    STR r3,[r1,r2]

    ;    Load r1 with PORTD_GPIOx_BASE address
    ;    Load r2 with GPIOx_PDOR_OFFSET
    ;    Load r3 with mask for setting bit 13
    ;    Store into address (PORTD_GPIOx_BASE+GPIOx_PDOR_OFFSET) with value for setting bit 13
    LDR r1,=PORTD_GPIOx_BASE
    LDR r2,=GPIOx_PDDR_OFFSET
    LDR r3,=SET_BIT_INDEX_01
    STR r3,[r1,r2]

    ; 4) Turn on RED LED
    ;    Load r1 with PORTB_GPIOx_BASE address
    ;    Load r2 with GPIOx_PDOR_OFFSET
    ;    Load r3 with mask for clearing bit 18
    ;    Store into address (PORTD_GPIOx_BASE+GPIOx_PDOR_OFFSET) with value for setting bit 18
    LDR r1,=PORTB_GPIOx_BASE
    LDR r2,=GPIOx_PDOR_OFFSET
    LDR r3,=CLEAR_BIT_INDEX_18
    ;LDR r4,=CLEAR_BIT_INDEX_19
    ;ANDS r3,r4,r3
    STR r3,[r1,r2]

    ;LDR r1,=PORTB_GPIOx_BASE
    ;LDR r2,=GPIOx_PDOR_OFFSET
    ;LDR r3,=CLEAR_BIT_INDEX_19
    ;STR r3,[r1,r2]

    LDR r1,=PORTD_GPIOx_BASE
    LDR r2,=GPIOx_PDOR_OFFSET
    LDR r3,=CLEAR_BIT_INDEX_01
    STR r3,[r1,r2]

loop
    B loop
  END
