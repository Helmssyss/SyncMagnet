class SyncUpdateSystem{
    public:
        SyncUpdateSystem();
        ~SyncUpdateSystem();
        void CheckVersion() const;
        void NewDownloadApp() const;
        void DeleteOldApp() const;
};