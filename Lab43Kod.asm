;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   11/02-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
#include    <P18f458.inc>

portc       equ         PORTC
trisc       equ         TRISC
portb       equ         PORTB
trisb       equ         TRISB
portd       equ         PORTD
trisd       equ         TRISD

var_1       equ         0x20
var_2       equ         0x21
tmp_1       equ         0x05
tmp_2       equ         0x06
tmp_3       equ         0x07
tmp2_1      equ         0x08
tmp2_2      equ         0x09
tmp2_3      equ         0x10

rs          equ         0x00
ett         equ         0x01
ascii       equ         0x02
ganger      equ         0x03

hundra      equ         0x26
hel         equ         0x23
tio         equ         0x24
tmp_hel     equ         0x27
tmp_tio     equ         0x28
tmp_hundra  equ         0x29
;:::::::::::::::::::::::::::::::::::::::::::;
            org         0x000
            goto        init
;:::::::::::::::::::::::::::::::::::::::::::;
            org         0x008
            goto        inter
;:::::::::::::::::::::::::::::::::::::::::::;
init
            movlw       0x07            ;Stänger av "comparetor" på portd
            movwf       CMCON

            clrf        trisc
            clrf        trisd

            setf        trisb

            bsf         INTCON,INT0IE
            bsf         INTCON,GIE      ;7

            call        LCDinit

            movlw       B'10101010'
            movwf       portc

            movlw       B'00000001'
            movwf       hel
            movwf       tio
            movwf       hundra
;:::::::::::::::::::::::::::::::::::::::::::;
main
            comf        portc,1
            ;call        wait3
            goto        main
;:::::::::::::::::::::::::::::::::::::::::::;
inter
            call        clear_disp
            incf        hel,1
            call        fixaantal
            call        plocka_tecken
            call        plocka_antal
            ;call        wait2
            ;call        clear_disp
            bcf         INTCON,INT0IF
            retfie
;:::::::::::::::::::::::::::::::::::::::::::;
fixaantal
            movlw       0x0b
            xorwf       hel,0
            bnz         if1
            incf        tio,1
            movlw       B'00000001'
            movwf       hel
if1
            movlw       0x0b
            xorwf       tio,0
            bnz         if2
            incf        hundra,1
            movlw       B'00000001'
            movwf       tio
if2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
plocka_antal
            movff       hel,tmp_hel
            movff       tio,tmp_tio
            movff       hundra,tmp_hundra

            movlw       upper(mina_antal)
            movwf       TBLPTRU
            movlw       high(mina_antal)
            movwf       TBLPTRH
            movlw       low(mina_antal)
            movwf       TBLPTRL
hit_hundra
            TBLRD*+
            decfsz      tmp_hundra,1
            goto        hit_hundra

            TBLRD*+
            movf        TABLAT,0
            call        visa_LCD

            movlw       upper(mina_antal)
            movwf       TBLPTRU
            movlw       high(mina_antal)
            movwf       TBLPTRH
            movlw       low(mina_antal)
            movwf       TBLPTRL
hit_tio
            TBLRD*+
            decfsz      tmp_tio,1
            goto        hit_tio

            TBLRD*+
            movf        TABLAT,0
            call        visa_LCD

            movlw       upper(mina_antal)
            movwf       TBLPTRU
            movlw       high(mina_antal)
            movwf       TBLPTRH
            movlw       low(mina_antal)
            movwf       TBLPTRL
hit_hel
            TBLRD*+
            decfsz      tmp_hel,1
            goto        hit_hel

            TBLRD*+
            movf        TABLAT,0
            call        visa_LCD

            return
;:::::::::::::::::::::::::::::::::::::::::::;
plocka_tecken
            movlw       upper(min_text)
            movwf       TBLPTRU
            movlw       high(min_text)
            movwf       TBLPTRH
            movlw       low(min_text)
            movwf       TBLPTRL
next
            TBLRD*+
            movf        TABLAT,0
            iorlw       0x00
            bz          null
            call        visa_LCD
            goto        next
null
            return
;:::::::::::::::::::::::::::::::::::::::::::;
visa_LCD
            movwf       ascii
            andlw       0xf0
            movwf       portd
            bsf         portd,0
            call        enable
            swapf       ascii,0
            andwf       0xf0
            movwf       portd
            bsf         portd,0
            call        enable
            return
;:::::::::::::::::::::::::::::::::::::::::::;
waitms
            movlw       0x0a
            movwf       var_2
loop_2
            movlw       0x64
            movwf       var_1
loop_1
            decfsz      var_1,1
            goto        loop_1
            decfsz      var_2,1
            goto        loop_2
            return
;:::::::::::::::::::::::::::::::::::::::::::;
wait3
            movlw   0x02
            movwf   tmp2_3
loop_3xx    movlw   0xff
            movwf   tmp2_2
loop_2xx    movlw   0xff
            movwf   tmp2_1
loop_1xx    decfsz  tmp2_1,1
            goto    loop_1xx
            decfsz  tmp2_2,1
            goto    loop_2xx
            decfsz  tmp2_3,1
            goto    loop_3xx
            return
;:::::::::::::::::::::::::::::::::::::::::::;
wait2
            movlw   0x05
            movwf   tmp_3
loop_3x     movlw   0xff
            movwf   tmp_2
loop_2x     movlw   0xff
            movwf   tmp_1
loop_1x     decfsz  tmp_1,1
            goto    loop_1x
            decfsz  tmp_2,1
            goto    loop_2x
            decfsz  tmp_3,1
            goto    loop_3x
            return
;:::::::::::::::::::::::::::::::::::::::::::;
enable
            bsf         portd,ett           ;Skickar en negativ flank till LCD:n så den uppdaterad
            call        waitms
            bcf         portd,ett
            return
;:::::::::::::::::::::::::::::::::::::::::::;
clear_disp
            movlw       0x00            ;Clear display
            movwf       portd           ;0 för att detta är en instruktion till displayen
            call        enable
            movlw       0x10
            movwf       portd
            call        enable
            call        waitms
            return
;:::::::::::::::::::::::::::::::::::::::::::;
LCDinit
            movlw       0xff                ;ff för att vänta minst 15ms
            movwf       ganger
LCD
loop_3
            call        waitms
            decfsz      ganger,1
            goto        loop_3
            movlw       0x30
            movwf       portd
            call        enable
            movlw       0x05                ;05 för att vänta minst 4ms
            movwf       ganger
loop_4
            call        waitms
            decfsz      ganger,1
            goto        loop_4

            movlw       0x30
            movwf       portd
            call        enable

            call        waitms              ;nog med bara en wait för 8um

            movlw       0x30
            movwf       portd
            call        enable
            call        waitms

            movlw       0x20
            movwf       portd
            call        enable
            call        waitms

;*******************************************;
            movlw       0x20            ;
            movwf       portd           ;0 för att detta är en instruktion till displayen
            call        enable
            movlw       0x80
            movwf       portd
            call        enable
            call        waitms
;*******************************************;
            movlw       0x00
            movwf       portd           ;0 för att detta är en instruktion till displayen
            call        enable
            movlw       0x10
            movwf       portd
            call        enable
            call        waitms
;*******************************************;
            movlw       0x00
            movwf       portd           ;0 för att detta är en instruktion till displayen
            call        enable
            movlw       0x60
            movwf       portd
            call        enable
            call        waitms
;*******************************************;
            movlw       0x00
            movwf       portd           ;0 för att detta är en instruktion till displayen
            call        enable
            movlw       0xe0
            movwf       portd
            call        enable
            call        waitms
            return
;:::::::::::::::::::::::::::::::::::::::::::;
min_text    db          "Avbrott: ",0
mina_antal  db          "00123456789",0
;:::::::::::::::::::::::::::::::::::::::::::;
            end