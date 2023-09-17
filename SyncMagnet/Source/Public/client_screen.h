#pragma once

#ifndef UNICODE
    #define UNICODE
#endif

#include <Windows.h>

namespace Screen {
    const wchar_t winClass[] = L"ClientScreenClass";
    constexpr const wchar_t screenTitle[] = L"Empty Screen";

    LRESULT CALLBACK ScreenWinProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
        switch (uMsg) {
            case WM_DESTROY:
                DestroyWindow(hwnd);
                PostQuitMessage(0);
                break;
        }
        return DefWindowProc(hwnd, uMsg, wParam, lParam);
    }

    int WINAPI CreateScreen() {
        WNDCLASS wc = {};
        wc.lpfnWndProc = ScreenWinProc;
        wc.hInstance = GetModuleHandle(NULL);
        wc.lpszClassName = winClass;
        RegisterClass(&wc);

        HWND hwnd = CreateWindowEx(0,winClass,screenTitle,WS_OVERLAPPEDWINDOW,CW_USEDEFAULT, CW_USEDEFAULT,300, 700,NULL,NULL,GetModuleHandle(NULL),NULL);

        ShowWindow(hwnd, SW_SHOW);
        MSG msg{};
        while (GetMessage(&msg, NULL, 0, 0) > 0) {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }

        return 0;
    }
}
