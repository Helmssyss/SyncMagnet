#pragma once

#include <WinSock2.h>
#include <ws2tcpip.h>

#include <string>
#include <vector>

#define SYNCAPI                 extern "C" __declspec(dllexport)

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

SOCKET ServerSocket;
SOCKET ClientSocket;

sockaddr_in ServerAddr;
sockaddr_in ClientAddr;

static short _LENGTH = 0;
static int bufferSize = 1024;
static const char *deviceName = "";
static int downloadFileSize = 0;
static int downloadTotalFileSize = 0;
static string PcUserName;
static char buffer[1024];
static bool sendFinished;
static bool isCanGetDeviceState;
static bool isLoadFile;

vector<string> FileMessageParse(string message, short &msgLen = _LENGTH, const char seperator = '|');
vector<pair<string, string>> MultipleFileMessageParse(string message);
void GetClientDevice(char *buffer, const int &buffSize = 1024);

void SendClientFile(const char *inputFile, char *buffer, const int &bufferSize);
void SaveFileData(const int &bufferSize, const char *fileName);
void HandleFileProcess(char *buffer, const int &bufferSize = 1024, bool allowMultiple = false);
void XMLFile(const char* deviceName, const char* batterySize);
void GetCurrentFileCompleted(const char *currentFileSendCompleted, bool isDownload = false);
void CreateSaveFilePathFolder(); //
bool FolderExists(const wchar_t* folderPath); //
bool FileExists(const wchar_t* filePath); // 

SYNCAPI void SetupServer(const char *ipAddr);
SYNCAPI void StartServer();
SYNCAPI void SendSelectFiles(const char* *files, int fileCount);
SYNCAPI void HandleFileTransfer();
SYNCAPI void CloseServer();
SYNCAPI void GetDeviceBatteryStatusPerSecond();
SYNCAPI inline void GetDeviceBatteryStatusPerSecond() { GetClientDevice(buffer); }
SYNCAPI inline void SetCanDeviceState() { isCanGetDeviceState = true; }
SYNCAPI inline int GetCurrentDownloadFileSize() { return downloadFileSize; }
SYNCAPI inline int GetCurrentTotalDownloadFileSize() { return downloadTotalFileSize; }
SYNCAPI inline bool GetSendFinishedState() { return sendFinished; }
SYNCAPI inline bool GetIsLoadFile() { return isLoadFile; }
SYNCAPI inline bool CanGetDeviceState() { return isCanGetDeviceState; }
SYNCAPI void GetChangeLog();