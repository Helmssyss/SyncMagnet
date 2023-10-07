#include "Public/server.h"
#include <iostream>

int main(int argc, char* *argv) {
	//printf("You have entered %d arguments:\n", argc);

	//for (int i = 0; i < argc; i++) {
	//	printf("%s\n", argv[i]);
	//}
	Server* server = new Server;

	server->Setup();
	server->Start();

	delete server;
	return 0;
}
