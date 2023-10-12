#include <iomanip>
#include <algorithm>

#include "console.h"

void console::Banner() {
    std::cout << PURPLE << BANNER << DEFAULT <<std::endl;
}

void console::Header(string ip) {
    Banner();
    printf("\t%sYour Local IPv4 Address : %s%s\n\n", MAGENTA, ip.c_str(), DEFAULT);
    printf("%s[0] %sGet File(s)%s\n", PURPLE, MAGENTA, DEFAULT);
    printf("%s[1] %sSent File%s\n", PURPLE,MAGENTA, DEFAULT);
    printf("%s[x] %sClose%s\n", PURPLE, MAGENTA, DEFAULT);
}

void console::Body() {
    printf("\n%s[~] %sConnection Started\n", PURPLE, PURPLE);
    printf("%s[~] %sWaiting For Connection%s\n", PURPLE, PURPLE, DEFAULT);
}

void console::ConnectedClientDisplay(const char* client) {
    printf("\r%s[*] %sConnected Device >>%s%s%s<<%s\n", PURPLE, PURPLE, MAGENTA, client, PURPLE, DEFAULT);
}

std::string console::Input() {
    std::string input;
    printf("%s[*] %shelmsys@sync_magnet:~$ %s", PURPLE, PURPLE, YELLOW);
    std::getline(std::cin, input);
    return input;
}

void console::GetFileAlertMessage(const char* fileName, int fileSize, bool getIsMultipleFile) {
    printf("%s[!] %sFile Name: %s%s\n%s[!] %sFile Size: %s%f %s%s\n",
        PURPLE, PURPLE, YELLOW, fileName, PURPLE, PURPLE, YELLOW, (float)fileSize / (1024 * 1024),
        (float)fileSize / (1024 * 1024) >= 1 ? "MB" : "KB", DEFAULT
    );
}

void console::UploadFileDisplay(const int& uploadByte, const long& fileSize) {
    printf("\r%s[~] %s%f/%f %s%s Uploading%s",
        PURPLE, YELLOW, (float)uploadByte / (1024 * 1024),
        (float)fileSize / (1024 * 1024), PURPLE,
        (uploadByte / (1024 * 1024)) >= 1 ? "MB" : "KB", DEFAULT
    );
}

void console::CompleteUploadFileDisplay(const long& fileSize) {
    printf("\r%s[*] %s%f %s%s File Sent Upload%s\n\a",
        PURPLE, YELLOW, (float)fileSize / (1024 * 1024), PURPLE,
        (float)(fileSize / (1024 * 1024)) >= 1 ? "MB" : "KB", DEFAULT
    );
}

void console::DownloadFileDisplay(const int& downloadByte, const long& fileSize) {
    printf("\r%s[~] %s%f/%f %s%s Downloading File%s", PURPLE, YELLOW,
        (float)downloadByte / (1024 * 1024), (float)fileSize / (1024 * 1024),
        PURPLE, (fileSize / (1024 * 1024)) >= 1 ? "MB" : "KB", DEFAULT);
}

void console::QuitMessage() {
    system("cls");
    Banner();
    printf("%s[!] %sDisconnected%s\n", PURPLE, PURPLE, DEFAULT);
    printf("%s[!] %sReopen to connect%s\n", PURPLE, PURPLE, DEFAULT);
    printf("%s[!] %sPress 'Enter'%s\n", PURPLE, PURPLE, DEFAULT);
}
