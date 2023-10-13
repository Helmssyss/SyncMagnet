from PyQt5.QtWidgets import QListWidget
from PyQt5.QtGui import QDragEnterEvent,QDragMoveEvent,QDropEvent
from PyQt5.QtCore import Qt

from src.funcs.sync_style import SYNC_LISTWIDGET_STYLE

class SyncListWidget(QListWidget):
    def __init__(self, parent) -> None:
        super().__init__(parent)
        self.setAcceptDrops(True)
        self.setStyleSheet(SYNC_LISTWIDGET_STYLE)
    
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
    
    def dropEvent(self, event: QDropEvent) -> None:
        if event.mimeData().hasUrls():
            event.setDropAction(Qt.CopyAction)
            event.accept()

            links:list[str] = []
            for link in event.mimeData().urls():
                if link.isLocalFile():
                    links.append(link.toLocalFile())
            
            self.addItems(links)
        
        else:
            event.ignore()