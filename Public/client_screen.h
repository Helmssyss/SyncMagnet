#pragma once

#ifndef UNICODE
    #define UNICODE
#endif

#include <Windows.h>

namespace Screen {
    const wchar_t winClass[] = L"ClientScreenClass";
    constexpr const wchar_t screenTitle[] = L"Empty Screen";

    LRESULT CALLBACK ScreenWinProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    int WINAPI CreateScreen();
}
