#include "Public/server.h"

int main() {
	Server* server = new Server;

	server->Setup();
	server->Start();

	delete server;
	return 0;
}
