SECTION .data
    greeting db "Welcome to hacker game!", 10, 0
    start_game_question db "What would you like to hack? ", 10, "1) Library", 10, "2) Police Station", 10, "3) Quit", 10, "Please enter here: ", 0
    info_with_option db "Start hacking ", 0

    goodbye_text db "----------", 10, "GOODBYE!", 10, "----------", 10, 0

    library_str db "library", 10, 0
    police_str db "police station", 10, 0

    library_password_prompt db "Library password(hint: ookb): ", 0
    library_password db "book", 10, 0

    police_password_prompt db "Police Station password(hint: tcejstu): ", 0
    police_password db "justice", 10, 0

    library_loop_test db "In library LOOP", 10, 0
    police_loop_test db "In police loop", 10, 0

    incorrectStr db "String NOT equal", 10, 0
    correctStr db "String equal", 10 ,0

    hack_success_str db "You are IN!", 10, 0
    hack_error_str db "Wrong password! Try again...", 10, 0


SECTION .bss
    option resb 16
    option_str resb 32
    guess_text resb 1024

SECTION .text
    global _start

_start:
    call _printGreeting
    call _printQuestion
    call _getOptionNum
    call _printHackPrefix

    call _procStartGameLoop
    
    mov     rax, 60     ;function id number 
    mov     rdi, 0      ;error code
    syscall

_printQuestion:
    mov rax, start_game_question
    call _procPrintString
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
    call _procPrintString
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
    call _procPrintString
    ret

_procStartGameLoop:
    mov ah, [option]
    cmp ah, 49 ;ascii for "1"
    jz _procStartLibraryGuessLoop

    mov ah, [option]
    cmp ah, 50 ;ascii for "2"
    jz _procStartPoliceStationGuessLoop

    mov ah, [option]
    cmp ah, 51 ;ascii for "3"
    jz _quitGame

    ret

_procStartLibraryGuessLoop:
    mov rax, library_str
    call _procPrintString
    call _procInLibraryLoop
    ret

_procPringHackErrorLibraryLoop:
    mov rax, hack_error_str
    call _procPrintString

_procInLibraryLoop:
    mov rax, library_password_prompt
    call _procPrintString
    call _porcGetGuessText
    
    mov rdi, guess_text
    mov rsi, library_password
    call _procCompareString

    cmp dl, 1

    jne _procPringHackErrorLibraryLoop
    ; jne _procInLibraryLoop

    mov rax, hack_success_str
    call _procPrintString
    ret 

_procStartPoliceStationGuessLoop:
    mov rax, police_str
    call _procPrintString
    call _procInPoliceStationLoop
    ret

_procPringHackErrorPoliceLoop:
    mov rax, hack_error_str
    call _procPrintString

_procInPoliceStationLoop:
    mov rax, police_password_prompt
    call _procPrintString
    call _porcGetGuessText

    mov rdi, guess_text
    mov rsi, police_password
    call _procCompareString

    cmp dl, 1
    jne _procPringHackErrorPoliceLoop
    mov rax, hack_success_str
    call _procPrintString
    ret 

_porcGetGuessText:
    ; use std read to read user input in to "guess_text" space
    mov rax, 0
    mov rdi, 0
    mov rsi, guess_text
    mov rdx, 16
    syscall
    ret

_quitGame:
    mov rax, goodbye_text
    call _procPrintString
    ret

_procPrintString:
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

_procCompareString:
    mov al, [rdi]
    mov cl, [rsi]

    cmp al, cl
    jne _procShowIncorrectInfo

    cmp al, 0
    je _procShowCorrectInfo

    inc rdi
    inc rsi
    jmp _procCompareString
    ret

_procShowIncorrectInfo:
    mov rax, incorrectStr
    call _procPrintString
    mov dl, 0
    ret

_procShowCorrectInfo:
    mov rax, correctStr
    call _procPrintString
    mov dl, 1
    ret