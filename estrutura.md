##Estrutura de um programa
; Comentários Iniciais .....
#include <p16f873.inc>
; Definição do Microcontrolador a ser Usado
CBLOCK
0x20
; Área de Definição de Variáveis tipo Byte
AUX
CONT
VALOR
ENDC
; Fim da área de Definição de Variáveis
; --------------------------------
ORG 0x0000
GOTO
; Endereço de Início do Programa após Reset
INICIO
;---------------------------------
ORG 0x0004
; Endereço de Rotinas de Interrupções
RETFIE
; ---------------------------------
INICIO:
;Início do Programa Principal
; ....................
;.....................
END
•
; Fim do Programa Principal
No início do programa o Montador (assembler) deve ser informado qual é o
processador que será utilizado, através da diretiva #include <nome-do-
processador>
Notas de Aulas: Microcontroladores.
Prof. João E. M. Perea Martins – Dep. de Computação. UNESP, Bauru-SP.
E-mail: joao.perea@unesp.br
1•
A diretiva CBLOCK 0x20 determina que as variáveis do tipo byte serão
armazenadas seqüencialmente a partir do endereço 0x20.
No exemplo acima, ao invés de CBLOCK, poderíamos fazer:
•
AUX
EQU 0x20
CONT
EQU 0x21
VALOR
EQU 0x22
A diretiva ORG 0x000 determina onde está a primeira instrução a ser executada
após o reset.
•
A diretiva ORG 0x004 indica onde estarão colocadas as rotinas de tratamento de
interrupções.
• ́INICIO ́ é apenas um label, e indica o início do programa.
• ́END ́ indica o fim do programa
