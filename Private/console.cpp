#include <iomanip>

#include "../Public/console.h"

void console::Banner() {
    printf("%s%s\n%s", PURPLE, BANNER, DEFAULT);
}

void console::Header() {
    Banner();
    printf("%s[0] %sGet File \t\t%s[1] %sSent File%s\n", RED, CYAN, RED, CYAN, DEFAULT);
    printf("%s[x] %sClose%s\n", RED, CYAN, DEFAULT);
}

void console::Body(string chr) {
    printf("\n%s[~] %sConnection Started\n", RED, PURPLE);
    printf("%s[?] %sConnect From Your Address >>%s%s%s<<%s\n", RED, PURPLE, YELLOW, chr.c_str(), PURPLE, DEFAULT);
    printf("%s[~] %sWaiting For Connection%s\n", RED, PURPLE, DEFAULT);
}

void console::ConnectedClientDisplay(const char* client) {
    printf("\r%s[*] %sConnected Device >>%s%s%s<<%s\n", RED, PURPLE, YELLOW, client, PURPLE, DEFAULT);
}

std::string console::Input() {
    std::string input;
    printf("%s[*] %shelmsys@sync_magnet:~$ %s", RED, PURPLE, YELLOW);
    std::getline(std::cin, input);
    return input;
}

void console::GetFileAlertMessage(const char* fileName, int fileSize, bool getIsMultipleFile) {
    static int maxFileNameLength = 0;
    maxFileNameLength = std::max(maxFileNameLength, static_cast<int>(strlen(fileName)));
    if(getIsMultipleFile){
        std::string spacing(maxFileNameLength - strlen(fileName), ' ');
        std::cout << RED << "[#] "
            << YELLOW << fileName << spacing << "  " << std::fixed << std::setprecision(6) << " " << (float)fileSize / (1024 * 1024) << " "
            << PURPLE << ((float)fileSize / (1024 * 1024) >= 1 ? "MB" : "KB")<< DEFAULT << std::endl;
        
    }else {
        printf("%s[!] %sFile Name: %s%s\n%s[!] %sFile Size: %s%f %s%s\n",
            RED, PURPLE, YELLOW, fileName, RED, PURPLE, YELLOW, (float)fileSize / (1024 * 1024),
            (float)fileSize / (1024 * 1024) >= 1 ? "MB" : "KB", DEFAULT
        );
    }
}

void console::UploadFileDisplay(const int& uploadByte, const long& fileSize) {
    printf("\r%s[~] %s%f/%f %s%s Uploading%s",
        RED, YELLOW, (float)uploadByte / (1024 * 1024),
        (float)fileSize / (1024 * 1024), PURPLE,
        (uploadByte / (1024 * 1024)) >= 1 ? "MB" : "KB", DEFAULT
    );
}

void console::CompleteUploadFileDisplay(const long& fileSize) {
    printf("\r%s[*] %s%f %s%s File Sent Upload%s\n\a",
        RED, YELLOW, (float)fileSize / (1024 * 1024), PURPLE,
        (float)(fileSize / (1024 * 1024)) >= 1 ? "MB" : "KB", DEFAULT
    );
}

void console::DownloadFileDisplay(const int& downloadByte, const long& fileSize) {
    printf("\r%s[~] %s%f/%f %s%s Downloading File%s", RED, YELLOW,
        (float)downloadByte / (1024 * 1024), (float)fileSize / (1024 * 1024),
        PURPLE, (fileSize / (1024 * 1024)) >= 1 ? "MB" : "KB", DEFAULT);
}

void console::QuitMessage() {
    system("cls");
    Banner();
    printf("%s[!] %sDisconnected%s\n", RED, PURPLE, DEFAULT);
    printf("%s[!] %sReopen to connect%s\n", RED, PURPLE, DEFAULT);
    printf("%s[!] %sPress 'Enter'%s\n", RED, PURPLE, DEFAULT);
}
