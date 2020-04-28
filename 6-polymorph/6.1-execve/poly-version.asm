_start:
xor rsi, rsi ; rsi = 0x0
mul rsi      ; rax & rdx = 0x0
mov rcx, 0x68732f6e69622fff ; /bin/sh,0xff
shr rcx, 0x8
push rcx
mov rdi, rsp
mov al, 0x3b        ; execve system call
syscall

push 0x1
pop rdi
push 0x3c            ; exit(3c)
pop rax
syscall

