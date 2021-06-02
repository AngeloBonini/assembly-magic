Arquivo .asm:
;--------------------------------------------------------------------------------------------------------------------------
#include <p16F873.inc>
CBLOCK 0x20
AUX
ENDC
ORG 0x00000
GOTO INICIO
;------------------
ORG 0x00004
MOVLW D'1'
MOVWF AUX
;-----------
BANKSEL PORTB
REPETE:
BSF PORTB,1
NOP
NOP
NOP
BCF PORTB,1
NOP
NOP
INCF AUX, 1
MOVF AUX,0
SUBLW D'11'
BTFSS STATUS,Z
GOTO REPETE
BCF INTCON,INTF
RETFIE
;----------------
INICIO:
BANKSEL OPTION_REG
BSF OPTION_REG,7;
BCF OPTION_REG,6;
BANKSEL INTCON
BSF INTCON,GIE;
BSF INTCON,INTE;
BANKSEL TRISB
MOVLW B'00000001'
MOVWF TRISBLP: NOP
NOP
NOP
NOP
GOTO LP
END
;----------------------------------------------------------------------------------------------------------------------
desenho do circuito: