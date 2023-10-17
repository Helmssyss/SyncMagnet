#pragma once

#include <WinSock2.h>
#include <ws2tcpip.h>

#include <string>
#include <vector>

#pragma comment(lib, "Ws2_32.lib")

#define SINGLE                  "SINGLE"
#define DECLINE                 "DECLINE"
#define DISCONNECT              "DISCONNECT"
#define DEVICE                  "DEVICE"
#define NEXT                    "NEXT"
#define OK_SEND                 "OK_SEND"
#define S_FILE_CAME             "S_FILE_CAME"
#define S_FILE_SEND             "S_FILE_SEND"
#define S_FILE_SEND_END         "S_FILE_SEND_END"
#define C_FILE_SEND_END         "C_FILE_SEND_END"
#define C_MULTIPLE_FILE_SEND    "C_MULTIPLE_FILE_SEND"
#define C_FILE_SEND             "C_FILE_SEND"
#define FILE_CHUNK_SIZE         4096

SOCKET ServerSocket;
SOCKET ClientSocket;

sockaddr_in ServerAddr;
sockaddr_in ClientAddr;

static short _LENGTH = 0;
static const char* deviceName = "";
static std::string PcUserName;

std::vector<std::string> FileMessageParse(std::string message, short &msgLen = _LENGTH, const char seperator = '|');
std::vector<std::pair<std::string, std::string>> MultipleFileMessageParse(std::string message);
const char *GetClientDeviceName(char *buffer, int &buffSize);

void SendClientFile(const char *inputFile, char *buffer, const int &bufferSize);
void SaveFileData(const int &bufferSize, const char *fileName, bool allowMultiple = false);
void HandleFileProcess(char *buffer, int &bufferSize, bool saveMultipleFile = false);

extern "C" __declspec(dllexport) void SetupServer(const char *ipAddr);
extern "C" __declspec(dllexport) void StartServer();
extern "C" __declspec(dllexport) void SendSelectFiles(const char *files[], int fileCount);
extern "C" __declspec(dllexport) void HandleFileTransfer();
extern "C" __declspec(dllexport) void CloseServer();