;Angelo Monte Serrat Bonini----
;Contador 0 a 99-------------

#INCLUDE <P16F628A.INC>
	__CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC

#DEFINE BANCO0 BCF STATUS, RP0
#DEFINE BANCO1 BSF STATUS, RP0

CBLOCK 0X20 

    CONTADOR_D1
    CONTADOR_D2
    CONTADOR_TMP
    CONTADOR_DELAY
ENDC

ORG 0X0000
GOTO INICIO
ORG 0X0005

DELAY
    MOVLW .10 ;move o valor 10 para o registrador e depois para contador_delay

    MOVWF CONTADOR_DELAY
    BCF INTCON, T0IF ;limpa bit de identificação
    MOVLW 0X3C ; valor 60 em w, depois realocando para tmr0
    MOVWF TMR0


    CLRWDT ;limpa wdt 

INTERVALO

    CLRWDT
    BTFSS INTCON, T0IF ; inicia a rotina se o bit t0if estiver setado

    GOTO INTERVALO 

    DECFSZ CONTADOR_DELAY, F ; decresce a variável e retorna a rotina
    GOTO CONTADOR_DELAY

MOSTRA_VALOR 
    MOVF CONTADOR_D2, W ; move o valor do display2 para w
    MOVWF CONTADOR_TMP ; coloca esse valor em contador_tmp
    SWAPF CONTADOR_TMP, F ; faz o sap dos bits mais significativos com os menos significativos
                          ;adequando a posição deles  

    CLRW              ; limpa w
    IORWF CONTADOR_D1,W ; faz OR entre o valor do display 1 e w
    IORWF CONTADOR_TMP, W ; OR entre contador_tmp e w

    MOVWF PORTB ;exibe os numeros do display 1 e 2 
    RETURN

INICIO:

    CLRF PORTB ; limpa a porta b
    BANCO1 ;muda para o banco de memoria 1
    CLRF TRISB ; limpa os bits de trisb

    MOVLW B'00011111' ;configurando porta de entrada A

    MOVWF TRISA 
    MOVLW B'00000011' 

    MOVWF OPTION_REG
    BANCO0 ; muda para o banco 0

RESETAR:

    CLRF CONTADOR_D1 ; limpa o display 1
    CLRF CONTADOR_D2 ;limpa o display 2
    CLRF CONTADOR_TMP ; limpa contador_tmp

    CALL MOSTRA_VALOR ; exibe 00

LOOP:
    CALL DELAY ;delay de 0,25 seg
    BTFSC PORTA,2 ; verigica se o botão reset foi pressionado

    GOTO RESETAR ; reseta

    BTFSS PORTA,1 ; verifica a chave de parada
                   ; se estiver desligada, para o contador 

    GOTO LOOP 
    BTFSS PORTA, 0 ; verifica o sentido da contagem
                    ; chave ligada = crescente
    GOTO DESCRESCENTE 

CRESCENTE:
    INCF CONTADOR_D1, F ;incrementa o display 1
    MOVLW .10 ; move o valor 10 para w
    SUBWF CONTADOR_D1, W ; subtrai o valor do display1

    BTFSS STATUS,Z ; verifica se o resultado foi 0

    GOTO DESVIAR_C ; continua a contar
    CLRF CONTADOR_D1 ; manda o display 1 para 0
    INCF CONTADOR_D2,F ; incrementa o display 2
    MOVLW .10 ; move 10 para w

    SUBWF CONTADOR_D2,W ; subtrai display 2 de w
    BTFSC STATUS, Z ; verifica oresultado

    CLRF CONTADOR_D2 ;manda o display 2 para 0

DESVIAR_C:
    CALL MOSTRA_VALOR ; mostra valor atual de cada display
    GOTO LOOP ; volta ao loop principal

DESCRESCENTE:
    DECF CONTADOR_D1, F ; tira o valor atual do display 1
    MOVLW 0xFF ; move 255 para w

    SUBWF CONTADOR_D1,W ;subtrai display 1 de w
    BTFSS STATUS,Z ; verifica operacao

    GOTO DESVIAR_D ;continua a contar
    MOVLW .9 ;move o valor 9 para w

    MOVWF CONTADOR_D1  ; atualiza o display1
    DECF  CONTADOR_D2, F ;decresce o display 2
    MOVLW 0xFF ; move 255 para w

    SUBWF CONTADOR_D2,W ;subtrai o display2 de w
    BTFSS STATUS,Z ;verifica operacao

    GOTO DESVIAR_D ; continua a contar
    MOVLW .9 ;move 9 para w

    MOVWF CONTADOR_D2 ; display 2 volta para o 9

DESVIAR_D:
    CALL MOSTRA_VALOR ; mostra o valor de cada display
    GOTO LOOP ; volta para o loop principal
    END    ; fim do programa