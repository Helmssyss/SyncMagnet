#include "./sync_service.hpp"

#include <pugixml.hpp>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <map>
#include <algorithm>
#include <cstdint>

#pragma comment(lib, "Ws2_32.lib")

static pugi::xml_document xmlDoc;
static pugi::xml_node xmlRoot = xmlDoc.append_child("SyncMagnet");
static pugi::xml_node xmlDeviceRoot = xmlRoot.append_child("Device");
static pugi::xml_node xmlFolderPath = xmlRoot.append_child("FolderPath");
static pugi::xml_node decl = xmlDoc.prepend_child(pugi::node_declaration);

__SYNCPRIVATE std::vector<std::string> FileMessageParse(std::string message, short& msgLen, const char seperator) {
    try{
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
    }catch(const std::exception& e){
        std::cerr << "FileMessageParse -> " << e.what() << '\n';
        CloseServer();
        std::vector<std::string> r;
        return r;
    }
}

__SYNCPRIVATE std::vector<std::pair<std::string, std::string>> MultipleFileMessageParse(std::string message){
    try{
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
    }catch(const std::exception& e){
        std::cerr << "MultipleFileMessageParse -> " << e.what() << '\n';
        CloseServer();
        std::vector<std::pair<std::string, std::string>> r;
        return r;
    }
}

__SYNCPRIVATE void XMLFile(const char* deviceName, const char* batterySize){
    try{
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
    }catch(const std::exception& e){
        std::cerr << "XMLFile -> " <<e.what() << '\n';
        CloseServer();
    }
}

__SYNCPRIVATE void GetCurrentFileCompleted(const char* currentFileSendCompleted, bool isDownload) {
    try{
        if (!isDownload){ // from pc to mobile
            xmlRoot.append_child("SendFile").append_attribute("file").set_value(currentFileSendCompleted);
        }else{ // from mobile to pc
            xmlRoot.append_child("GetFile").append_attribute("file").set_value(currentFileSendCompleted);
        }
        xmlDoc.save_file("./MagnetManifest.xml");
    }catch(const std::exception& e){
        std::cerr << "GetCurrentFileCompleted -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPRIVATE void CreateSaveFilePathFolder() {
    std::wstring folderPath = L"C:/Users/" + std::wstring(PcUserName.begin(), PcUserName.end()) + L"/Documents/SyncMagnetSave";
    xmlFolderPath.append_attribute("default_folder_path");
    xmlFolderPath.attribute("default_folder_path").set_value(std::string("C:/Users/" + PcUserName + "/Documents/SyncMagnetSave").c_str());
    decl.append_attribute("version") = "1.0";
    decl.append_attribute("encoding") = "UTF-8";
    if (!FolderExists(folderPath.c_str()))
        CreateDirectoryW(folderPath.c_str(), NULL);
    xmlDoc.save_file("./MagnetManifest.xml");
}

__SYNCPRIVATE bool FolderExists(const wchar_t* folderPath){
    DWORD attributes = GetFileAttributesW(folderPath);
    return (attributes != INVALID_FILE_ATTRIBUTES && (attributes & FILE_ATTRIBUTE_DIRECTORY));
}

__SYNCPRIVATE bool FileExists(const wchar_t* filePath){
    DWORD attributes = GetFileAttributesW(filePath);
    return (attributes != INVALID_FILE_ATTRIBUTES && !(attributes & FILE_ATTRIBUTE_DIRECTORY));
}

__SYNCPRIVATE void GetClientDevice(char* buffer) {
    try{
        send(ClientSocket, DEVICE, strlen(DEVICE), 0);
        if(recv(ClientSocket, buffer, 1024, 0) != 0){
            std::cout << buffer << std::endl;
            const std::string deviceName = FileMessageParse(buffer)[1];
            const int8_t deviceNameLength = std::stoi(FileMessageParse(buffer)[0]);
            const std::string resultDeviceNameData = deviceName.substr(0, deviceNameLength);
            std::string resultBatteryData = FileMessageParse(buffer)[2];
            
            if (std::stoi(resultBatteryData) > 100)
                resultBatteryData.erase(resultBatteryData.size() - 1);

            XMLFile(resultDeviceNameData.c_str(), resultBatteryData.c_str());
        }else{
            mobileAppDisconnect = true;
            CloseServer();
        }
    }catch(const std::exception& e){
        std::cerr << "GetClientDevice -> " << e.what() << '\n';
        onDisconnect = true;
        
    }
}

__SYNCPRIVATE void SendClientFile(const char *inputFile, char* buffer, const int &bufferSize) {
    try{
        std::ifstream file(inputFile, std::ios::binary);
        file.seekg(0, std::ios::end);
        const unsigned long fileSize = file.tellg();
        downloadTotalFileSize = fileSize;
        file.close();
        
        short fileNameCount = 0;
        const std::vector<std::string> parsedFileName = FileMessageParse(inputFile, fileNameCount, '/');
        const std::string seperator = "|:MAGNET:|";
        const std::string sendDataPart = seperator + parsedFileName[fileNameCount] + seperator + std::to_string(fileSize) + seperator;
        
        if(fileSize < 100000) Sleep(1000);
        else Sleep(10);
        send(ClientSocket, sendDataPart.c_str(), strlen(sendDataPart.c_str()), 0);
        Sleep(10);
        send(ClientSocket, S_FILE_CAME, strlen(S_FILE_CAME), 0);

        bool run = true;
        while (run) {
            int bytesReceived = recv(ClientSocket, buffer, bufferSize, 0);
            buffer[bytesReceived] = '\0';

            if (strcmp(buffer, S_FILE_SEND) == 0) {
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
                    Sleep(2);
                    send(ClientSocket, sendFile.c_str(), sendFile.length(), 0);
                    bytesSent += bytesToSend;
                    downloadFileSize = bytesSent;
                }
                // printf("\nDosya Yuklendi\n");
                run = false;
                file.close();
                delete[] fileBuffer;
            }
        }   
    }catch(const std::exception& e){
        std::cerr << "SendClientFile -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPRIVATE void SaveFileData(const int& bufferSize, const char* fileName){
    try{
        std::ofstream file;
        file.open("C:/Users/" + PcUserName + "/Documents/SyncMagnetSave/" + fileName, std::ios::binary);
        char* dynamicBuffer = new char[bufferSize];
        int readBytes = 0;
        downloadTotalFileSize = bufferSize;
        while (readBytes < bufferSize) {
            int recvData = recv(ClientSocket, (dynamicBuffer + readBytes), (bufferSize - readBytes), 0);
            readBytes += recvData;
            file.write((dynamicBuffer + readBytes - recvData), recvData);
            downloadFileSize = readBytes;
        }
        file.close();
        delete[] dynamicBuffer;
    }catch(const std::exception& e){
        std::cerr << "SaveFileData -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPRIVATE void HandleFileProcess(char* buffer, const int &bufferSize, bool allowMultiple){
    try{
        isLoadFile = true;
        if (!allowMultiple){
            send(ClientSocket, SINGLE, strlen(SINGLE), 0);
            // std::cout << buffer << " bufferSize -> "<<bufferSize << std::endl;
            SaveFileData(bufferSize, FileMessageParse(buffer)[1].c_str());
            GetCurrentFileCompleted(FileMessageParse(buffer)[1].c_str(),true);
            isDownloadCompleted = true;
        }else{
            std::vector<std::pair<std::string, std::string>> resultMap = MultipleFileMessageParse(buffer);
            for (const auto& pair : resultMap){
                isDownloadCompleted = false;
                send(ClientSocket, NEXT, strlen(NEXT), 0);
                SaveFileData(std::stoi(pair.first), pair.second.c_str());
                GetCurrentFileCompleted(pair.second.c_str(),true);
                isDownloadCompleted = true;
            }
            Sleep(1);
        }
    }catch(const std::exception& e){
        std::cerr << "HandleFileProcess -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPUBLIC void SetupServer(const char* ipAddr) {
    try{
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
    }catch(const std::exception& e){
        std::cerr << "SetupServer -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPUBLIC void StartServer() {
    try{
        int ClientAddrSize = sizeof(ClientAddr);
        ClientSocket = accept(ServerSocket, (sockaddr*)&ClientAddr, &ClientAddrSize);
        GetClientDevice(buffer);
        isCanGetDeviceState = true;
        
    }catch(const std::exception& e){
        std::cerr << "StartServer -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPUBLIC void SendSelectFiles(const char* *files, int fileCount) {
    try{
        sendFinished = false;
        isCanGetDeviceState = false;
        isLoadFile = true;
        for (int i = 0; i < fileCount; i++){
            SendClientFile(files[i], buffer, bufferSize);
            Sleep(1000);
            GetCurrentFileCompleted(files[i]);
        }
        downloadFileSize = 1;
        downloadTotalFileSize = 1;
        send(ClientSocket, FILE_SEND_END, strlen(FILE_SEND_END), 0);
        sendFinished = true;
        isCanGetDeviceState = true;
        isLoadFile = false;
    }catch(const std::exception& e){
        std::cerr << "SendSelectFiles -> " <<e.what() << '\n';
        CloseServer();
    }
}

__SYNCPUBLIC void HandleFileTransfer(){
    try{
        std::cout << "isTransfer -> " << isTransfer << std::endl;
        if (isTransfer){
            send(ClientSocket, H_TRANSFER, strlen(H_TRANSFER), 0);
            std::cout << H_TRANSFER << std::endl;
            isTransfer = false;
        }
        isCanGetDeviceState = false;
        isDownloadCompleted = false;
        u_long availableData = 0;
        ioctlsocket(ClientSocket, FIONREAD, &availableData);
        if (availableData > 0){
            int bytesReceived = recv(ClientSocket, buffer, 1024, 0);
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
            downloadTotalFileSize = 1;
            downloadFileSize = 1;
        }
        isLoadFile = false;
    }catch(const std::exception& e){
        std::cerr  << "HandleFileTransfer -> " << e.what() << '\n';
        CloseServer();
    }
}

__SYNCPUBLIC void GetDeviceBatteryStatusPerSecond(){
    try{
        memset(buffer, 0, sizeof(buffer));
        if(!onDisconnect) GetClientDevice(buffer);
    }catch(const exception& e){
        std::cerr << "GetDeviceBatteryStatusPerSecond -> " <<e.what() << '\n';
        CloseServer();
    }
}

__SYNCPUBLIC void CloseServer() {
    Sleep(100);
    if(!mobileAppDisconnect){
        send(ClientSocket, DISCONNECT, strlen(DISCONNECT), 0);
        std::cout << "masaustunden kapandi" << std::endl;
    }else{
        std::cout << "mobilden kapandi" << std::endl;
    }
        
    closesocket(ClientSocket);
    closesocket(ServerSocket);
    WSACleanup();
    std::cout << "server kapandi" << std::endl;
    isCanGetDeviceState = false;
    onDisconnect = true;
    exit(0);
}

