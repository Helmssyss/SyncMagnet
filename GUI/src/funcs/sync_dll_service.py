import ctypes
import os

from socket import gethostbyname, gethostname

from src.widgets.sync_list_widget import SyncListWidget

class SyncMagnetDllService:
    def __init__(self) -> None:
        self._dllPath:str = r".\src\service\magnet_service.dll"
        self._magnetDll:ctypes.CDLL = None
        self._clientName:str = ""
    
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
    
    def ManageDllStarted(self) -> bool:
        """ Server'i Başlat """
        self._magnetDll.StartServer()
        return True

    def ManageDllFinished(self) -> None:
        self._magnetDll.CloseServer()
        
    
    def SelectSendDllFilePath(self,listWidget:SyncListWidget):
        file_info_list:list[tuple[str,int]] = []
        items = listWidget.selectedItems()
        for item in items:
            file_name = item.text()
            file_size = os.path.getsize(file_name)
            file_info_list.append((file_name.encode('utf-8'), file_size))

        sorted_file_info_list = sorted(file_info_list, key=lambda x: x[1], reverse=True)
        cxx_file_list = [ctypes.c_char_p(file_info[0]) for file_info in sorted_file_info_list]
        cxx_file_array = (ctypes.c_char_p * len(cxx_file_list))(*cxx_file_list)
        file_count = len(sorted_file_info_list)
        return self._magnetDll.SendSelectFiles(cxx_file_array,file_count)
    
    def HandleFileTransfer(self):
        return self._magnetDll.HandleFileTransfer()