from PyQt5.QtWidgets import QListWidget,QAbstractItemView,QListWidgetItem
from PyQt5.QtGui import QDragEnterEvent,QDragMoveEvent,QDropEvent
from PyQt5.QtCore import Qt

from src.funcs.sync_style import SyncStyle

class SyncListWidget(QListWidget):
    def __init__(self, parent) -> None:
        super().__init__(parent)
        
        self.setAcceptDrops(True)
        self.setStyleSheet(SyncStyle.serverPageSendListWidget)
        self.setSelectionMode(QAbstractItemView.MultiSelection)
    
    def dragEnterEvent(self, e: QDragEnterEvent) -> None:
        if e.mimeData().hasUrls():
            e.accept()
        else:
            e.ignore()
    
    def dragMoveEvent(self, e: QDragMoveEvent) -> None:
        if e.mimeData().hasUrls():
            for url in e.mimeData().urls():
                if url.toLocalFile().endswith(".apk") or url.toLocalFile().endswith(".rar"):
                    e.ignore()
                    return
            
            e.accept()
        else:
            e.ignore()

    def selectAllItems(self):
        for i in range(self.count()):
            item = self.item(i)
            item.setSelected(True)
    
    def unSelectAllItems(self):
        for i in range(self.count()):
            item = self.item(i)
            item.setSelected(False)

    def deleteSelectedItem(self,item:QListWidgetItem):
        self.takeItem(self.row(item))

    def dropEvent(self, event: QDropEvent) -> None:
        if event.mimeData().hasUrls():
            event.setDropAction(Qt.CopyAction)
            event.accept()
            for link in event.mimeData().urls():
                if link.isLocalFile():
                    link_ = QListWidgetItem(link.toLocalFile())
                    # link_.setTextAlignment(Qt.AlignLeading | Qt.AlignVCenter)
                    self.addItem(link_)