#define WIN32_LEAN_AND_MEAN

#include "./sync_service.hpp"
#include "./sync_http_client.hpp"
#include "./3rdParty/XMLib/pugixml.hpp"

#include <string>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <vector>
#include <iostream>
#include <map>
#include <algorithm>

#pragma comment(lib, "Ws2_32.lib")

static pugi::xml_document xmlDoc;
static pugi::xml_node xmlRoot = xmlDoc.append_child("SyncMagnet");
static pugi::xml_node xmlDeviceRoot = xmlRoot.append_child("Device");
static pugi::xml_node xmlFolderPath = xmlRoot.append_child("FolderPath");
static pugi::xml_node decl = xmlDoc.prepend_child(pugi::node_declaration);

std::vector<std::string> FileMessageParse(std::string message, short& msgLen, const char seperator) {
    std::stringstream sstream;
    std::string temp;
    std::vector<std::string> resultVector;
    short count = 0;
    sstream << message;

    for (char i : message)
        if (i == seperator) 
            count++;

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
        }else {
            std::string _value = parsedData[i];
            resultMap[_key] = _value;
        }
    }
    
    std::vector<std::pair<std::string, std::string>> resultVector(resultMap.begin(), resultMap.end());
    std::sort(resultVector.begin(), resultVector.end(),
        [](const std::pair<std::string, std::string>& a, const std::pair<std::string, std::string>& b) {
            return std::stoi(a.first) > std::stoi(b.first);
        }
    );

    return resultVector;
}

void XMLFile(const char* deviceName, const char* batterySize){
    if (xmlDeviceRoot) {
        pugi::xml_attribute deviceNameAttr = xmlDeviceRoot.attribute("device_name");
        pugi::xml_attribute deviceBatteryAttr = xmlDeviceRoot.attribute("device_battery");

        if (deviceNameAttr) 
            deviceNameAttr.set_value(deviceName);
        else 
            xmlDeviceRoot.append_attribute("device_name").set_value(deviceName);
        

        if (deviceBatteryAttr) 
            deviceBatteryAttr.set_value(batterySize);
        else 
            xmlDeviceRoot.append_attribute("device_battery").set_value(batterySize);
        

    } else {
        xmlDeviceRoot = xmlRoot.append_child("Device");
        xmlDeviceRoot.append_attribute("device_name").set_value(deviceName);
        xmlDeviceRoot.append_attribute("device_battery").set_value(batterySize);
    }

    xmlDoc.save_file("./MagnetManifest.xml");
}

void GetCurrentFileCompleted(const char* currentFileSendCompleted, bool isDownload) {
    if (!isDownload){ // from pc to mobile
        xmlRoot.append_child("SendFile").append_attribute("file").set_value(currentFileSendCompleted);
    }else{ // from mobile to pc
        xmlRoot.append_child("GetFile").append_attribute("file").set_value(currentFileSendCompleted);
    }
    xmlDoc.save_file("./MagnetManifest.xml");
}

void CreateSaveFilePathFolder() {
    std::wstring folderPath = L"C:/Users/" + std::wstring(PcUserName.begin(), PcUserName.end()) + L"/Documents/SyncMagnetSave";
    xmlFolderPath.append_attribute("default_folder_path");
    xmlFolderPath.attribute("default_folder_path").set_value(std::string("C:/Users/" + PcUserName + "/Documents/SyncMagnetSave").c_str());
    decl.append_attribute("version") = "1.0";
    decl.append_attribute("encoding") = "UTF-8";
    if (!FolderExists(folderPath.c_str()))
        CreateDirectoryW(folderPath.c_str(), NULL);
    xmlDoc.save_file("./MagnetManifest.xml");
}

bool FolderExists(const wchar_t* folderPath){
    DWORD attributes = GetFileAttributesW(folderPath);
    return (attributes != INVALID_FILE_ATTRIBUTES && (attributes & FILE_ATTRIBUTE_DIRECTORY));
}

bool FileExists(const wchar_t* filePath){
    DWORD attributes = GetFileAttributesW(filePath);
    return (attributes != INVALID_FILE_ATTRIBUTES && !(attributes & FILE_ATTRIBUTE_DIRECTORY));
}

void GetClientDevice(char* buffer, const int &buffSize) {
    send(ClientSocket, DEVICE, strlen(DEVICE), 0);
    const int8_t recvData = recv(ClientSocket, buffer, buffSize, 0);
    const std::string deviceName = FileMessageParse(buffer)[1];
    const int8_t deviceNameLength = std::stoi(FileMessageParse(buffer)[0]);
    const std::string resultDeviceNameData = deviceName.substr(0, deviceNameLength);
    std::string resultBatteryData = FileMessageParse(buffer)[2];
    
    if (std::stoi(resultBatteryData) > 100)
        resultBatteryData.erase(resultBatteryData.size() - 1);

    XMLFile(resultDeviceNameData.c_str(), resultBatteryData.c_str());
}

void SendClientFile(const char *inputFile, char* buffer, const int &bufferSize) {
    short fileNameCount = 0;
    std::ifstream file(inputFile, std::ios::binary);
    file.seekg(0, std::ios::end);
    const unsigned long fileSize = file.tellg();
    downloadTotalFileSize = fileSize;
    file.close();

    std::vector<std::string> str = FileMessageParse(inputFile, fileNameCount, '/');
    std::string firstFileContent;
    const std::string seperator = "|:FILE:|";
    firstFileContent = seperator + str[fileNameCount] + seperator + std::to_string(fileSize) + seperator;
    if(fileSize < 130000)
        Sleep(1000);
    else
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
            // memset(buffer, 0, sizeof(buffer));
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
                // printf("\r%i/%i", bytesSent, fileSize);
                downloadFileSize = bytesSent;
            }
            // printf("\nDosya Yuklendi\n");
            run = false;
            file.close();
            delete[] fileBuffer;
        }
    }
}

void SaveFileData(const int& bufferSize, const char* fileName){
    std::ofstream file;
    file.open("C:/Users/" + PcUserName + "/Documents/SyncMagnetSave/" + fileName, std::ios::binary);
    char* dynamicBuffer = new char[bufferSize];
    int readBytes = 0;
    downloadTotalFileSize = bufferSize;

    while (readBytes < bufferSize) {
        int recvData = recv(ClientSocket, (dynamicBuffer + readBytes), (bufferSize - readBytes), 0);
        readBytes += recvData;
        file.write((dynamicBuffer + readBytes - recvData), recvData);
        // printf("\r%i/%i", readBytes, bufferSize);
        downloadFileSize = readBytes;
    }
    // std::cout << "\nfileName: " << fileName << std::endl;

    file.close();
    delete[] dynamicBuffer;
}

void HandleFileProcess(char* buffer, const int &bufferSize, bool allowMultiple){
    isLoadFile = true;

    if (!allowMultiple){
        send(ClientSocket, SINGLE, strlen(SINGLE), 0);
        SaveFileData(bufferSize, FileMessageParse(buffer)[1].c_str());
        GetCurrentFileCompleted(FileMessageParse(buffer)[1].c_str(),true);
        isDownloadCompleted = true;
        // std::cout << "Saved" << std::endl;
    }else{
        std::vector<std::pair<std::string, std::string>> resultMap = MultipleFileMessageParse(buffer);
        for (const auto& pair : resultMap){
            isDownloadCompleted = false;
            send(ClientSocket, NEXT, strlen(NEXT), 0);
            // std::cout << pair.second.c_str() << "<------>" << std::stoi(pair.first) << std::endl;
            SaveFileData(std::stoi(pair.first), pair.second.c_str());
            GetCurrentFileCompleted(pair.second.c_str(),true);
            isDownloadCompleted = true;
        }
        // std::cout << "Saved Multiple File" << std::endl;
        Sleep(10);
    }
}

SYNCAPI void SetupServer(const char* ipAddr) {
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
        CreateSaveFilePathFolder();
    }
    bind(ServerSocket, (sockaddr*)&ServerAddr, sizeof(ServerAddr));
    listen(ServerSocket, 1);
}

SYNCAPI void StartServer() {
    try{
        int ClientAddrSize = sizeof(ClientAddr);
        ClientSocket = accept(ServerSocket, (sockaddr*)&ClientAddr, &ClientAddrSize);
        GetClientDevice(buffer, 1024);
        isCanGetDeviceState = true;
        
    }catch(const std::exception& e){
        // std::cerr << e.what() << '\n';
    }
}

SYNCAPI void SendSelectFiles(const char* *files, int fileCount) {
    sendFinished = false;
    isCanGetDeviceState = false;
    isLoadFile = true;
    // std::cout << "SendSelectFiles Basladi" << std::endl;
    for (int i = 0; i < fileCount; i++){
        SendClientFile(files[i], buffer, bufferSize);
        Sleep(1000);
        GetCurrentFileCompleted(files[i]); // 
    }
    downloadFileSize = 1;
    downloadTotalFileSize = 1;
    send(ClientSocket, FILE_SEND_END, strlen(FILE_SEND_END), 0);
    sendFinished = true;
    isCanGetDeviceState = true;
    isLoadFile = false;
}

SYNCAPI void HandleFileTransfer(){
    try{
        isCanGetDeviceState = false;
        isDownloadCompleted = false;
        u_long availableData = 0;
        ioctlsocket(ClientSocket, FIONREAD, &availableData);
        if (availableData > 0){
            int bytesReceived = recv(ClientSocket, buffer, 1024, 0);
            // std::cout << "HandleFileTransfer recv: " << buffer << std::endl;
            buffer[bytesReceived] = '\0';
            if (strcmp(buffer, C_FILE_SEND) == 0){
                memset(buffer, 0, sizeof(buffer));
                send(ClientSocket, OK_SEND, strlen(OK_SEND), 0);
                Sleep(10);
                recv(ClientSocket, buffer, 1024, 0);
                HandleFileProcess(buffer, std::stoi(FileMessageParse(buffer)[0]));
            }
            if (strcmp(buffer, C_MULTIPLE_FILE_SEND) == 0){
                memset(buffer, 0, sizeof(buffer));
                send(ClientSocket, OK_SEND, strlen(OK_SEND), 0);
                Sleep(10);
                recv(ClientSocket, buffer, 1024, 0);
                HandleFileProcess(buffer, 1024, true);
            }
            send(ClientSocket, FILE_SEND_END, strlen(FILE_SEND_END), 0);
            // std::cout << "isCanGetDeviceState -> " << isCanGetDeviceState << std::endl;
            downloadTotalFileSize = 1;
            downloadFileSize = 1;
        }
        isLoadFile = false;
    }catch(const std::exception& e){
        // std::cerr << "BIR HATA OLUSTU ----> " << e.what() << '\n';
    }
}

SYNCAPI void CloseServer() {
    Sleep(100);
    send(ClientSocket, DISCONNECT, strlen(DISCONNECT), 0);
    closesocket(ClientSocket);
    closesocket(ServerSocket);
    WSACleanup();
    std::cout << "server kapandi" << std::endl;
    isCanGetDeviceState = false;
}

SYNCAPI void GetChangeLog(){
    HttpGetRequest(CHANGELOG);
    Changelog();
}