;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   26/02-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
#include    <P18f458.inc>

portb       equ         PORTB
trisb       equ         TRISB
portd       equ         PORTD
trisd       equ         TRISD

trisc       equ         TRISC
portc       equ         PORTC

tgb         equ         0x00
tmp_tgb     equ         0x03
tmp_1       equ         0x05
tmp_2       equ         0x02
ett         equ         0x01
ganger      equ         0x04
fler        equ         0x06
ascii       equ         0x07
;:::::::::::::::::::::::::::::::::::::::::::;
            org         0x00
            goto        init
;:::::::::::::::::::::::::::::::::::::::::::;
            org         0x08
            goto        intr
;:::::::::::::::::::::::::::::::::::::::::::;
init
            clrf        trisc
            clrf        portb
            movlw       0x07            ;Stänger av "comparetor" på portd
            movwf       CMCON
            clrf        trisd
            call        LCDinit

            bcf         INTCON2,7
            movlw       b'11110000'
            movwf       trisb
            bsf         INTCON,3
            bsf         INTCON,7
;:::::::::::::::::::::::::::::::::::::::::::;
main
            goto        main
;:::::::::::::::::::::::::::::::::::::::::::;
intr
            call        waitms
            movf        portb,0
            andlw       0xf0
            movwf       tgb
            movlw       b'00000111'
            movwf       trisb
            nop
            nop
            nop
            movf        portb,0
            andlw       b'00000111'
            iorwf       tgb,1
            bsf         tgb,3
            comf        tgb,1

            movff       tgb,portc
            swapf       portc

            clrf        fler                ;tester för >1 knappar tryckta
            btfsc       tgb,0
            incf        fler,1
            btfsc       tgb,1
            incf        fler,1
            btfsc       tgb,2
            incf        fler,1
            btfsc       fler,1
            goto        fel

            btfsc       tgb,0
            goto        col_1
            btfsc       tgb,1
            goto        col_2
            btfsc       tgb,2
            goto        col_3
            goto        fel

col_1
            movlw       upper(kod_1)
            movwf       TBLPTRU
            movlw       high(kod_1)
            movwf       TBLPTRH
            movlw       low(kod_1)
            movwf       TBLPTRL
            bra         hitta_rad
col_2
            movlw       upper(kod_2)
            movwf       TBLPTRU
            movlw       high(kod_2)
            movwf       TBLPTRH
            movlw       low(kod_2)
            movwf       TBLPTRL
            bra         hitta_rad
col_3
            movlw       upper(kod_3)
            movwf       TBLPTRU
            movlw       high(kod_3)
            movwf       TBLPTRH
            movlw       low(kod_3)
            movwf       TBLPTRL
            bra         hitta_rad

hitta_rad
            ;call        clear_disp
            TBLRD*+
            btfsc       tgb,4
            goto        visa
            TBLRD*+
            btfsc       tgb,5
            goto        visa
            TBLRD*+
            btfsc       tgb,6
            goto        visa
            TBLRD*+
            btfsc       tgb,7
            goto        visa
visa
            movf        TABLAT,0
            call        visa_LCD

            movlw       b'10000001'         ;om stjärna clear disp
            cpfseq      tgb
            bra         fel
            call        clear_disp
fel
            clrf        portb
            movlw       b'11110000'
            movwf       trisb
            call        waitms
keyup
            movf        portb,0
            andlw       0xf0
            sublw       0xf0
            btfss       STATUS,2
            goto        keyup

            call        waitms
            bcf         INTCON,RBIF
            retfie
;:::::::::::::::::::::::::::::::::::::::::::;
waitms
            movlw       0x0a
            movwf       tmp_2
loop_2
            movlw       0x64
            movwf       tmp_1
loop_1
            decfsz      tmp_1,1
            goto        loop_1
            decfsz      tmp_2,1
            goto        loop_2
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
kod_1       db      "147*"
kod_2       db      "2580"
kod_3       db      "369#"
            end