#pragma once

#ifndef __SYNCMAGNET_H
#define __SYNCMAGNET_H

#include <WinSock2.h>
#include <ws2tcpip.h>

#include <string>
#include <vector>
#include <iostream>

#define __SYNCPUBLIC            extern "C" __declspec(dllexport)
#define __SYNCPRIVATE
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
#define H_TRANSFER              "H_TRANSFER"
#define FILE_CHUNK_SIZE         4096

using namespace std;

__SYNCPRIVATE SOCKET ServerSocket;
__SYNCPRIVATE SOCKET ClientSocket;
__SYNCPRIVATE sockaddr_in ServerAddr;
__SYNCPRIVATE sockaddr_in ClientAddr;
__SYNCPRIVATE static short _LENGTH = 0;
__SYNCPRIVATE static int bufferSize = 1024;
__SYNCPRIVATE static const char *deviceName = "";
__SYNCPRIVATE static int downloadFileSize = 0;
__SYNCPRIVATE static int downloadTotalFileSize = 0;
__SYNCPRIVATE static string PcUserName;
__SYNCPRIVATE static char buffer[1024];
__SYNCPRIVATE static bool sendFinished;
__SYNCPRIVATE static bool isCanGetDeviceState;
__SYNCPRIVATE static bool isLoadFile;
__SYNCPRIVATE static bool isDownloadCompleted;
__SYNCPRIVATE static bool mobileAppDisconnect;
__SYNCPRIVATE static bool onDisconnect;
__SYNCPRIVATE static bool isTransfer = true;

__SYNCPRIVATE vector<string> FileMessageParse(string message, short &msgLen = _LENGTH, const char seperator = '|');
__SYNCPRIVATE vector<pair<string, string>> MultipleFileMessageParse(string message);
__SYNCPRIVATE void GetClientDevice(char *buffer);
__SYNCPRIVATE void SendClientFile(const char *inputFile, char *buffer, const int &bufferSize);
__SYNCPRIVATE void SaveFileData(const int &bufferSize, const char *fileName);
__SYNCPRIVATE void HandleFileProcess(char *buffer, const int &bufferSize = 1024, bool allowMultiple = false);
__SYNCPRIVATE void XMLFile(const char* deviceName, const char* batterySize);
__SYNCPRIVATE void GetCurrentFileCompleted(const char *currentFileSendCompleted, bool isDownload = false);
__SYNCPRIVATE void CreateSaveFilePathFolder();
__SYNCPRIVATE bool FolderExists(const wchar_t *folderPath);
__SYNCPRIVATE bool FileExists(const wchar_t *filePath);

__SYNCPUBLIC void SetupServer(const char *ipAddr);
__SYNCPUBLIC void StartServer();
__SYNCPUBLIC void SendSelectFiles(const char* *files, int fileCount);
__SYNCPUBLIC void HandleFileTransfer();
__SYNCPUBLIC void CloseServer();
__SYNCPUBLIC void GetDeviceBatteryStatusPerSecond();
__SYNCPUBLIC inline void SetCanDeviceState(bool state) { isCanGetDeviceState = state; }
__SYNCPUBLIC inline void SetTransferMode(bool mode) { isTransfer = mode; }
__SYNCPUBLIC inline int GetCurrentDownloadFileSize() { return downloadFileSize; }
__SYNCPUBLIC inline int GetCurrentTotalDownloadFileSize() { return downloadTotalFileSize; }
__SYNCPUBLIC inline bool GetSendFinishedState() { return sendFinished; }
__SYNCPUBLIC inline bool GetIsLoadFile() { return isLoadFile; }
__SYNCPUBLIC inline bool GetIsDownloadCompletedFile() { return isDownloadCompleted; }
__SYNCPUBLIC inline bool CanGetDeviceState() { return isCanGetDeviceState; }
__SYNCPUBLIC inline bool GetonDisconnectDevice() { return onDisconnect; }

#endif