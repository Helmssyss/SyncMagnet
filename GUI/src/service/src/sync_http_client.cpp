#include "sync_http_client.hpp"
#include <string>
#include <fstream>

size_t Callback(void *contents, size_t size, size_t nmemb, void *userp){
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

void HttpGetRequest(const char *url){
    if(HttpStart() != nullptr){
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, Callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }
}

void Changelog(){
    std::ofstream logFile("./CHANGELOG.md");
    logFile.write(readBuffer.c_str(),strlen(readBuffer.c_str()));
    logFile.close();
}