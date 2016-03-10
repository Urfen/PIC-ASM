;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   28/01-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
porta       equ     0xf80
portc       equ     0xf82
trisa       equ     0xf92
trisc       equ     0xf94
status      equ     0xfd8
adcon1      equ     0xfc1

tmp_1       equ     0x00
tmp_2       equ     0x01
tmp_3       equ     0x02

;:::::::::::::::::::::::::::::::::::::::::::;
            org     0x00
            goto    init
;:::::::::::::::::::::::::::::::::::::::::::;
init
            movlw   0x00
            movwf   portc
            movwf   trisa
            movwf   trisc

            movlw   0x06
            movwf   adcon1
            setf    porta

;:::::::::::::::::::::::::::::::::::::::::::;
main
            call    sub_h
            call    sub_e
            call    sub_j

            goto    main
;:::::::::::::::::::::::::::::::::::::::::::;
sub_h
            setf    porta
            movlw   B'01110110'     ;=H
            movwf   portc
            bcf     porta,2
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_e
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,1
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_j
            setf    porta
            movlw   B'00011110'
            movwf   portc
            bcf     porta,0
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
wait
            movlw   0x02
            movwf   tmp_3
loop_3      movlw   0x01
            movwf   tmp_2
loop_2      movlw   0xff
            movwf   tmp_1
loop_1      decfsz  tmp_1,1
            goto    loop_1
            decfsz  tmp_2,1
            goto    loop_2
            decfsz  tmp_3,1
            goto    loop_3
            return
;:::::::::::::::::::::::::::::::::::::::::::;
            end


