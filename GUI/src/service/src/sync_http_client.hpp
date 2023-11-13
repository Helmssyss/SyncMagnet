#pragma once
#include <curl/curl.h>
#include <string>

#define CHANGELOG "https://raw.githubusercontent.com/Helmssyss/SyncMagnet/main/CHANGELOG.md"

static CURL *curl;
static CURLcode res;
static std::string readBuffer;

static size_t Callback(void *contents, size_t size, size_t nmemb, void *userp);
void HttpGetRequest(const char *url);
void Changelog();
inline CURL *HttpStart(void) { return curl = curl_easy_init(); }