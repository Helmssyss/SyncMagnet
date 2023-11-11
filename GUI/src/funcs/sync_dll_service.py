import ctypes
import os
from PyQt5.QtGui                   import QIcon
from PyQt5.QtWidgets               import QTableWidgetItem
from socket                        import gethostbyname
from socket                        import gethostname
from src.widgets.sync_list_widget  import SyncListWidget
from src.widgets.sync_table_widget import SyncTableWidget

class SyncMagnetDllService():
    currentfileIsSending = None
    _dllPath:str = r".\src\service\DLL\sync_service.dll"
    __magnetDll:ctypes.CDLL = None
    _clientName:str = ""

    @staticmethod
    def getAddress() -> str:
        return gethostbyname(gethostname())

    def LoadMagnetDll(self) -> bool:
        """ Dll dosyasının varlığını kontrol et """

        if os.path.exists(self._dllPath):
            return True
        else:
            return False

    def ManageDllStarted(self):
        """ Server'i Başlat """
        try:
            self.__magnetDll = ctypes.CDLL(name=self._dllPath)
        except FileNotFoundError:
            self.__magnetDll = ctypes.CDLL(name=self._dllPath,winmode=0)
        finally:
            self.__magnetDll.SetupServer(gethostbyname(gethostname()).encode())
            self.__magnetDll.StartServer()

    def ManageDllFinished(self):
        self.__magnetDll.CloseServer()
    
    def SelectSendDllFilePath(self, sendListWidget: SyncListWidget, completedTableWidget: SyncTableWidget):
        """ DOSYALARI GÖNDER """
        
        file_info_list = []
        items_to_remove = []

        for i in range(sendListWidget.count()):
            item = sendListWidget.item(i)
            if item and item.isSelected():
                file_name = item.text()
                file_size = os.path.getsize(file_name)
                file_info_list.append((file_size, file_name))
                items_to_remove.append(item)

        sorted_file_info_list = sorted(file_info_list, key=lambda x: x[0], reverse=True)

        cxx_file_list = [ctypes.c_char_p(file_info[1].encode('utf-8')) for file_info in sorted_file_info_list]
        cxx_file_array = (ctypes.c_char_p * len(cxx_file_list))(*cxx_file_list)
        file_count = len(sorted_file_info_list)
        self.__magnetDll.SendSelectFiles(cxx_file_array, file_count)

        for row, file_info in enumerate(sorted_file_info_list):
            completedTableWidget.insertRow(row)
            size_item = QTableWidgetItem(self.formatSize(file_info[0]))
            size_item.setIcon(QIcon(":/16x16/assets/16x16/cil-check-alt.png"))
            name_item = QTableWidgetItem(file_info[1])
            completedTableWidget.setItem(row, 0, size_item)
            completedTableWidget.setItem(row, 1, name_item)

        for item in items_to_remove:
            sendListWidget.deleteSelectedItem(item)
            
    def HandleFileTransfer(cls):
        return cls.__magnetDll.HandleFileTransfer()
    
    def GetCurrentDownloadFileSize(self) -> int:
        """ şuan indirilen dosyanin boyutu (byte)"""

        return self.__magnetDll.GetCurrentDownloadFileSize()
    
    def GetCurrentTotalDownloadFileSize(self) -> int:
        """ şuan indirilecek dosyanin toplam boyutu (byte)"""

        return self.__magnetDll.GetCurrentTotalDownloadFileSize()

    def GetIsLoadFile(self):
        """ şuan dosya indiriliyorsa True indirilmiyorsa False """

        return self.__magnetDll.GetIsLoadFile()

    def CanGetDeviceState(self) -> None:
        """dosya gönderiliyor mu gönderiliyorsa True gönderilmiyorsa False"""

        return self.__magnetDll.CanGetDeviceState()

    def GetDeviceBatteryStatus(self):
        return self.__magnetDll.GetDeviceBatteryStatusPerSecond()

    def SetCanDeviceState(cls):
        return cls.__magnetDll.SetCanDeviceState()
    
    def formatSize(self,byte) -> str:
        """ Dosya boyutu birim dönüşümü """

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