#pragma once

#include <WinSock2.h>
#include <fstream>
#include <vector>

#define OK_SEND_TO       "OK_SEND_TO"
#define IMG_SEND         "IMG_SEND"
#define OK_SEND          "OK_SEND"
#define ACCEPT           "ACCEPT"
#define DECLINE          "DECLINE"
#define DEVICE_NAME      "DEVICE_NAME"
#define FILE_BYTE        "FILE_BYTE"
#define FILE_BYTE_TO     "FILE_BYTE_TO"
#define DISCONNECT       "DISCONNECT"
#define FILE_CHUNK_SIZE  1024

using namespace std;

static int _LENGTH = 0;

class Server {
	public:
		Server();

		void Setup();
		void Start();
		void Stop() const;

	private:
		void CreateSaveFilePathFolder() const;
		void HandleFileTransfer(char* buffer, int& bufferSize);
		void SendClientFile(string& inputFolder, char* buffer, const int& bufferSize);
		void SaveFileData(const int& bufferSize, const char* fileName);
		bool FolderExists(const wchar_t* folderPath) const;
		vector<string> MessageParse(string message, int& msgLen = _LENGTH, const char seperator = '|');
		string GetClientDeviceName(char* buffer, int& buffSize);
		string GetIPv4() const ;

		string PcUserName;
		SOCKET ServerSocket{};
		SOCKET ClientSocket{};
		sockaddr_in ServerAddr{};
		sockaddr_in ClientAddr{};
};
