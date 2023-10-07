#pragma once

#include <WinSock2.h>
#include <fstream>
#include <vector>
#include <map>

#define OK_SEND            "OK_SEND"
#define SINGLE             "SINGLE"
#define DECLINE            "DECLINE"
#define DISCONNECT         "DISCONNECT"
#define DEVICE_NAME        "DEVICE_NAME"
#define FILE_CAME          "FILE_CAME"
#define FILE_BYTE          "FILE_BYTE"
#define FILE_BYTE_TO       "FILE_BYTE_TO"
#define FILE_SEND		   "FILE_SEND"
#define FILE_SEND_END	   "FILE_SEND_END"
#define MULTIPLE_FILE_SEND "MULTIPLE_FILE_SEND"
#define NEXT			   "NEXT"

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
		void HandleFileProcess(char*& buffer, int& bufferSize, bool saveMultipleFile = false);
		void HandleFileTransfer(char* buffer, int& bufferSize);
		void SendClientFile(string& inputFolder, char* buffer, const int& bufferSize);
		void SaveFileData(const int& bufferSize, const char* fileName,bool allowMultiple = false);
		bool FolderExists(const wchar_t* folderPath) const;
		bool FileExists(const wchar_t* filePath) const;
		vector<string> FileMessageParse(string message, int& msgLen = _LENGTH, const char seperator = '|');
		vector<pair<string, string>> MultipleFileMessageParse(string message);
		string GetClientDeviceName(char* buffer, int& buffSize);
		string GetIPv4() const ;

		string PcUserName;
		SOCKET ServerSocket{};
		SOCKET ClientSocket{};
		sockaddr_in ServerAddr{};
		sockaddr_in ClientAddr{};
};