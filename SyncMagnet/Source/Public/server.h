#pragma once

#include <WinSock2.h>
#include <fstream>
#include <vector>

#define OK_SEND_TO   "OK_SEND_TO"
#define IMG_SEND     "IMG_SEND"
#define OK_SEND      "OK_SEND"
#define ACCEPT       "ACCEPT"
#define DECLINE      "DECLINE"
#define DEVICE_NAME  "DEVICE_NAME"

using namespace std;

static int _LENGTH = 0;

class Server {
	public:
		Server();
	
		void Setup(const char*& ip, const char*& port);
		void Start();
		void Stop();

	private:
		bool SaveImageData(const int& bufferSize, bool isImagePathToDesktop = false);
		void CreateSaveImagePathFolder(const wchar_t* pathFolder);
		void HandleFileTransfer(char* buffer, int& bufferSize);
		std::string GetClientDeviceName(char* buffer, int& buffSize);
		void SendClientFile(string& inputFolder, char* buffer, const int& bufferSize);
		vector<string> MessageParse(string message, int& msgLen = _LENGTH, const char seperator = '|');
	
		const char* ip;
		const char* port;
		bool isRun;
		bool isLoad = true;
		string PcUserName;
		SOCKET ServerSocket{};
		SOCKET ClientSocket{};
		sockaddr_in ServerAddr{};
		sockaddr_in ClientAddr{};
};
