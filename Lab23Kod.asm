;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   03/02-14          ;
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
tmp_h       equ     0x03
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

            movlw   0xff
            movwf   tmp_h
;:::::::::::::::::::::::::::::::::::::::::::;
main
            call    slide_h
            call    slide_e
            call    slide_j
            call    fyll_pa
            call    visa_alla
            call    flytta_alla_v
            call    flytt_ut_h
            call    fade_j
            setf    porta
            goto    main
;:::::::::::::::::::::::::::::::::::::::::::;
fyll_pa
            movlw   0xff
            movwf   tmp_h
            return
;:::::::::::::::::::::::::::::::::::::::::::;
fade_j
            setf    porta
            movlw   B'00011110'
            movwf   portc
            bcf     porta,0
            call    wait
            decf    tmp_h,1
            bnz     fade_j
            call    fyll_pa
            call    fade_j2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
fade_j2
            bcf     portc,1
            call    wait
            decf    tmp_h,1
            bnz     fade_j2
            call    fyll_pa
            call    fade_j3
            return
;:::::::::::::::::::::::::::::::::::::::::::;
fade_j3
            bcf     portc,2
            call    wait
            decf    tmp_h,1
            bnz     fade_j3
            call    fyll_pa
            call    fade_j4
            return
;:::::::::::::::::::::::::::::::::::::::::::;
fade_j4
            bcf     portc,4
            call    wait
            decf    tmp_h,1
            bnz     fade_j4
            call    fyll_pa
            call    fade_j5
            return
;:::::::::::::::::::::::::::::::::::::::::::;
fade_j5
            bcf     portc,5
            call    wait
            decf    tmp_h,1
            bnz     fade_j5
            call    fyll_pa
            return
;:::::::::::::::::::::::::::::::::::::::::::;







;:::::::::::::::::::::::::::::::::::::::::::;
flytt_ut_h
            setf    porta
            movlw   B'00000110'
            movwf   portc
            bcf     porta,3
            call    wait
            setf    porta
            movlw   B'00110110'
            movwf   portc
            bcf     porta,2
            call    wait
            call    sub_j_1
            decf    tmp_h,1
            bnz     flytt_ut_h
            call    fyll_pa
            call    flytt_ut_h2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
flytt_ut_h2
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,3
            call    wait
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,2
            call    wait
            call    sub_j_1
            decf    tmp_h,1
            bnz     flytt_ut_h2
            call    fyll_pa
            call    flytt_ut_h3
            return
;:::::::::::::::::::::::::::::::::::::::::::;
flytt_ut_h3
            setf    porta
            movlw   B'00110110'
            movwf   portc
            bcf     porta,3
            call    wait
            call    sub_j_1
            decf    tmp_h,1
            bnz     flytt_ut_h3
            call    fyll_pa
            call    flytt_ut_h4
            return
;:::::::::::::::::::::::::::::::::::::::::::;
flytt_ut_h4
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,3
            call    wait
            call    sub_j_1
            decf    tmp_h,1
            bnz     flytt_ut_h4
            call    fyll_pa
            return
;:::::::::::::::::::::::::::::::::::::::::::;









;:::::::::::::::::::::::::::::::::::::::::::;
flytta_alla_v
            call    sub_h_1
            call    sub_e_1
            call    sub_j_1
            decf    tmp_h,1
            bnz     flytta_alla_v
            call    fyll_pa
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_h_1
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,2
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_e_1
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,1
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_j_1
            setf    porta
            movlw   B'00011110'
            movwf   portc
            bcf     porta,0
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;











;:::::::::::::::::::::::::::::::::::::::::::;
slide_h

            setf    porta
            movlw   B'00000110'
            movwf   portc
            bcf     porta,0
            call    wait
            decf    tmp_h,1
            bnz     slide_h
            movlw   0xff
            movwf   tmp_h
            call    slide_h_2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_2
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,0
            call    wait
            decf    tmp_h,1
            bnz     slide_h_2
            movlw   0xff
            movwf   tmp_h
            call    slide_h_3
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_3
            setf    porta
            movlw   B'00110000'
            movwf   portc
            bcf     porta,0
            call    wait
            setf    porta
            movlw   B'000000110'
            movwf   portc
            bcf     porta,1
            call    wait
            decf    tmp_h,1
            bnz     slide_h_3
            movlw   0xff
            movwf   tmp_h
            call    slide_h_4
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_4
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,1
            call    wait
            decf    tmp_h,1
            bnz     slide_h_4
            movlw   0xff
            movwf   tmp_h
            call    slide_h_5
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_5
            setf    porta
            movlw   B'00110000'
            movwf   portc
            bcf     porta,1
            call    wait
            setf    porta
            movlw   B'000000110'
            movwf   portc
            bcf     porta,2
            call    wait
            decf    tmp_h,1
            bnz     slide_h_5
            movlw   0xff
            movwf   tmp_h
            call    slide_h_6
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_6
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,2
            call    wait
            decf    tmp_h,1
            bnz     slide_h_6
            movlw   0xff
            movwf   tmp_h
            call    slide_h_7
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_7
            setf    porta
            movlw   B'00110000'
            movwf   portc
            bcf     porta,2
            call    wait
            setf    porta
            movlw   B'000000110'
            movwf   portc
            bcf     porta,3
            call    wait
            decf    tmp_h,1
            bnz     slide_h_7
            movlw   0xff
            movwf   tmp_h
            call    slide_h_8
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_h_8
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,3
            call    wait
            decf    tmp_h,1
            bnz     slide_h_8
            movlw   0xf0
            movwf   tmp_h
            return
;:::::::::::::::::::::::::::::::::::::::::::;
visa_h
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,3
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;











;:::::::::::::::::::::::::::::::::::::::::::;
slide_e
            setf    porta
            movlw   B'00000110'
            movwf   portc
            bcf     porta,0
            call    wait
            call    visa_h
            decf    tmp_h,1
            bnz     slide_e
            movlw   0x90
            movwf   tmp_h
            call    slide_e_2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_e_2
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,0
            call    wait
            call    visa_h
            decf    tmp_h,1
            bnz     slide_e_2
            movlw   0x90
            movwf   tmp_h
            call    slide_e_3
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_e_3
            setf    porta
            movlw   B'00000110'
            movwf   portc
            bcf     porta,1
            call    wait
            call    visa_h
            decf    tmp_h,1
            bnz     slide_e_3
            movlw   0x90
            movwf   tmp_h
            call    slide_e_4
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_e_4
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,1
            call    wait
            call    visa_h
            decf    tmp_h,1
            bnz     slide_e_4
            movlw   0x90
            movwf   tmp_h
            call    slide_e_5
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_e_5
            setf    porta
            movlw   B'00000110'
            movwf   portc
            bcf     porta,2
            call    wait
            call    visa_h
            decf    tmp_h,1
            bnz     slide_e_5
            movlw   0x90
            movwf   tmp_h
            call    slide_e_6
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_e_6
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,2
            call    wait
            call    visa_h
            decf    tmp_h,1
            bnz     slide_e_6
            movlw   0x90
            movwf   tmp_h
            return
;:::::::::::::::::::::::::::::::::::::::::::;
visa_e
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,2
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;












;:::::::::::::::::::::::::::::::::::::::::::;
slide_j
            setf    porta
            movlw   B'00000100'
            movwf   portc
            bcf     porta,0
            call    wait
            call    visa_h
            call    visa_e
            decf    tmp_h,1
            bnz     slide_j
            movlw   0x30
            movwf   tmp_h
            call    slide_j_2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_j_2
            setf    porta
            movlw   B'00011110'
            movwf   portc
            bcf     porta,0
            call    wait
            call    visa_h
            call    visa_e
            decf    tmp_h,1
            bnz     slide_j_2
            movlw   0x30
            movwf   tmp_h
            call    slide_j_3
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_j_3
            setf    porta
            movlw   B'00110000'
            movwf   portc
            bcf     porta,0
            call    wait
            setf    porta
            movlw   B'000000100'
            movwf   portc
            bcf     porta,1
            call    wait
            call    visa_h
            call    visa_e
            decf    tmp_h,1
            bnz     slide_j_3
            movlw   0x30
            movwf   tmp_h
            call    slide_j_4
            return
;:::::::::::::::::::::::::::::::::::::::::::;
slide_j_4
            setf    porta
            movlw   B'00011110'
            movwf   portc
            bcf     porta,1
            call    wait
            call    visa_h
            call    visa_e
            decf    tmp_h,1
            bnz     slide_j_4
            movlw   0x30
            movwf   tmp_h
            return
;:::::::::::::::::::::::::::::::::::::::::::;










;:::::::::::::::::::::::::::::::::::::::::::;
visa_alla
            call    sub_h
            call    sub_e
            call    sub_j
            decf    tmp_h
            bnz     visa_alla
            call    fyll_pa
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_h
            setf    porta
            movlw   B'01110110'
            movwf   portc
            bcf     porta,3
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_e
            setf    porta
            movlw   B'01111001'
            movwf   portc
            bcf     porta,2
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;
sub_j
            setf    porta
            movlw   B'00011110'
            movwf   portc
            bcf     porta,1
            call    wait
            return
;:::::::::::::::::::::::::::::::::::::::::::;











;:::::::::::::::::::::::::::::::::::::::::::;
wait2
            movlw   0x04
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
