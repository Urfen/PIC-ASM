;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   28/01-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
portc      equ     0xf82
trisc      equ     0xf94
status     equ     0xfd8

tmp_1       equ     0x00
tmp_2       equ     0x01
tmp_3       equ     0x02
fram        equ     0x03
vand        equ     0x04
lampa       equ     0x05
;:::::::::::::::::::::::::::::::::::::::::::;
            org     0x00
            goto    init
;:::::::::::::::::::::::::::::::::::::::::::;
init
            movlw   0x00
            movwf   portc
            movwf   trisc
            setf    portc

            movlw   0xff
            movwf   fram
            movlw   0x01
            movwf   lampa
;:::::::::::::::::::::::::::::::::::::::::::;
main
            call    wait
            
            movlw   0x80       
            subwf   lampa,0
            movlw   0x00
            btfsc   status,2
            movwf   fram

            movlw   0x01       
            subwf   lampa,0
            movlw   0xff
            btfsc   status,2
            movwf   fram

            movlw   0xff       
            subwf   fram,0
            btfsc   status,2
            call    flytta_fram

            movlw   0x00      
            subwf   fram,0
            btfsc   status,2   
            call    flytta_bak

            goto    main
;:::::::::::::::::::::::::::::::::::::::::::;
flytta_fram
            rlncf   lampa
            movf    lampa,0
            movwf   portc
            comf    portc,1
            swapf   portc,1
            return
;:::::::::::::::::::::::::::::::::::::::::::;
flytta_bak
            rrncf   lampa
            movf    lampa,0
            movwf   portc
            comf    portc,1
            swapf   portc,1
            return
;:::::::::::::::::::::::::::::::::::::::::::;

wait
            movlw   0x01
            movwf   tmp_3
loop_3      movlw   0xf0
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