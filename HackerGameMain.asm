SECTION .data
    greeting db "Welcome to hacker game!", 10, 0
    start_game_question db "What would you like to hack? ", 10, "1) Library", 10, "2) Police Station", 10, "3) Quit", 10, "Please enter here: ", 0
    info_with_option db "Start hacking ", 0

    goodbye_text db "----------", 10, "GOODBYE!", 10, "----------", 10, 0

    library_str db "library", 10, 0
    police_str db "police station", 10, 0

SECTION .bss
    option resb 16
    option_str resb 32

SECTION .text
    global _start

_start:
    call _printGreeting
    call _printQuestion
    call _getOptionNum
    call _printHackPrefix

    call _printOptionText

    mov     rax, 60     ;function id number 
    mov     rdi, 0      ;error code
    syscall

_printQuestion:
    mov rax, start_game_question
    call _printString
    ret

_getOptionNum:
    ; use std read to read user input in to "option" space
    mov rax, 0
    mov rdi, 0
    mov rsi, option
    mov rdx, 16
    syscall
    ret

_printHackPrefix:
    mov rax, info_with_option
    call _printString
    ret

_printOption:
    mov rax, 1
    mov rdi, 1
    mov rsi, option_str
    mov rdx, 32
    syscall
    ret

_printGreeting:
    mov rax, greeting
    call _printString
    ret

_printOptionText:
    mov ah, [option]
    cmp ah, 49 ;ascii for "1"
    jz _printLibraryText

    mov ah, [option]
    cmp ah, 50 ;ascii for "2"
    jz _printPoliceStationText

    mov ah, [option]
    cmp ah, 51 ;ascii for "3"
    jz _quitGame
    ret

_quitGame:
    mov rax, goodbye_text
    call _printString
    ret

_printPoliceStationText:
    mov rax, police_str
    call _printString
    ret

_printLibraryText:
    mov rax, library_str
    call _printString
    ret

_printString:
    push rax
    mov rbx, 0

_countLoop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _countLoop

    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
    ret