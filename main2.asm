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
    sub esp, 8                          ; Subtraimos (reservamos) 8 bytes, 4 para o retorno, 4 para o parametro
    mov dword [esp], ret1               ; Movemos ret1 para o stack pointer, estabelecendo ponto de partida e de retorno
    mov dword [esp+4], STD_OUT_HANDLE   ; Movemos o parametro (lembrando que cada parametro é 4 bytes, por isso se incrementa 4)

    jmp _GetStdHandle@4                 ; Damos jmp à função, ela mesmo já restaura os bytes que demos sub
ret1:
    mov ebx, eax                        ; Por precaução, armazenamos o resultado de _GetStdHandle (que fica em eax por padrão) para ebx

    sub esp, 24                         ; Subtraimos (reservamos) 24 bytes ((5 parametros x 4 bytes) + 4 bytes do retorno) para _WriteFile
    mov dword [esp], ret2
    mov dword [esp+4], ebx              ; Pushamos nosso handle ao primeiro parametro da função _WriteFile
    lea eax, [msg]                      ; Carregamos o ponteiro da mensagem inteira
    mov dword [esp+8], eax              ; Pushamos o parametro msg, que ficou em eax
    mov dword [esp+12], msg_length      ; Pushamos o parametro msg_length
    mov dword [esp+16], NULL            ; Pushamos o parametro NULL
    mov dword [esp+20], NULL            ; Pushamos o parametro NULL

    jmp _WriteFile@20                   ; Chamamos a função
ret2:
    sub esp, 8                          ; Subtraimos (reservamos) 8 bytes para 1 parametro e 1 retorno de _ExitProcess
    mov dword [esp], ret3               ; Pushamos o ret3
    mov dword [esp+4], NULL             ; Pushamos o parametro NULL
    jmp _ExitProcess@4                  ; Chamamos a função
ret3:
    ret                                 ; Retornamos