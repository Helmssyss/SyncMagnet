#include <WinSock2.h>
#include <ws2tcpip.h>

#include <string>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <vector>
#include <iostream>

#include "./third_party/pugixml.hpp"

#pragma comment(lib, "Ws2_32.lib")

#define OK_SEND                 "OK_SEND"
#define SINGLE                  "SINGLE"
#define DECLINE                 "DECLINE"
#define DISCONNECT              "DISCONNECT"
#define DEVICE                  "DEVICE"
#define FILE_CAME               "FILE_CAME"
#define FILE_BYTE               "FILE_BYTE"
#define FILE_BYTE_TO            "FILE_BYTE_TO"
#define FILE_SEND               "FILE_SEND"
#define FILE_SEND_END           "FILE_SEND_END"
#define MULTIPLE_FILE_SEND      "MULTIPLE_FILE_SEND"
#define NEXT_TO                 "NEXT_TO"
#define NEXT                    "NEXT"
#define GET_BATTERY_STATE       "GET_BATTERY_STATE"
#define FILE_CHUNK_SIZE         4096

static short _LENGTH = 0;
static const char* deviceName = "";
static SOCKET ServerSocket{};
static SOCKET ClientSocket{};
static sockaddr_in ServerAddr{};
static sockaddr_in ClientAddr{};
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

    std::ifstream file(inputFile, std::ios::binary);
    file.seekg(0, std::ios::end);
    const unsigned long fileSize = file.tellg();
    file.close();

    short counter = 0;
    std::vector<std::string> str = FileMessageParse(inputFile, counter, '/');
    std::string fileNameSize;
    const std::string seperator = "|:FILE:|";
    fileNameSize = seperator + str[counter] + seperator + std::to_string(fileSize) + seperator;
    std::cout << fileNameSize << std::endl;
    Sleep(10);
    send(ClientSocket, fileNameSize.c_str(), strlen(fileNameSize.c_str()), 0);
    Sleep(10);
    send(ClientSocket, FILE_CAME, strlen(FILE_CAME), 0);
    Sleep(10);

    bool run = true;
    while (run) {
        int bytesReceived = recv(ClientSocket, buffer, bufferSize, 0);
        buffer[bytesReceived] = '\0';

        if (strcmp(buffer, FILE_SEND) == 0) {
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
                Sleep(1);
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

        std::cout << "StartServer fonksiyonu cagrildi" << std::endl;
        int ClientAddrSize = sizeof(ClientAddr);
        ClientSocket = accept(ServerSocket, (sockaddr*)&ClientAddr, &ClientAddrSize);
        std::cout << "StartServer basladi Client Kabul Edildi" << std::endl;

        deviceName = GetClientDeviceName(buffer, bufferSize);
        pugi::xml_node deviceNameXml = root.append_child("DeviceName");
        pugi::xml_node deviceBatteryXml = root.child("DeviceBattery");
        deviceNameXml.append_child(pugi::node_pcdata).set_value(deviceName);
        deviceBatteryXml.append_child(pugi::node_pcdata).set_value(FileMessageParse(buffer)[2].c_str());
        doc.save_file("./magnet.xml");
    }

    __declspec(dllexport) void SendSelectFiles(const char* files[], int fileCount) {
        for (int i = 0; i < fileCount; i++) {
            int bufferSize = 1024;
            char buffer[1024];
            SendClientFile(files[i], buffer, bufferSize);
            Sleep(100);
        }
        send(ClientSocket, FILE_SEND_END, strlen(FILE_SEND_END), 0);
    }

    __declspec(dllexport) void CloseServer() {
        printf("server kapandi");
        closesocket(ClientSocket);
        closesocket(ServerSocket);
        WSACleanup();
        exit(EXIT_SUCCESS);
    }
}
