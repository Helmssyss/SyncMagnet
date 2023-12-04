#include "./sync_update.hpp"
int main(int argc, char const *argv[]){
    SyncUpdateSystem *system = new SyncUpdateSystem();
    system->CheckVersion();
    return 0;
}