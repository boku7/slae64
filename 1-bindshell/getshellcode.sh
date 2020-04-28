#!/bin/bash
## Bobby Cooke: https://boku7.github.io/2020/04/06/SLAE64_1_BindShell.html
OBJFILE=$1
for i in $(objdump -D $OBJFILE | grep "^ " | cut -f2); do echo -n '\x'$i; done; echo ''

