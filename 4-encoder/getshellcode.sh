#!/bin/bash
## Author: Bobby Cooke
asmFile=$1
noExt=$(echo $asmFile | sed 's/\..*$//g')
objFile=$noExt".o"
nasm -f elf64 $asmFile -o $objFile
for i in $(objdump -D $objFile | grep "^ " | cut -f2); do echo -n '\x'$i; done; echo ''
