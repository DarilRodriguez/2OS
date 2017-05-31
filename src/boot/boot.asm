use16
org 0x7C00

jmp short boot

msg_booting db "booting 2OS...", 0Ah, 0Dh, 00h
msg_loadkernel db "loading kernel...", 0Ah, 0Dh, 00h
msg_loadsector db "loading sector...", 0Ah, 0Dh, 00h
file_name db "kernel.bin", 00h

boot:
    cli
    
    xor eax, eax
    mov ss, ax
    mov es, ax
    mov ds, ax
    mov sp, 7C00h
    
    sti
    
    mov ax, 03h
    int 10h
    
    mov si, msg_booting
    call print
    
    mov si, msg_loadkernel
    call print
    call load_kernel
    
    jmp $

load_kernel:
    call load_sector_16
    
    xor ax, ax
    mov es, ax
    
    mov si, 8000h
    call print
    
    ret


load_sector_16:
    mov ah, 02h
    
    mov al, 1h  ;40h
    mov ch, 00h
    mov cl, 00h
    mov dh, 01h ;head number
    mov dl, 00h
    mov bx, 8000h
    
    int 13h
    
    ret

print:
    mov ah, 0xE
    
    .loop:
        lodsb
        cmp al, 0x0
        je .end
        int 10h
        jmp .loop
    .end:
        ret
     
printax:
    push bx
    
    mov bx, ax
    
    mov al, bh
    call printhex
    
    mov al, bl
    call printhex
    
    pop bx
    ret


printhex:
    pusha
    mov dl, al
    shr al, 4
    shl dl, 4
    shr dl, 4
    
    cmp al, 0Ah
    jl .lowa
    add al, 55
    jmp .enda
    
    .lowa:
        add al, 48
    .enda:
        mov ah, 0Eh
        int 10h
    
    mov al, dl
    cmp al, 0Ah
    jl .lowb
    add al, 55
    jmp .endb
    
    .lowb:
        add al, 48
    .endb:
        mov ah, 0Eh
        int 10h
    
    popa
    ret

times 510 - ($ - $$) db 00h
dw 0xAA55

times 32*1024 - ($-$$) db 00h ; cilinder 2

times 512 db 'A'
times 512 db 'B'
times 512 db 'C'
times 512 db 'D'
times 512 db 'E'
times 512 db 'F'

times 1440*1024 - ($-$$) db 00h ; standar flp size