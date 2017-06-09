
main:
    mov si, kernel_message
    call print
    jmp $

kernel_message: db "Kernel is running", 00h