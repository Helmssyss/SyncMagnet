# -*- coding: utf-8 -*-

# ##### ===> LIBRARIES
import xml.etree.ElementTree    as ET
from time                       import sleep
from PyQt5.QtCore               import QObject
from PyQt5.QtCore               import pyqtSignal
from src.funcs.sync_dll_service import SyncMagnetDllService
from requests                   import get as requestGet
from requests.exceptions        import RequestException
# ##### ===> LIBRARIES

# ## => CONST
__DLL_SERVICE__ = SyncMagnetDllService()
CACHE_DOWNLOAD_FILE = set()
CACHE_UPLOAD_FILE = set()
# ## => CONST

# ##### ===> SyncConnectWorker
class SyncConnectWorker(QObject):
    connectStart = pyqtSignal(dict)
        
    def start(self) -> None:
        __DLL_SERVICE__.ManageDllStarted()
        self.connectStart.emit({"isConnect": True, "this":__DLL_SERVICE__})
# ##### ===> SyncConnectWorker

# ##### ===> SyncClientInfoWorker
class SyncClientInfoWorker(QObject):
    connectGetClientInfo = pyqtSignal(dict)
    def __init__(self) -> None:
        super().__init__()
        self.__runWorker = True

    def setRunState(self,newState:bool) -> None:
        self.__runWorker = newState

    def start(self) -> None:
        while self.__runWorker:
            while __DLL_SERVICE__.CanGetDeviceState():
                try:
                    root = ET.parse(r".\MagnetManifest.xml")
                    device = root.find('.//Device')
                    device_name = device.attrib["device_name"]
                    device_battery = int(device.attrib["device_battery"])
                    self.connectGetClientInfo.emit({"device_name":device_name,"device_battery":device_battery})
                    __DLL_SERVICE__.GetDeviceBatteryStatus()

                except Exception as E:
                    # print("SyncClientInfoWorker ERROR: ",E)
                    pass

                finally:
                    # print("SyncClientInfoWorker START")
                    sleep(0.6)
            sleep(0.6)
# ##### ===> SyncClientInfoWorker

# ##### ===> SyncFileSenderWorker
class SyncFileSenderWorker(QObject):
    sendCompleted = pyqtSignal(list)
    def __init__(self, sendListWidget):
        super().__init__()
        self.__sendListWidget = sendListWidget

    def start(self):
        sendFiles = __DLL_SERVICE__.SelectSendDllFilePath(self.__sendListWidget)
        self.sendCompleted.emit(sendFiles)
# ##### ===> SyncFileSenderWorker

# ##### ===> SyncFileDownloadWorker
class SyncFileDownloadWorker(QObject):
    onConnectDownload = pyqtSignal(dict)
    def __init__(self) -> None:
        super().__init__()
        self.__runWorker = True

    def setRunState(self,newState:bool) -> None:
        self.__runWorker = newState

    def start(self):
        while self.__runWorker:
            __DLL_SERVICE__.HandleFileTransfer()
            self.onConnectDownload.emit({"state":__DLL_SERVICE__.GetIsDownloadCompletedFile(),"dFiles":CACHE_DOWNLOAD_FILE})
            # print("__DLL_SERVICE__.HandleFileTransfer()")
            sleep(0.6)
# ##### ===> SyncFileDownloadWorker

# ##### ===> SyncDownloadFileListener
class SyncLoadFileListener(QObject):
    connectShowLoadPage = pyqtSignal(bool)
    def __init__(self) -> None:
        super().__init__()
        self.__runState = True
    
    def setRunState(self,newRunState: bool):
        self.__runState = newRunState

    def listen(self):
        while self.__runState:
            state = __DLL_SERVICE__.GetIsLoadFile()
            if state:
                self.connectShowLoadPage.emit(True)

            if __DLL_SERVICE__.GetCurrentTotalDownloadFileSize() == 1:
                self.connectShowLoadPage.emit(False)
            sleep(0.6)
# ##### ===> SyncDownloadFileListener

# ##### ===> SyncProcessRunWorker
class SyncProcessRunWorker(QObject):
    isBackground = pyqtSignal(bool)
    def __init__(self,application) -> None:
        super().__init__()
        self.__runWorker = True
        self.__application = application

    def setRunState(self,newState:bool) -> None:
        self.__runWorker = newState

    def start(self):
        while self.__runWorker:
            if self.__application.activeWindow() is not None:
                self.isBackground.emit(False)
            else:
                self.isBackground.emit(True)
            sleep(0.6)
# ##### ===> SyncProcessRunWorker

# ##### ===> SyncLoadPageCDWorker
class SyncLoadPageCDWorker(QObject):
    connectCurrentLoadSize = pyqtSignal(int)
    connectCurrentLoadFileName = pyqtSignal(str)
    def __init__(self,) -> None:
        super().__init__()
        self.__runWorker = True

    def setRunState(self, newState: bool) -> None:
        self.__runWorker = newState

    def start(self):
        while self.__runWorker:
            try:
                fSize = __DLL_SERVICE__.GetCurrentDownloadFileSize()
                self.connectCurrentLoadSize.emit(fSize)
                root = ET.parse(r".\MagnetManifest.xml")
                getDownloadFile = root.findall('.//GetFile')
                getUploadFile = root.findall('.//SendFile')
                if getDownloadFile:
                    for i in getDownloadFile:
                        file = i.attrib["file"]
                        if file not in CACHE_DOWNLOAD_FILE:
                            self.connectCurrentLoadFileName.emit(file)
                            CACHE_DOWNLOAD_FILE.add(file)

                if getUploadFile:
                    for j in getUploadFile:
                        file = j.attrib['file']
                        if file not in CACHE_UPLOAD_FILE:
                            self.connectCurrentLoadFileName.emit(file)
                            CACHE_UPLOAD_FILE.add(file)
            except Exception as E:
                print("ERR: -> ",E)
                continue
            finally:
                sleep(0.6)
# ##### ===> SyncLoadPageCDWorker


# #### ====> SyncCheckNetWorker
class SyncCheckNetWorker(QObject):
    checkNet = pyqtSignal(bool)
    def __init__(self) -> None:
        super().__init__()
        self.__run = True
    
    def setRunState(self, newRunState: bool):
        self.__run = newRunState

    def checkStart(self):
        while self.__run:
            try:
                response = requestGet("https://www.google.com")
                response.raise_for_status()
                self.checkNet.emit(True)
            except RequestException:
                self.checkNet.emit(False)
            finally:
                sleep(0.1)
# #### ====> SyncCheckNetWorker