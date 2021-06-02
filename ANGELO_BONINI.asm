; Comunicação Serial------------------------------------
; Angelo Monte Serrat Bonini---------------------------			     			 

#include <p16f628a.inc>

__CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _HS_OSC


		CONTADOR		EQU		0x20

		ORG 0x0000
		GOTO INICIO ;DIRECIONA PARA A ROTINA INICIO
; MOSTRA O NUMERO DO CONTADOR NO DISPLAY-----------------
ATUALIZA:
		
			BANKSEL PORTB
			
			;PARA TODOS OS NUMEROS, OCORRE O SEGUINTE PROCEDIMENTO:
			;O VALOR DO CONTADOR VAI PARA O W
			;O VALOR EM D É SUBTRAIDO
			; USANDO Z, VERIFICA SE O RESULTADO BATE COM O NUMERO
			;SENDO VERDADEIRO, COLOCA O NUMERO NO DISPLAY 

			MOVF CONTADOR, W 
			SUBLW D'0'			
			BTFSC STATUS, Z		
			GOTO ZERO 
			NOP
			NOP
;------------------------------------------
			MOVF CONTADOR, W 
			SUBLW D'1'			 
			BTFSC STATUS, Z		 
			GOTO UM 
			NOP
			NOP
;´-----------------------------------------
			MOVF CONTADOR, W
			SUBLW D'2'			 
			BTFSC STATUS, Z		  
			GOTO DOIS 
			NOP
			NOP
;--------------------------------------------
			MOVF CONTADOR, W 
			SUBLW D'3'			  
			BTFSC STATUS, Z		 
			GOTO TRES  
			NOP
			NOP
;-------------------------------
			MOVF CONTADOR, W 
			SUBLW D'4'			 
			BTFSC STATUS, Z		  
			GOTO QUATRO  
			NOP
			NOP
;---------------------------------------------
			MOVF CONTADOR, W 
			SUBLW D'5'			  
			BTFSC STATUS, Z		  
			GOTO CINCO  
			NOP
			NOP
;-------------------------------------------
			MOVF CONTADOR, W 
			SUBLW D'6'			
			BTFSC STATUS, Z		 
			GOTO SEIS 
			NOP
			NOP
;------------------------------------------
			MOVF CONTADOR, W 
			SUBLW D'7'			
			BTFSC STATUS, Z		 
			GOTO SETE 
			NOP
			NOP
;--------------------------------------
			MOVF CONTADOR, W
			SUBLW D'8'			  
			BTFSC STATUS, Z		 
			GOTO OITO 
			NOP
			NOP			
;--------------------------------------------
			MOVF CONTADOR, W 
			SUBLW D'9'			 
			BTFSC STATUS, Z		 
			GOTO NOVE  
			NOP
			NOP
;----------------------------------------------
			;SE O NUMERO NÃO ESTÁ ENTRE 0 E 9, MOVE O VALOR 255 PARA O W			
			MOVLW D'255' 		  

ENVIA:
			BANKSEL TXSTA
			BTFSS TXSTA, TRMT 	  
			GOTO ENVIA 		 ; LOOP PARA VER SE TXSTA ESTA VAZIO
			NOP
			NOP
			BANKSEL TXREG		 
			MOVWF TXREG 		 
			
			GOTO RECEBE 	 ;VAI PARA RECEBER OS DADOS
;--------------------------------------------------------------
; CADA FUNÇÃO ATIVA UM NUMERO NO DISPLAY DE SETE SEGMENTOS
; MOVENDO UM NUMERO EM BINÁRIO, DE ACORDO COM O DECIMAL CORRESPONDENTE, PARA PORTB

ZERO:
						 MOVLW B'11111110'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA	
		
UM:
						 MOVLW B'00111000'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA	 

DOIS:
						 MOVLW B'11011101'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		

TRES:
						 MOVLW B'01111101'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		

QUATRO:
						 MOVLW B'00111011'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		

CINCO:
						 MOVLW B'01110111'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		

SEIS:
						 MOVLW B'11110011'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		

SETE:
						 MOVLW B'00111100'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		 

OITO:
						 MOVLW B'11111111'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		

NOVE:
						 MOVLW B'00111111'
						 MOVWF PORTB
						 MOVF CONTADOR, W
						 GOTO ENVIA		
						 
FINAL_CONTAGEM:	RETURN
		
;----------------------------------------------------------------------
		
			; CONFIGURA OS REGISTRADORES TRISB, RCSTA E SPBRG PARA COMUNICAÇÃO SERIAL
			;-------------------------------------------------------------
SERIAL:
						 BANKSEL TRISB
						 MOVLW B'00000110' ;RB1 E RB2  
						 MOVWF TRISB

						 BANKSEL RCSTA
						 MOVLW B'10010000' ;CONFIGURA O RCSTA PARA COMUNICAÇÃO SERIAL
						 MOVWF RCSTA
			 			 
						 BANKSEL SPBRG
						 MOVLW D'129' 		;CONFIGURA O SPBG PARA ALTA VELOCIDADE
						 MOVWF SPBRG

						 RETURN
			;-------------------------------------------------------------
			; CONFIGURA TRISB PARA O DISPLAY
			;SETA TODAS AS SAIDAS DO DISPLAY
			
TRISB_DISPLAY:
						 BANKSEL TRISB
						 MOVLW B'00000000' 
						 MOVWF TRISB
						 RETURN
			;-------------------------------------------------------------
			; CONFIGURA INICIALMENTE PORTB E ZERA O CONTADOR 
			
INICIAL_PORTB:
						 BANKSEL PORTB
						 MOVLW B'11111110'
						 MOVWF PORTB
						 
						 CLRF CONTADOR		
						 RETURN
			;-------------------------------------------------------------

INICIO:
					CALL TRISB_DISPLAY	;CHAMA TRISB 
					CALL INICIAL_PORTB	;CHAMA CONFIGURAÇÃO INICIAL DE PORTB
					
				
			             BANKSEL INTCON     ;CONFIGURA O  INTCON
						 MOVLW B'10100000'
						 MOVWF INTCON
						 
					CALL SERIAL	;CHAMANDO A SUBROTINA DE COMUNICAÇÃO SERIAL
			
						 BANKSEL TXSTA    ;SETA O TXSTA PARA COMUNICAÇÃO SERIAL
						 MOVLW B'00100110'
						 MOVWF TXSTA
						 
						;CONFIGURA PIE1 PARA COMUNICAÇÃO SERIAL
						 BANKSEL PIE1
						 MOVLW B'00110000'
						 MOVWF PIE1
					
					   ;CONFIGURA PIR1 PARA COMUNICAÇÃO SERIAL
					     BANKSEL PIR1
						 MOVLW B'00000000'
						 MOVWF PIR1
					
RECEBE:
					;LOOP PARA VERIFICAR SE ENTRAM BYTES POR SERIAL
					BANKSEL PIR1
					BTFSS PIR1, RCIF 		
					GOTO RECEBE 			
					NOP
					NOP
					
					;QUANDO CHEGA UM BYTE:
					;COLOCA O BYTE EM W
					;MOVE O VALOR EM W PARA O CONTADOR
					;DIRECIONA PARA A ROTINA DE MUDAR O DISPLAY
					BANKSEL RCREG
					MOVF RCREG, W	
					MOVWF CONTADOR			
					GOTO ATUALIZA			
			
			END
			;-------------------------------------------------------------
