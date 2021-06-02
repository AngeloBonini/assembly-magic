;;Angelo Bonini----------------
;; Porgramação do AD
#INCLUDE <P16F877A.INC>
__CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF &
_WRT_OFF & _CP_OFF
;---------------------------------------------------
RETARDO EQU
0X20
;Configuração do endereço 0x20 para ser
o delay
;----------------------------------------------
ORG
0X00
GOTO INICIO
; Vai para a rotina inicio
;-----------------------------------------------------------
CONVERSAO_ADC:
; configuração do ADCON0
BANKSEL ADCON0
MOVLW B'01001001'
MOVWF ADCON0
BANKSEL ADCON1
MOVLW B'10000000'
MOVWF ADCON1
inicia a conversão
MOVLW
D'200'
MOVWF
RETARDO
DELAY1:
RETARDO até que
seja 0
NOP
NOP
DECFSZ RETARDO,1
GOTO
DELAY1
NOP
NOP
BANKSEL ADCON0
BSF
ADCON0,2
WAD1:
BTFSC
ADCON0,2
GOTO
WAD1
;apos a configuração, se
;inicio do delay W = 200
; loop até que decrementa
; GoDone = 1, começa conversão
; conversão feita (BIT == 1)?
; se não, tenta novamente
BANKSEL ADRESH
MOVF
ADRESH,W
CALL
SEND_SERIAL ; Leitura dos 2 bits MSB
BANKSEL ADRESL
MOVF
ADRESL,W
CALL
SEND_SERIAL ; Leitura dos outros 8 bits
MOVLW
D'200'
MOVWF
RETARDO
DELAY2:
NOP
NOP
DECFSZ RETARDO,1
GOTO
DELAY2
NOP
NOP
; atribui 200 a w
; atribui w a RETARDO
; mesmo esquema do delay 1
RETURN
;--------------------------------------------------------------------------
SERIAL_ENTRY:
; Rotina de configuraÇÃo de entradaserial
9600bps
serial
BANKSEL TRISB
MOVLW
B'00000110'
MOVWF
TRISB ; W = B'00000110'
; TRISB = W
MOVLW
MOVWF ; W = 26
; SPBRG = 26 | Clock: 4MHz | BPS:
D'26'
SPBRG
BANKSEL RCSTA
MOVLW
B'10010000' ;Configuração do RCSTA para comunicação
MOVWF ; atribui W a RCSTA
RCSTA
RETURN
;-------------------------------------------------------------------------
VERIFICA_ENTRY:
; checagem da entrada de dados
seriais
BANKSEL RCREG
BTFSS
PIR1,RCIF
GOTO
LOOP
loop principal
MOVF
RCREG,W
retentor de recepção ;
;
CALL
de dados ; chama a rotina para converter os dados
CONVERSAO_ADC
checa recepção
enquanto não recebe byte, volta ao
; quando recebe byte tira o byte do
GOTO
LOOP
;---------------------------------------------------------------------------
SEND_SERIAL:
; envia os dados por comunicação serial
BANKSEL TXSTA
BTFSS
GOTO
esteja vazio
TXSTA,TRMT
SEND_SERIAL
; Seleciona o banco TXSTA
; checa o retentor de transmissão
; retorna a rotina até que o retentor
BANKSEL TXREG
MOVWF
TXREG
NOP
NOP
NOP
RETURN
;---------------------------------------------------------------------------
LOOP:
; loop principal
NOP
NOP
NOP
NOP
GOTO
VERIFICA_ENTRY
; Verifica entrada de dados
;---------------------------------------------------------------
INICIO:
; Rotina principal
BANKSEL TRISBEND
MOVLW
MOVWF B'00100110'
TXSTA
CALL SERIAL_ENTRY
GOTO LOOP
; atribui a W
; atribui W a TXSTA
; chama rotina de Configuração da entrada serial
; chama o loop