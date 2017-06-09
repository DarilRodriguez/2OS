; MEMORY MAP
; 0x7C00 - bootloader
; 0x7E00 - kernel
; 0x8e00 - free memory

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
    xor ax, ax
    mov es, ax
    mov bx, 7E00h
    
    call __load__sectors
    
    mov si, 7E00h
    call print
    jmp $

__load__sectors:
    mov ah, 02h
    mov al, 08h ; kernel size (4096)
    mov ch, 01h
    mov cl, 02h
    mov dh, 01h
    mov dl, 00h
    
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

times 510 - ($ - $$) db 00h
dw 0xAA55 

times 512 db 'A'

;0x7E00 - kernel

include "../kernel.asm"
times 4608 - ($ - $$) db 00h

;0x8E00

times 1440*1024 - ($ - $$) db 00h ;floppy disk size 1440kb