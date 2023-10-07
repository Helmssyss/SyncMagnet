#include "Public/server.h"

int main(int argc, char* *argv) {
	Server* server = new Server;

	server->Setup();
	server->Start();

	delete server;
	return 0;
}
