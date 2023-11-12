#pragma once

#include <WinSock2.h>
#include <fstream>
#include <vector>
#include <map>

#define SINGLE                  "SINGLE"
#define DECLINE                 "DECLINE"
#define DISCONNECT              "DISCONNECT"
#define DEVICE                  "DEVICE"
#define NEXT                    "NEXT"
#define OK_SEND                 "OK_SEND"
#define S_FILE_CAME             "S_FILE_CAME"
#define S_FILE_SEND             "S_FILE_SEND"
#define FILE_SEND_END           "FILE_SEND_END"
#define C_MULTIPLE_FILE_SEND    "C_MULTIPLE_FILE_SEND"
#define C_FILE_SEND             "C_FILE_SEND"
#define FILE_CHUNK_SIZE         4096

using namespace std;

static short _LENGTH = 0;

class Server {
	public:
		Server();

		void Setup();
		void Start();
		void Stop() const;

	private:
		void CreateSaveFilePathFolder() const;
		void HandleFileProcess(char*& buffer, int& bufferSize, bool saveMultipleFile = false);
		void HandleFileTransfer(char* buffer, int& bufferSize);
		void SendClientFile(string& inputFolder, char* buffer, const int& bufferSize);
		void SaveFileData(const int& bufferSize, const char* fileName);
		bool FolderExists(const wchar_t* folderPath) const;
		bool FileExists(const wchar_t* filePath) const;
		vector<string> FileMessageParse(string message, short& msgLen = _LENGTH, const char seperator = '|');
		vector<pair<string, string>> MultipleFileMessageParse(string message);
		string GetClientDeviceName(char* buffer, int& buffSize);
		string GetIPv4() const ;

		WSADATA wsaData;
		string PcUserName;
		SOCKET ServerSocket{};
		SOCKET ClientSocket{};
		sockaddr_in ServerAddr{};
		sockaddr_in ClientAddr{};
};