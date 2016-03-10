;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   25/02-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
#include    <P18f458.inc>

portb       equ     PORTB
portc       equ     PORTC
trisb       equ     TRISB
trisc       equ     TRISC
porta       equ     PORTA
trisa       equ     TRISA

tgb         equ     0x00
tmp_tgb     equ     0x03

tmp_1       equ     0x01
tmp_2       equ     0x02

fler        equ     0x20
;:::::::::::::::::::::::::::::::::::::::::::;
            org     0x00
            goto    init
;:::::::::::::::::::::::::::::::::::::::::::;
            org     0x08
            goto    intr
;:::::::::::::::::::::::::::::::::::::::::::;
init
            clrf    portb
            setf    portc
            
            bcf     INTCON2,7

            movlw   b'11110000'
            movwf   trisb

            clrf    trisc
            clrf    trisa

            movlw   0x06
            movwf   ADCON1
            setf    porta
            bcf     porta,0

            bsf     INTCON,3
            bsf     INTCON,7
;:::::::::::::::::::::::::::::::::::::::::::;
main
            goto    main
;:::::::::::::::::::::::::::::::::::::::::::;
intr
            call    waitms

            movf    portb,0
            andlw   0xf0
            movwf   tgb

            movlw   b'00000111'
            movwf   trisb
            nop
            nop
            nop

            movf    portb,0
            andlw   b'00000111'

            iorwf   tgb,1
            bsf     tgb,3
            comf    tgb,1
;***test för flera knappar
            clrf    fler
            btfsc   tgb,0
            incf    fler,1
            btfsc   tgb,1
            incf    fler,1
            btfsc   tgb,2
            incf    fler,1

            btfsc   fler,1
            goto    fel
;***

            btfsc   tgb,0
            goto    col_1
            btfsc   tgb,1
            goto    col_2
            btfsc   tgb,2
            goto    col_3

            goto fel

col_1
            btfsc   tgb,4
            goto    col_1_1
            btfsc   tgb,5
            goto    col_1_2
            btfsc   tgb,6
            goto    col_1_3
            btfsc   tgb,7
            goto    col_1_4
col_1_1
            movlw   0x06
            goto    hit
col_1_2
            movlw   0x66
            goto    hit
col_1_3
            movlw   0x07
            goto    hit
col_1_4
            movlw   0x49
            goto    hit
col_2
            btfsc   tgb,4
            goto    col_2_1
            btfsc   tgb,5
            goto    col_2_2
            btfsc   tgb,6
            goto    col_2_3
            btfsc   tgb,7
            goto    col_2_4
col_2_1
            movlw   0x5b
            goto    hit
col_2_2
            movlw   0x6d
            goto    hit
col_2_3
            movlw   0x7f
            goto    hit
col_2_4
            movlw   0x3f
            goto    hit
col_3
            btfsc   tgb,4
            goto    col_3_1
            btfsc   tgb,5
            goto    col_3_2
            btfsc   tgb,6
            goto    col_3_3
            btfsc   tgb,7
            goto    col_3_4
col_3_1
            movlw   0x4f
            goto    hit
col_3_2
            movlw   0x7d
            goto    hit
col_3_3
            movlw   0x6f
            goto    hit
col_3_4
            movlw   0x5c
            goto    hit
hit
            movwf   portc
fel
            clrf    portb
            movlw   b'11110000'
            movwf   trisb
            call    waitms
keyup
            movf    portb,0
            andlw   0xf0
            sublw   0xf0
            btfss   STATUS,2
            goto    keyup

            call    waitms
            bcf     INTCON,RBIF
            retfie
;:::::::::::::::::::::::::::::::::::::::::::;
waitms
            movlw   0x0a
            movwf   tmp_2
loop_2
            movlw   0x64
            movwf   tmp_1
loop_1
            decfsz  tmp_1,1
            goto    loop_1
            decfsz  tmp_2,1
            goto    loop_2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
            end