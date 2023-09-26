#pragma once

#include <iostream>
#include <string>

using namespace std;

namespace console {
    constexpr const char* PURPLE = "\033[95m";
    constexpr const char* CYAN = "\033[96m";
    constexpr const char* DARKCYAN = "\033[36m";
    constexpr const char* BLUE = "\033[94m";
    constexpr const char* GREEN = "\033[92m";
    constexpr const char* YELLOW = "\033[93m";
    constexpr const char* RED = "\033[91m";
    constexpr const char* BOLD = "\033[1m";
    constexpr const char* DEFAULT = "\033[0m";
    constexpr const char* BANNER = "-*-SyncMagnet-*-\n";

    inline void SaveFileQuestionDisplay() { printf("%s[~] %sSave File [%sy-Y%s/%sn-N%s]%s\n", RED, PURPLE, YELLOW, PURPLE, YELLOW, PURPLE, DEFAULT); }
    inline void AlertMessage(const char* msg) { printf("\n%s[~] %s%s%s\n", RED, PURPLE, msg, DEFAULT); }

    void Banner();
    void Header();
    void QuitMessage();
    void Body(string chr);
    void ConnectedClientDisplay(const char* client);
    void GetFileAlertMessage(const char* fileName, int fileSize);
    void UploadFileDisplay(const int& uploadByte, const long& fileSize);
    void CompleteUploadFileDisplay(const long& fileSize);
    void DownloadFileDisplay(const int& downloadByte, const long& fileSize);
    
    string Input();
}