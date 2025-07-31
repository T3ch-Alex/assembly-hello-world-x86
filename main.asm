NULL EQU 0              ; Constante para passarmos como parametro em algumas chamadas de função
STD_OUT_HANDLE EQU -11  ; -11 é basicamente um ID do windows que representa o output no console (stdin)
                        ; -10 é o input no console (stdout)
                        ; -12 é erro padrão (stderr)

extern _ExitProcess@4   ; Usa-se os decoradores no final indicando quantos parametros essas funções recebe, cada 1 parametro corresponde a 4 bytes
extern _WriteFile@20    ; 5 parametros
extern _GetStdHandle@4  ; 1 parametro

global main

section .data
    msg db "Hello, World!", 0   ; Definimos a mensagem
    msg_length EQU $-msg        ; Extraimos o tamanho da mensagem

section .text
main:
    push STD_OUT_HANDLE     ; Empurramos a constante pra pilha
    call _GetStdHandle@4    ; Chamamos a função
    mov ebx, eax            ; Guardamos o resultado temporariamente
    add esp, 4              ; Voltamos o stack pointer ao valor original

    push NULL               ; Empurramos os parametros da função WriteFile
    push NULL
    push msg_length
    push msg
    push ebx                ; EBX contém nosso handle, obtido por GetStdHandle
    call _WriteFile@20      ; Chamamos a função
    add esp, 20             ; Voltamos o stack pointer ao valor original

    push NULL               ; Empurramos o parametro NULL para a pilha
    call _ExitProcess@4     ; Chamamos ExitProcess
