#!/bin/bash
## Author: Bobby Cooke
if [ $# -eq 0 ]; then
    echo 'Usage: '$0' [ASM_FILE.asm]'
    exit
fi
asmFile=$1
noExt=$(echo $asmFile | sed 's/\..*$//g')
objFile=$noExt".o"
echo "[+] Compiling: nasm -f elf64 $asmFile -o $objFile"
nasm -f elf64 $asmFile -o $objFile
echo "[+] Dumping shellcode with objdump"
SHELLCODE=$(for i in $(objdump -D $objFile | grep "^ " | cut -f2); do echo -n '\x'$i; done)
echo 'Creating a host file: shellcode.c & adding your shellcode to it'
echo '#include<stdio.h>' > shellcode.c
echo '#include<string.h>' >> shellcode.c
echo 'unsigned char shellcode[] = \' >> shellcode.c
echo '"'$SHELLCODE'";' >> shellcode.c
echo 'int main()' >> shellcode.c
echo '{' >> shellcode.c
echo '        printf("Shellcode Length:  %d\n", strlen(shellcode));' >> shellcode.c
echo '        int (*ret)() = (int(*)())shellcode;' >> shellcode.c
echo '        ret();' >> shellcode.c
echo '}' >> shellcode.c
echo "compiling the shellcode with: gcc -m64 -z execstack -fno-stack-protector shellcode.c -o shellcode"
gcc -m64 -z execstack -fno-stack-protector shellcode.c -o shellcode
echo 'All done!'
ls -l shellcode
