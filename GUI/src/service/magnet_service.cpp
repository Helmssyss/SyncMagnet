#include <WinSock2.h>
#include <ws2tcpip.h>

#include <string>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <vector>
#include <iostream>
#include <map>
#include <algorithm>

#include "./third_party/pugixml.hpp"

#pragma comment(lib, "Ws2_32.lib")

#define OK_SEND                 "OK_SEND"
#define SINGLE                  "SINGLE"
#define DECLINE                 "DECLINE"
#define DISCONNECT              "DISCONNECT"
#define DEVICE                  "DEVICE"
#define S_FILE_CAME               "S_FILE_CAME"
#define S_FILE_SEND               "S_FILE_SEND"
#define S_FILE_SEND_END           "S_FILE_SEND_END"
#define C_FILE_SEND_END           "C_FILE_SEND_END"
#define C_MULTIPLE_FILE_SEND      "C_MULTIPLE_FILE_SEND"
#define C_FILE_SEND             "C_FILE_SEND"
#define NEXT                    "NEXT"
#define FILE_CHUNK_SIZE         4096

SOCKET ServerSocket;
SOCKET ClientSocket;
sockaddr_in ServerAddr;
sockaddr_in ClientAddr;

static short _LENGTH = 0;
static const char* deviceName = "";
static std::string PcUserName;
static pugi::xml_document doc;
static pugi::xml_node root = doc.append_child("root");

std::vector<std::string> FileMessageParse(std::string message, short& msgLen = _LENGTH, const char seperator = '|') {
    std::stringstream sstream;
    std::string temp;
    std::vector<std::string> resultVector;
    short count = 0;
    sstream << message;

    for (char i : message) {
        if (i == seperator) {
            count++;
        }
    }

    for (int i = 0; i <= count; i++) {
        std::getline(sstream, temp, seperator);
        resultVector.push_back(temp);
    }

    msgLen = count;
    return resultVector;
}

std::vector<std::pair<std::string, std::string>> MultipleFileMessageParse(std::string message){
    std::vector<std::string> parsedData = FileMessageParse(message);
    std::map<std::string, std::string> resultMap;
    std::string _key;

    for (int8_t i = 0; i < parsedData.size(); i++) {
        if (i % 2 == 0) {
            _key = parsedData[i];
        }
        else {
            std::string _value = parsedData[i];
            resultMap[_key] = _value;
        }
    }
    std::vector<std::pair<std::string, std::string>> resultVector(resultMap.begin(), resultMap.end());
    std::sort(resultVector.begin(), resultVector.end(), [](const std::pair<std::string, std::string>& a, const std::pair<std::string, std::string>& b) {
        return std::stoi(a.first) > std::stoi(b.first);
        });
    return resultVector;
}

const char* GetClientDeviceName(char* buffer, int& buffSize) {
    send(ClientSocket, DEVICE, strlen(DEVICE), 0);
    const int8_t recvData = recv(ClientSocket, buffer, buffSize, 0);
    const std::string deviceName = FileMessageParse(buffer)[1];
    const int8_t deviceNameLength = std::stoi(FileMessageParse(buffer)[0]);
    std::string resultData = "";

    for (int8_t i = 0; i < deviceNameLength; i++) {
        resultData.push_back(deviceName[i]);
    }

    return resultData.c_str();
}

void SendClientFile(const char *inputFile, char* buffer, const int &bufferSize) {
    short fileNameCount = 0;
    std::ifstream file(inputFile, std::ios::binary);
    file.seekg(0, std::ios::end);
    const unsigned long fileSize = file.tellg();
    file.close();

    std::vector<std::string> str = FileMessageParse(inputFile, fileNameCount, '/');
    std::string firstFileContent;
    const std::string seperator = "|:FILE:|";
    firstFileContent = seperator + str[fileNameCount] + seperator + std::to_string(fileSize) + seperator;
    Sleep(10);
    send(ClientSocket, firstFileContent.c_str(), strlen(firstFileContent.c_str()), 0);
    Sleep(10);
    send(ClientSocket, S_FILE_CAME, strlen(S_FILE_CAME), 0);
    Sleep(10);

    bool run = true;
    while (run) {
        int bytesReceived = recv(ClientSocket, buffer, bufferSize, 0);
        buffer[bytesReceived] = '\0';

        if (strcmp(buffer, S_FILE_SEND) == 0) {
            memset(buffer, 0, sizeof(buffer));
            file.open(inputFile, std::ios::binary);
            file.seekg(0, std::ios::beg);
            int bytesSent = 0;
            int bytesToSend = 0;
            char* fileBuffer = new char[FILE_CHUNK_SIZE];

            while (bytesSent < fileSize) {
                if (fileSize - bytesSent >= FILE_CHUNK_SIZE)
                    bytesToSend = FILE_CHUNK_SIZE;
                else
                    bytesToSend = fileSize - bytesSent;
                file.read(fileBuffer, bytesToSend);
                const std::string sendFile = std::string(fileBuffer, bytesToSend);
                Sleep(5);
                send(ClientSocket, sendFile.c_str(), sendFile.length(), 0);
                bytesSent += bytesToSend;
                printf("\r%i/%i", bytesSent, fileSize);
            }
            printf("\nDosya Yuklendi\n");
            run = false;
            file.close();
            delete[] fileBuffer;
        }
    }
}

void SaveFileData(const int& bufferSize, const char* fileName,bool allowMultiple = false){
    std::ofstream file;
    file.open("C:/Users/" + PcUserName + "/Documents/SyncMagnetSave/" + fileName, std::ios::binary);
    char* dynamicBuffer = new char[bufferSize];
    int readBytes = 0;

    std::cout << "fileName: " << fileName << std::endl;
    while (readBytes < bufferSize) {
        int recvData = recv(ClientSocket, (dynamicBuffer + readBytes), (bufferSize - readBytes), 0);
        readBytes += recvData;
        file.write((dynamicBuffer + readBytes - recvData), recvData);
    }

    file.close();
    delete[] dynamicBuffer;
    if (allowMultiple)
        send(ClientSocket, NEXT, strlen(NEXT), 0);
}

void HandleFileProcess(char* buffer, int &bufferSize, bool saveMultipleFile = false){
    if (!saveMultipleFile){
        send(ClientSocket, SINGLE, strlen(SINGLE), 0);
        SaveFileData(bufferSize, FileMessageParse(buffer)[1].c_str());
        std::cout << "Saved" << std::endl;
    }else{
        send(ClientSocket, NEXT, strlen(NEXT), 0);
        std::vector<std::pair<std::string, std::string>> resultMap = MultipleFileMessageParse(buffer);
        for (const auto& pair : resultMap)
            SaveFileData(std::stoi(pair.first), pair.second.c_str(), true);
        
        std::cout << "Saved Multiple File" << std::endl;
        Sleep(10);
        send(ClientSocket, C_FILE_SEND_END, strlen(C_FILE_SEND_END), 0);
    }
}

extern "C" {
    __declspec(dllexport) void SetupServer(const char* ipAddr) {
        WSADATA wsaData;
        const short port = 1881;
        WSAStartup(MAKEWORD(2, 2), &wsaData);
        ServerSocket = socket(AF_INET, SOCK_STREAM, 0);
        ServerAddr.sin_family = AF_INET;
        inet_pton(AF_INET, ipAddr, &(ServerAddr.sin_addr));
        ServerAddr.sin_port = htons(port);
        TCHAR getName[MAX_COMPUTERNAME_LENGTH + 1];
        DWORD size = MAX_COMPUTERNAME_LENGTH + 1;

        if (GetUserName(getName, &size)) {
            std::string userName(getName, getName + size - 1);
            PcUserName = userName;
        }

        bind(ServerSocket, (sockaddr*)&ServerAddr, sizeof(ServerAddr));
        listen(ServerSocket, 1);
    }

    __declspec(dllexport) void StartServer() {
            int bufferSize = 1024;
            char buffer[1024];
            int ClientAddrSize = sizeof(ClientAddr);
            ClientSocket = accept(ServerSocket, (sockaddr*)&ClientAddr, &ClientAddrSize);

            deviceName = GetClientDeviceName(buffer, bufferSize);
            pugi::xml_node deviceNameXml = root.append_child("DeviceName");
            pugi::xml_node deviceBatteryXml = root.append_child("DeviceBattery");
            deviceNameXml.append_child(pugi::node_pcdata).set_value(deviceName);
            deviceBatteryXml.append_child(pugi::node_pcdata).set_value(FileMessageParse(buffer)[2].c_str());
            doc.save_file("./magnet.xml");
    }

    __declspec(dllexport) void SendSelectFiles(const char* files[], int fileCount) {
        std::cout << "SendSelectFiles Basladi" << std::endl;
        for (int i = 0; i < fileCount; i++) {
            int bufferSize = 1024;
            char buffer[1024];
            SendClientFile(files[i], buffer, bufferSize);
            Sleep(100);
        }
        send(ClientSocket, S_FILE_SEND_END, strlen(S_FILE_SEND_END), 0);
    }
    
    __declspec(dllexport) void HandleFileTransfer(){
        int bufferSize = 1024;
        char buffer[1024];
        std::cout << "HandleFileTransfer Basladi" << std::endl;
        u_long availableData = 0;
        ioctlsocket(ClientSocket, FIONREAD, &availableData);
        std::cout << "availableData"<< availableData << std::endl;
        if (availableData > 0){
            int bytesReceived = recv(ClientSocket, buffer, bufferSize, 0);
            std::cout << "HandleFileTransfer recv: " << buffer << std::endl;
            buffer[bytesReceived] = '\0';
            if (strcmp(buffer, C_FILE_SEND) == 0){
                memset(buffer, 0, bufferSize);
                send(ClientSocket, OK_SEND, strlen(OK_SEND), 0);
                recv(ClientSocket, buffer, bufferSize, 0);
                bufferSize = std::stoi(FileMessageParse(buffer)[0]);
                HandleFileProcess(buffer, bufferSize);

            }else if (strcmp(buffer, C_MULTIPLE_FILE_SEND) == 0){
                memset(buffer, 0, bufferSize);
                send(ClientSocket, OK_SEND, strlen(OK_SEND), 0);
                recv(ClientSocket, buffer, bufferSize, 0);
                std::vector<std::pair<std::string, std::string>> resultMap = MultipleFileMessageParse(buffer);
                for (const auto& pair : resultMap)
                    std::cout << pair.second.c_str() << "<------>" << std::stoi(pair.first) << std::endl;

                HandleFileProcess(buffer, bufferSize, true);
            }
        }
    }

    __declspec(dllexport) void CloseServer() {
        closesocket(ClientSocket);
        closesocket(ServerSocket);
        WSACleanup();
        std::cout << "server kapandi" << std::endl;
        exit(EXIT_SUCCESS);
    }
}