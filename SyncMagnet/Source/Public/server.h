#pragma once

#include <WinSock2.h>
#include <fstream>
#include <vector>

static int LENGTH = 0;
constexpr const char* OK_SEND_TO     = "OK_SEND_TO";
constexpr const char* IMG_SEND       = "IMG_SEND";
constexpr const char* OK_SEND        = "OK_SEND";
constexpr const char* ACCEPT         = "ACCEPT";
constexpr const char* DECLINE        = "DECLINE";
constexpr const char* FILE_NAME      = "FILE_NAME";
constexpr const char* FILE_NAME_SEND = "FILE_NAME_SEND";

class Server {
	public:
		Server();
		~Server();
		
		void Setup(const char* &ip, const char* &port);
		void Start();
		void Stop();
		
	private:
		bool SaveImageData(const int &bufferSize, bool isImagePathToDesktop = false);
		void CreateSaveImagePathFolder(const wchar_t *pathFolder);
		void HandleFileTransfer(char *buffer, int& bufferSize);
		void SendClientFile(std::string &inputFolder, char* buffer, const int& bufferSize);
		std::vector<std::string> MessageParse(std::string message, int&  msgLen = LENGTH, const char separator = '|');
		
		const char* ip;
		const char* port;
		bool isRun;
		
		std::string PcUserName;
		SOCKET ServerSocket{};
		SOCKET ClientSocket{};
		sockaddr_in ServerAddr{};
		sockaddr_in ClientAddr{};
};
