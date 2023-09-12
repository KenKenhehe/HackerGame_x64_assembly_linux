SECTION .data
    incorrectStr db "NOT equal", 10, 0
    correctStr db "equal", 10 ,0
    text1 db "swe", 10, 0
    text2 db "swe", 10, 0

    test_text db "this is a test", 10, 0
    
SECTION .bss
    digitSpace resb 100
    digitSpacePos resb 8

SECTION .text
    global _start

_start:
    mov rax, text1
    call _printString

    mov rax, text2
    call _printString

    mov rdi, text1
    mov rsi, text2
    call _compareString

    mov rax, 60     ;function id number 
    mov rdi, 0      ;error code
    syscall

_procShowIncorrectInfo:
    mov rax, incorrectStr
    call _printString
    ret

_procShowCorrectInfo:
    mov rax, correctStr
    call _printString
    ret

_procCompareString:
    mov al, [rdi]
    mov cl, [rsi]

    cmp al, cl

    jne _showIncorrectInfo

    cmp al, 0
    je _showCorrectInfo

    inc rdi
    inc rsi
    jmp _compareString

    ret

;length value is stored in the rbx register
_countStringLength:
    mov ebx, 0
_countLengthLoop:
    inc rax
    inc ebx
    mov cl, [rax]
    cmp cl, 0
    jne _countLengthLoop
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

_printInteger:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx

_loadCharacterLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx    ; rax / rbx(10 in this case)
    push rax
    add rdx, 48

    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx
    pop rax
    cmp rax, 0
    jne _loadCharacterLoop

_printIntegerLoop:
    mov rcx, [digitSpacePos]

    ;print the first character
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall

    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx

    cmp rcx, digitSpace
    jge _printIntegerLoop
    ret