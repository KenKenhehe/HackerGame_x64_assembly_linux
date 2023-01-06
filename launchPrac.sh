nasm -f elf64 -o hello.o hello.asm 
ld hello.o -o hello.a
./hello.a