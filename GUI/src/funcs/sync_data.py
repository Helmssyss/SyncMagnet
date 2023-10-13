import ctypes
import os

from src.funcs.sync_service import SyncMagnetDllService
from src.widgets.sync_list_widget import SyncListWidget

class SyncMagnetData:
    @classmethod
    def sendSelectedItem(cls,listWidget:SyncListWidget,manageDll:SyncMagnetDllService):
        file_info_list = []
        items = listWidget.selectedItems()
        for item in items:
            file_name = item.text()
            with open(file_name, mode="rb") as file:
                file_size = os.path.getsize(file_name)
                file_info_list.append((file_name.encode('utf-8'), file_size))

        sorted_file_info_list = sorted(file_info_list, key=lambda x: x[1], reverse=True)
        c_file_list = [ctypes.c_char_p(file_info[0]) for file_info in sorted_file_info_list]
        c_file_array = (ctypes.c_char_p * len(c_file_list))(*c_file_list)
        file_count = len(sorted_file_info_list)
        manageDll.SelectSendDllFilePath(c_file_array, file_count)