import ctypes
import os
from socket                        import gethostbyname
from socket                        import gethostname
from src.widgets.sync_list_widget  import SyncListWidget

class SyncMagnetDllService():
    currentfileIsSending = None
    _clientName:str = ""
    def __init__(self) -> None:
        self._dllPath:str = r".\sync_service.dll" # /src/service/DLL
        self.__magnetDll:ctypes.CDLL = None

    def LoadMagnetDll(self) -> bool:
        """ Check for exist of dll file"""

        if os.path.exists(self._dllPath):
            return True
        else:
            return False

    def ManageDllStarted(self):
        """ Start to server"""
        try:
            self.__magnetDll = ctypes.CDLL(name=self._dllPath)
        except FileNotFoundError:
            self.__magnetDll = ctypes.CDLL(name=self._dllPath,winmode=0)
        finally:
            self.__magnetDll.SetupServer(gethostbyname(gethostname()).encode())
            self.__magnetDll.StartServer()

    def ManageDllFinished(self):
        "Stop to server"
        self.__magnetDll.CloseServer()
    
    def SelectSendDllFilePath(self, sendListWidget: SyncListWidget):
        """ Files send """
        
        file_info_list = []
        for i in range(sendListWidget.count()):
            item = sendListWidget.item(i)
            if item and item.isSelected():
                file_name = item.text()
                file_size = os.path.getsize(file_name)
                file_info_list.append((file_size, file_name))

        sorted_file_info_list = sorted(file_info_list, key=lambda x: x[0], reverse=True)

        cxx_file_list = [ctypes.c_char_p(file_info[1].encode('utf-8')) for file_info in sorted_file_info_list]
        cxx_file_array = (ctypes.c_char_p * len(cxx_file_list))(*cxx_file_list)
        file_count = len(sorted_file_info_list)
        self.__magnetDll.SendSelectFiles(cxx_file_array, file_count)
        
        return sorted_file_info_list
            
    def HandleFileTransfer(cls):
        return cls.__magnetDll.HandleFileTransfer()
    
    def GetCurrentDownloadFileSize(self) -> int:
        """ Size of the currently downloaded file (bytes)"""

        return self.__magnetDll.GetCurrentDownloadFileSize()
    
    def GetCurrentTotalDownloadFileSize(self) -> int:
        """ Total size the file to will download now (byte)"""

        return self.__magnetDll.GetCurrentTotalDownloadFileSize()

    def GetIsLoadFile(self):
        """ True if the file is downloading now, if not downloading file is False"""
        return self.__magnetDll.GetIsLoadFile()

    def GetIsDownloadCompletedFile(self) -> bool:
        """ dosya indirme bittiyse True, bitmediyse False """
        return self.__magnetDll.GetIsDownloadCompletedFile()

    def CanGetDeviceState(self) -> bool:
        """is the file sending,True if file sending if not send file is false."""
        return self.__magnetDll.CanGetDeviceState()

    def GetDeviceBatteryStatus(self):
        return self.__magnetDll.GetDeviceBatteryStatusPerSecond()

    def SetCanDeviceState(self,state: bool):
        return self.__magnetDll.SetCanDeviceState(state)

    def SetTransferMode(self,mode: bool):
        self.__magnetDll.SetTransferMode(mode)
    
    def GetonDisconnectDevice(self) -> bool:
        "Is connection closed?"
        return self.__magnetDll.GetonDisconnectDevice()

    def formatSize(self,byte) -> str:
        """ file size conversion"""

        if byte < 1024:
            return f"{byte} B"
        
        elif byte < 1024 ** 2:
            sizekb = byte / 1024
            return f"{sizekb:.2f} KB"
        
        elif byte < 1024 ** 3:
            sizemb = byte / (1024 ** 2)
            return f"{sizemb:.2f} MB"
        
        else:
            sizegb = byte / (1024 ** 3)
            return f"{sizegb:.2f} GB"