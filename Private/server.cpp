#include <WinSock2.h>
#include <ws2tcpip.h>

#include <iostream>
#include <fstream>
#include <locale>
#include <string>
#include <sstream>
#include <algorithm>
#include <map>

#include "../Public/server.h"
#include "../Public/console.h"

#pragma comment(lib, "Ws2_32.lib")

Server::Server() {
    setlocale(LC_ALL, "Turkish");
    WSADATA wsaData;
    TCHAR getName[MAX_COMPUTERNAME_LENGTH + 1];
    DWORD size = MAX_COMPUTERNAME_LENGTH + 1;

    if (GetUserName(getName, &size)) {
        std::string userName(getName, getName + size - 1);
        PcUserName = userName;
    }

    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        printf("Hay Aksi!");
    }
}

void Server::Setup() {
    const int port = 1881;
    const std::string ip = GetIPv4();

    ServerSocket = socket(AF_INET, SOCK_STREAM, 0);

    ServerAddr.sin_family = AF_INET;
    inet_pton(AF_INET, ip.c_str(), &(ServerAddr.sin_addr));
    ServerAddr.sin_port = htons(port);

    bind(ServerSocket, (sockaddr*)&ServerAddr, sizeof(ServerAddr));
    listen(ServerSocket, 1);
    console::Header(ip);
    console::Body();
}

void Server::Start() {
    int ClientAddrSize = sizeof(ClientAddr);
    ClientSocket = accept(ServerSocket, (sockaddr*)&ClientAddr, &ClientAddrSize);

    bool isRun = true;
    bool isStart = false;
    while (isRun) {
        int bufferSize = 1024;
        char buffer[1024];

        if (!isStart) {
            console::ConnectedClientDisplay(GetClientDeviceName(buffer, bufferSize).c_str());
            isStart = true;
        }
        std::string input = console::Input();
        if (input == "0") {
            CreateSaveFilePathFolder();
            HandleFileTransfer(buffer, bufferSize);

        }else if (input == "1") {
            console::AlertMessage("Write File Path");
            console::AlertMessage("Cancel [n/N]");
            bool fileIsExists = false;
            while (!fileIsExists) {
                std::string input_file = console::Input();
                const std::wstring wInputFilePath(input_file.begin(), input_file.end());
                const wchar_t* wInputFile = wInputFilePath.c_str();
                if (FileExists(wInputFile)) {
                    SendClientFile(input_file, buffer, bufferSize);
                    fileIsExists = true;
                
                }else if (input_file == "n" || input_file == "N") {
                    console::AlertMessage("Canceled");
                    break;

                }else
                    console::AlertMessage("Not Valid File Path");
            }

        }else if (input == "x" || input == "X") {
            isRun = false;
            console::QuitMessage();
            Sleep(1000);
            send(ClientSocket, DISCONNECT, strlen(DISCONNECT), 0);
            Stop();
            console::Input();
            exit(EXIT_SUCCESS);
        }
    }
}

std::string Server::GetClientDeviceName(char* buffer, int& buffSize) {
    send(ClientSocket, DEVICE_NAME, strlen(DEVICE_NAME), 0);
    const int8_t recvData = recv(ClientSocket, buffer, buffSize, 0);
    const std::string deviceName = FileMessageParse(buffer)[1];
    const int8_t deviceNameLength = std::stoi(FileMessageParse(buffer)[0]);
    std::string resultData;

    for (int8_t i = 0; i < deviceNameLength; i++) {
        resultData.push_back(deviceName[i]);
    }

    return resultData;
}

void Server::SendClientFile(std::string& inputFile, char* buffer, const int& bufferSize) {
    const int fileChunkSize = 4096;
    std::ifstream file(inputFile, std::ios::binary);
    file.seekg(0, std::ios::end);
    const unsigned long fileSize = file.tellg();
    file.close();

    int counter = 0;
    std::vector<std::string> str = FileMessageParse(inputFile, counter, '\\');
    std::string fileNameSize;
    const std::string seperator = "|:FILE:|";
    fileNameSize.assign(seperator + str[counter] + seperator + std::to_string(fileSize) + seperator);
    send(ClientSocket, fileNameSize.c_str(), fileNameSize.length(), 0);
    Sleep(10);
    send(ClientSocket, FILE_CAME, strlen(FILE_CAME), 0);
    
    bool run = true;
    while (run) {
        int bytesReceived = recv(ClientSocket, buffer, bufferSize, 0);
        buffer[bytesReceived] = '\0';

        if (strcmp(buffer, FILE_SEND) == 0) {
            file.open(inputFile, std::ios::binary);
            file.seekg(0, std::ios::beg);
            int bytesSent = 0;
            int bytesToSend = 0;
            char* fileBuffer = new char[fileChunkSize];

            while (bytesSent < fileSize) {
                if (fileSize - bytesSent >= fileChunkSize)
                    bytesToSend = fileChunkSize;
                else
                    bytesToSend = fileSize - bytesSent;
                file.read(fileBuffer, bytesToSend);
                const std::string sendFile = std::string(fileBuffer, bytesToSend);
                send(ClientSocket, sendFile.c_str(), sendFile.length(), 0);
                bytesSent += bytesToSend;
                console::UploadFileDisplay(bytesSent, fileSize);
            }
            run = false;
            file.close();
            delete[] fileBuffer;
        }
    }
    console::CompleteUploadFileDisplay(fileSize);
    Sleep(10);
    send(ClientSocket, FILE_SEND_END, strlen(FILE_SEND_END), 0);
    memset(buffer, 0, sizeof(buffer));
}

void Server::HandleFileProcess(char* &buffer, int &bufferSize, bool saveMultipleFile) {
    bool isAccepted = false;

    while (!isAccepted) {
        std::string input = console::Input();
        if (!saveMultipleFile) {
            if (input == "y" || input == "Y") {
                send(ClientSocket, SINGLE, strlen(SINGLE), 0);
                SaveFileData(bufferSize, FileMessageParse(buffer)[1].c_str());
                console::AlertMessage("Saved\a");
                isAccepted = true;
            }else if(input == "n" || input == "N"){
                send(ClientSocket, DECLINE, strlen(DECLINE), 0);
                console::AlertMessage("Ignored");
                isAccepted = true;
            }

        }else {
            if (input == "y" || input == "Y") {
                send(ClientSocket, NEXT, strlen(NEXT), 0);
                std::vector<std::pair<std::string, std::string>> resultMap = MultipleFileMessageParse(buffer);
                for (const auto& pair : resultMap)
                    SaveFileData(std::stoi(pair.first), pair.second.c_str(), true);

                console::AlertMessage("Saved\a");
                isAccepted = true;
                Sleep(10);
                send(ClientSocket, FILE_SEND_END, strlen(FILE_SEND_END), 0);

            }else if (input == "n" || input == "N") {
                send(ClientSocket, DECLINE, strlen(DECLINE), 0);
                console::AlertMessage("Ignored");
                isAccepted = true;
            }
        }
    }
}

void Server::HandleFileTransfer(char* buffer, int& bufferSize) {
    console::AlertMessage("Waiting the File(s)");
    bool run = true;
    while (run) {
        int bytesReceived = recv(ClientSocket, buffer, bufferSize, 0);

        buffer[bytesReceived] = '\0';
        if (strcmp(buffer, FILE_SEND) == 0) {
            memset(buffer, 0, bufferSize);
            send(ClientSocket, OK_SEND, strlen(OK_SEND), 0);
            recv(ClientSocket, buffer, bufferSize, 0);
            bufferSize = std::stoi(FileMessageParse(buffer)[0]);
            console::GetFileAlertMessage(FileMessageParse(buffer)[1].c_str(), bufferSize);
            console::SaveFileQuestionDisplay();
            HandleFileProcess(buffer, bufferSize);
            run = false;
        
        }else if (strcmp(buffer, MULTIPLE_FILE_SEND) == 0) {
            memset(buffer, 0, bufferSize);
            send(ClientSocket, OK_SEND, strlen(OK_SEND), 0);
            recv(ClientSocket, buffer, bufferSize, 0);
            std::vector<std::pair<std::string, std::string>> resultMap = MultipleFileMessageParse(buffer);
            for (const auto& pair : resultMap)
                console::GetFileAlertMessage(pair.second.c_str(), std::stoi(pair.first),true);

            console::SaveFileQuestionDisplay();
            HandleFileProcess(buffer, bufferSize, true);
            run = false;
        }
    }
}

void Server::SaveFileData(const int& bufferSize, const char* fileName,bool allowMultiple) {
    std::ofstream file;
    file.open("C:/Users/" + PcUserName + "/Documents/SyncMagnetSave/" + fileName, std::ios::binary);
    char* dynamicBuffer = new char[bufferSize];
    int readBytes = 0;
    while (readBytes < bufferSize) {
        int recvData = recv(ClientSocket, (dynamicBuffer + readBytes), (bufferSize - readBytes), 0);
        readBytes += recvData;
        file.write((dynamicBuffer + readBytes - recvData), recvData);
        console::DownloadFileDisplay(readBytes, bufferSize);
    }
    printf("\n");
    file.close();
    delete[] dynamicBuffer;

    if (allowMultiple)
        send(ClientSocket, "NEXT", strlen("NEXT"), 0);
}

std::vector<std::string> Server::FileMessageParse(std::string message, int& msgLen, const char seperator) {
    std::stringstream sstream;
    std::string temp;
    std::vector<std::string> resultVector;
    int count = 0;
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

std::vector<std::pair<std::string, std::string>> Server::MultipleFileMessageParse(string message){
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

std::string Server::GetIPv4() const{
    system("ipconfig > ./ipconfig.txt");
    std::ifstream file("./ipconfig.txt");

    std::string line;
    const std::string ipv4Prefix = "   IPv4 Address. . . . . . . . . . .";
    std::string ipAddress;

    while (std::getline(file, line)) {
        if (line.find(ipv4Prefix) != std::string::npos) {
            std::string::size_type pos = line.find(ipv4Prefix);
            if (pos != std::string::npos) {
                ipAddress = line.substr(pos + ipv4Prefix.length() + 1);
                ipAddress.erase(0, ipAddress.find_first_not_of(" \n\r\t:"));
                break;
            }
        }
    }

    file.close();

    if (std::remove("./ipconfig.txt") != 0) {
        std::cerr << "Dosya silinemedi!" << std::endl;
    }

    return ipAddress;
}

bool Server::FolderExists(const wchar_t* folderPath) const {
    DWORD attributes = GetFileAttributesW(folderPath);
    return (attributes != INVALID_FILE_ATTRIBUTES && (attributes & FILE_ATTRIBUTE_DIRECTORY));
}

bool Server::FileExists(const wchar_t* filePath) const {
    DWORD attributes = GetFileAttributesW(filePath);
    return (attributes != INVALID_FILE_ATTRIBUTES && !(attributes & FILE_ATTRIBUTE_DIRECTORY));
}

void Server::CreateSaveFilePathFolder() const {
    std::wstring folderPath = L"C:/Users/" + std::wstring(PcUserName.begin(), PcUserName.end()) + L"/Documents/SyncMagnetSave";

    if (!FolderExists(folderPath.c_str())) {
        if (CreateDirectoryW(folderPath.c_str(), NULL)) {
            std::wcout << L"Klasör başarıyla oluşturuldu: " << folderPath << std::endl;

        }else {
            DWORD error = GetLastError();
            if (error == ERROR_ALREADY_EXISTS) {
                std::wcout << L"Klasör zaten mevcut: " << folderPath << std::endl;

            }else {
                std::wcerr << L"Klasör oluşturma hatası (" << error << L"): " << folderPath << std::endl;
            }
        }
    }
}

void Server::Stop() const {
    closesocket(ClientSocket);
    closesocket(ServerSocket);
    WSACleanup();
}
