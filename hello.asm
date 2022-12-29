
SECTION .data
text     db      'Hello World!', 10     
 
SECTION .text
global  _start
 
_start:
    mov     rax, 1      ;op code
    mov     rdi, 1      ;file descriptor
    mov     rsi, text   ;address of buffer(string)
    mov     rdx, 14     ;character count
    syscall

    mov     rax, 60     ;op code
    mov     rdi, 0      ;error code
    syscall
    