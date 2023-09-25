#include "../Public/client_screen.h"

LRESULT CALLBACK Screen::ScreenWinProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_DESTROY:
            DestroyWindow(hwnd);
            PostQuitMessage(0);
            break;

        case WM_PAINT:
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            FillRect(hdc, &ps.rcPaint, (HBRUSH)(COLOR_WINDOW + 2));
            EndPaint(hwnd, &ps);
            break;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

int WINAPI Screen::CreateScreen(){
    WNDCLASS wc = {};
    wc.lpfnWndProc = Screen::ScreenWinProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.lpszClassName = winClass;
    RegisterClass(&wc);

    HWND hwnd = CreateWindowEx(0, winClass, screenTitle, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 300, 700, NULL, NULL, GetModuleHandle(NULL), NULL);

    ShowWindow(hwnd, SW_SHOW);
    MSG msg{};
    while (GetMessage(&msg, NULL, 0, 0) > 0) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}
