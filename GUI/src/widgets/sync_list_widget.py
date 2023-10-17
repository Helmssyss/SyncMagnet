from PyQt5.QtWidgets import QListWidget,QAbstractItemView,QListWidgetItem
from PyQt5.QtGui import QDragEnterEvent,QDragMoveEvent,QDropEvent
from PyQt5.QtCore import Qt

from src.funcs.sync_style import SYNC_LISTWIDGET_STYLE

class SyncListWidget(QListWidget):
    def __init__(self, parent) -> None:
        super().__init__(parent)
        
        self.setAcceptDrops(True)
        self.setStyleSheet(SYNC_LISTWIDGET_STYLE)
        self.setSelectionMode(QAbstractItemView.MultiSelection)
    
    def dragEnterEvent(self, e: QDragEnterEvent) -> None:
        if e.mimeData().hasUrls():
            e.accept()
        else:
            e.ignore()
    
    def dragMoveEvent(self, e: QDragMoveEvent) -> None:
        if e.mimeData().hasUrls():
            e.setDropAction(Qt.CopyAction)
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

    def dropEvent(self, event: QDropEvent) -> None:
        if event.mimeData().hasUrls():
            event.setDropAction(Qt.CopyAction)
            event.accept()

            for link in event.mimeData().urls():
                if link.isLocalFile():
                    link_ = QListWidgetItem(link.fileName())
                    link_.setTextAlignment(Qt.AlignHCenter)
                    self.addItem(link_)
        
        else:
            event.ignore()