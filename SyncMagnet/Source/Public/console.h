#pragma once

namespace console {
    const char *PURPLE      = "\033[95m";
    const char *CYAN        = "\033[96m";
    const char *DARKCYAN    = "\033[36m";
    const char *BLUE        = "\033[94m";
    const char *GREEN       = "\033[92m";
    const char *YELLOW      = "\033[93m";
    const char *RED         = "\033[91m";
    const char *BOLD        = "\033[1m";
    const char *DEFAULT     = "\033[0m";
    const char* BANNER = "-*-SyncMagnet-*-\n";

    void Header() {
        printf("%s%s\n%s", console::PURPLE, console::BANNER, console::DEFAULT);
        printf("%s[0] %sGet File%s\n", console::RED, console::CYAN, console::DEFAULT);
        printf("%s[1] %sSend File%s\n", console::RED, console::CYAN, console::DEFAULT);
        printf("%s[?] %sTo be continued%s\n", console::RED, console::PURPLE, console::DEFAULT);
        //printf("%s[2] %sScreen Share%s\n", console::RED, console::PURPLE, console::DEFAULT);
    }

    void Body(char chr[]) {
        printf("\n%s[~] %sConnection Started\n", console::RED, console::PURPLE);
        printf("%s[~] %sConnect From Your Address %s[%s]%s\n", console::RED, console::PURPLE, console::YELLOW, chr, console::DEFAULT);
        printf("%s[~] %sWaiting For Connection%s\n", console::RED, console::YELLOW, console::DEFAULT);
    }

    std::string Input() {
        std::string input;
        printf("%s[*] %shelmsys@sync_magnet:~$ %s",console::RED,console::PURPLE,console::YELLOW);
        std::getline(std::cin, input);
        return input;
    }
}
