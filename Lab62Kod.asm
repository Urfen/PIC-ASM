;:::::::::::::::::::::::::::::::::::::::::::;
;         Arvid   Bodin   26/02-14          ;
;:::::::::::::::::::::::::::::::::::::::::::;
;list p=18F458
#include p18F458.inc
;:::::::::::::::::::::::::::::::::::::::::::;

ASCI        EQU         0X30                ;ASCI FÅR ADRESS 30
ett         EQU         0X01
ganger      EQU         0X32

var_1       equ         0x20
var_2       equ         0x21

tmp2_1      equ         0x08
tmp2_2      equ         0x09
tmp2_3      equ         0x10
portd       EQU         PORTD
porta       EQU         PORTA
portb       EQU         PORTB
TECKEN      EQU         0X02
FULLDISP    EQU         0X07
FULL        EQU         0X03
lampa       EQU         0x04
tmp_lampa   EQU         0x06
fram        EQU         0x05
;:::::::::::::::::::::::::::::::::::::::::::;
            ORG         0X00
            GOTO        INIT
;:::::::::::::::::::::::::::::::::::::::::::;
            ORG         0X08
            GOTO        AVBROTT
;:::::::::::::::::::::::::::::::::::::::::::;
AVBROTT
            MOVF        RCREG,0
            MOVWF       ASCI

            DECFSZ      TECKEN,1
            BRA         INTE_RAD
            CALL        NÄSTA_RAD
INTE_RAD
            DECFSZ      FULLDISP,1
            BRA         INTE_FULL
            CALL        clear_disp
            movlw       0x10
            movwf       TECKEN
            movlw       0x20
            movwf       FULLDISP
INTE_FULL

            CALL        VISALCD
            RETFIE
;:::::::::::::::::::::::::::::::::::::::::::;
NÄSTA_RAD
            movlw       B'11000000'
            movwf       portd         
            call        enable
            movlw       B'00000000'
            movwf       portd
            call        enable
            call        waitms
            return
;:::::::::::::::::::::::::::::::::::::::::::;
INIT
            MOVLW       0X11
            MOVWF       TECKEN
            MOVLW       0X21
            MOVWF       FULLDISP
            movlw       0xff
            movwf       fram
            movlw       0x01
            movwf       lampa

            movlw       0x07          ;Stänger av "comparetor" på portd
            movwf       CMCON
            clrf        TRISD

            MOVLW       0XFF
            MOVWF       PORTA
            MOVWF       PORTB
            MOVWF       PORTC
            MOVLW       0X00
            MOVWF       TRISA
            MOVWF       TRISB

            Movwf       TRISC

            MOVLW       0X06
            MOVWF       ADCON1
            MOVLW       B'10000000'        
            MOVWF       TRISC
;:::::::::::::::::::::::::::::::::::::::::::;

            MOVLW       B'10010000'
            MOVWF       RCSTA

            MOVLW       B'00100110'
            MOVWF       TXSTA

            MOVLW       0X4D                ;77
            MOVWF       SPBRG
;:::::::::::::::::::::::::::::::::::::::::::;
            MOVLW       B'00100000'
            MOVWF       PIE1

            MOVLW       B'11000000'
            MOVWF       INTCON

;:::::::::::::::::::::::::::::::::::::::::::;

MAIN
            CALL        LCDinit
SLUT        
            call    WAIT3

            movlw   0x80
            subwf   lampa,0
            movlw   0x00
            btfsc   STATUS,2
            movwf   fram

            movlw   0x01
            subwf   lampa,0
            movlw   0xff
            btfsc   STATUS,2
            movwf   fram

            movlw   0xff
            subwf   fram,0
            btfsc   STATUS,2
            call    flytta_fram

            movlw   0x00
            subwf   fram,0
            btfsc   STATUS,2
            call    flytta_bak

            GOTO        SLUT

;:::::::::::::::::::::::::::::::::::::::::::;
flytta_fram
            rlncf   lampa
            movff   lampa,tmp_lampa
            swapf   tmp_lampa,1
            comf    tmp_lampa,0
            movwf   porta
            movwf   portb
            return
;:::::::::::::::::::::::::::::::::::::::::::;
flytta_bak
            rrncf   lampa
            movff   lampa,tmp_lampa
            swapf   tmp_lampa,1
            comf    tmp_lampa,0
            movwf   porta
            movwf   portb
            return
;:::::::::::::::::::::::::::::::::::::::::::;

VISALCD

            MOVF        ASCI,0
            andlw       0xf0
            movwf       portd
            bsf         portd,0
            call        enable
            swapf       ASCI,0
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
WAIT3
            movlw   0x01
            movwf   tmp2_3
loop_3xx    movlw   0xf0
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
            END