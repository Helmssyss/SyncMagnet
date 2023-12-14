#ifndef SYNCUPDATE
#   define SYNCUPDATE
#endif

class SYNCUPDATE SyncUpdateSystem{
    public:
        SyncUpdateSystem();
        ~SyncUpdateSystem();
        void CheckVersion() const;
        void NewDownloadApp() const;
        void DeleteOldApp() const;
};