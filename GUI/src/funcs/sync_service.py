import ctypes
import os

from PyQt5.QtCore import QObject

from socket import gethostbyname, gethostname

class SyncMagnetDllService(QObject):
    _dllPath:str = r".\src\service\magnet_service.dll"
    _magnetDll:ctypes.CDLL = None
    _clientName:str = ""
    
    def LoadMagnetDll(self) -> bool:
        """ Dll dosyasının varlığını kontrol et """
        if os.path.exists(self._dllPath):
            try:
                self._magnetDll = ctypes.CDLL(name=self._dllPath)
            except FileNotFoundError:
                self._magnetDll = ctypes.CDLL(name=self._dllPath,winmode=0)
            finally:
                self._magnetDll.SetupServer(gethostbyname(gethostname()).encode())
                return True
        
        else:
            return False
    
    def SetManageDll(self) -> None:
        """ Server'i Başlat """
        self._magnetDll.StartServer()

    def ManageDllFinished(self) -> None:
        self._magnetDll.CloseServer()
    
    def SelectSendDllFilePath(self,c_file_array: ctypes.Array[ctypes.c_char_p],file_count:int) -> None:
        self._magnetDll.SendSelectFiles(c_file_array,file_count)