#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>


#define MSG "Hello, World!"


int
main(void) {
   int sock = -1;
   struct sockaddr *local_addr = NULL;
   struct sockaddr_in sockin, host;
   int tos = 0x60; /* CS3 */
   socklen_t socksiz = 0;
   char *buffer = NULL;

   sock = socket(AF_INET, SOCK_DGRAM, 0);
   if (sock < 0) {
      fprintf(stderr,"Error: %s\n", strerror(errno));
      exit(-1);
   }

   memset(&sockin, 0, sizeof(sockin));
   sockin.sin_family = PF_INET;
   sockin.sin_addr.s_addr = inet_addr("11.1.1.1");
   socksiz = sizeof(sockin);

   local_addr = (struct sockaddr *) &sockin;

   /* Set ToS/DSCP */
   if (setsockopt(sock, IPPROTO_IP, IP_TOS,  &tos,
                  sizeof(tos)) < 0) {
      fprintf(stderr,"Error setting TOS: %s\n", strerror(errno));
   }

   /* Bind to a specific local address */
   if (bind(sock, local_addr, socksiz) < 0) {
      fprintf(stderr,"Error binding to socket: %s\n", strerror(errno));
      close(sock); sock=-1;
      exit(-1);
   }

   buffer = (char *) malloc(strlen(MSG) + 1);
   if ( buffer == NULL ) {
      fprintf(stderr,"Error allocating memory: %s\n", strerror(errno));
      close( sock ); sock=-1;
      exit(-1);
   }
   strlcpy(buffer, MSG, strlen(MSG) + 1);
   memset(&host, 0, sizeof(host));
   host.sin_family = PF_INET;
   host.sin_addr.s_addr = inet_addr("10.1.1.1");
   host.sin_port = htons(12345);

   if (sendto(sock, buffer, strlen(buffer), 0,
              (struct sockaddr *) &host, sizeof(host)) < 0) {
      fprintf(stderr,"Error sending message: %s\n", strerror(errno));
      close(sock); sock=-1;
      free(buffer); buffer=NULL;
      exit(-1);
   }

   free(buffer); buffer=NULL;
   close(sock); sock=-1;

   return 0;
}
