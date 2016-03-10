;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   11/02-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
#include    <P18f458.inc>

portd       equ      PORTD
trisd       equ      0xf95
trisc       equ      0xf94
var_1       equ      0x20
var_2       equ      0x21
rs          equ      0x00
ett         equ      0x01
ascii       equ      0x02
ganger      equ      0x03
;:::::::::::::::::::::::::::::::::::::::::::;
            org     0x00
            goto    init
;:::::::::::::::::::::::::::::::::::::::::::;
init
            movlw       0x07            ;Stänger av "comparetor" på portd
            movwf       CMCON
            movlw       0x00
            movwf       portd
            movwf       trisd
;:::::::::::::::::::::::::::::::::::::::::::;
main
            call        LCDinit
            call        plockatecken
klar        goto        klar
;:::::::::::::::::::::::::::::::::::::::::::;
plockatecken
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
enable
            bsf         portd,ett           ;Skickar en negativ flank till LCD:n så den uppdaterad
            call        waitms
            bcf         portd,ett
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
min_text    db          "Arvid > Fredrik",0
;:::::::::::::::::::::::::::::::::::::::::::;
            end


