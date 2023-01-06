
SECTION .data
text     db      'Hello World!', 10     
digit    db 0, 10
 
SECTION .text
global  _start
 
_start:

    mov rax, 1
    add rax, 7
    call _printRaxDigitOneToNine

    mov     rax, 60     ;op code
    mov     rdi, 0      ;error code
    syscall

_printRaxDigitOneToNine:
    add rax, 48
    mov [digit], al

    mov     rax, 1      ;op code
    mov     rdi, 1      ;file descriptor
    mov     rsi, digit  ;address of buffer(string)
    mov     rdx, 2      ;character count
    syscall 
    ret

_printHello:
    mov     rax, 1      ;op code
    mov     rdi, 1      ;file descriptor
    mov     rsi, text   ;address of buffer(string)
    mov     rdx, 14     ;character count
    syscall 
    ret