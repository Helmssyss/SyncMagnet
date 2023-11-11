# -*- coding: utf-8 -*-

from PyQt5.QtCore           import *
from PyQt5.QtGui            import *
from PyQt5.QtWidgets        import *
from src.funcs.sync_style   import SyncStyle
from src.funcs.sync_workers import SyncLoadPageCDWorker
from src.widgets            import SyncListWidget

class LoadWindow(QWidget):
    def __init__(self, parent: QWidget, dll, isDownload = True) -> None:
        super().__init__(parent)
        self.dll = dll
        self.isDownload = isDownload
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.setAttribute(Qt.WA_TranslucentBackground)
        self.setupUi(self)

    def setupUi(self, Form):
        Form.resize(357, 200)
        Form.setMinimumSize(QSize(357, 200))
        Form.setMaximumSize(QSize(357, 200))
        Form.setStyleSheet(SyncStyle.serverPageMainFrame)
        self.frame = QFrame(Form)
        self.frame.installEventFilter(self)
        self.frame.setGeometry(QRect(0, 0, 357, 201))
        self.frame.setStyleSheet("QFrame{background-color:rgb(34, 39, 50);border-radius:10px;}")
        self.frame.setFrameShape(QFrame.StyledPanel)
        self.frame.setFrameShadow(QFrame.Raised)
        self.downloadedFileListWidget = SyncListWidget(self.frame)
        self.downloadedFileListWidget.setAcceptDrops(False)
        self.downloadedFileListWidget.setGeometry(QRect(10, 100, 341, 97))
        self.totalDownloadLabel = QLabel(self.frame)
        self.totalDownloadLabel.setGeometry(QRect(120, 30, 161, 31))
        self.__font = QFont()
        self.__font.setFamily(u"Segoe UI")
        self.__font.setPointSize(10)
        self.__font.setBold(True)
        self.__font.setItalic(True)
        self.__font.setWeight(50)
        self.downloadedFileListWidget.setFont(self.__font)
        self.totalDownloadLabel.setFont(self.__font)
        self.totalDownloadLabel.setStyleSheet("color: rgb(85, 170, 255);")
        self.totalDownloadLabel.setTextFormat(Qt.RichText)
        self.totalDownloadLabel.setAlignment(Qt.AlignCenter)
        self.progressBar = QProgressBar(self.frame)
        self.progressBar.setGeometry(QRect(20, 70, 311, 21))
        self.progressBar.setStyleSheet(SyncStyle.loadPageProgressBar)
        self.progressBar.setValue(24)
        self.progressBar.setTextVisible(False)

        QMetaObject.connectSlotsByName(Form)

        self.currentDownloadSizeWorker = SyncLoadPageCDWorker(self.isDownload)
        self.currentDownloadSizeThread = QThread(self)
        self.currentDownloadSizeWorker.moveToThread(self.currentDownloadSizeThread)
        self.currentDownloadSizeThread.started.connect(self.currentDownloadSizeWorker.start)
        self.currentDownloadSizeThread.start()
        self.currentDownloadSizeWorker.connectCurrentLoadSize.connect(self.manage)
        self.currentDownloadSizeWorker.connectCurrentLoadFileName.connect(self.appendListWidget)

    @pyqtSlot(int)
    def manage(self, size: int):
        self.totalDownloadLabel.setGeometry(QRect(120, 30, 161, 31))
        self.totalDownloadLabel.setText(f"""<html><head/><body><p><span style="font-size:16pt;">{self.dll.formatSize(size).replace('K','').replace('B','').replace('M','').replace('G','')} </span><span style="font-size:16pt; vertical-align:super;">{self.dll.formatSize(self.dll.GetCurrentTotalDownloadFileSize())}</span></p></body></html>""")
        self.progressBar.setMaximum(self.dll.GetCurrentTotalDownloadFileSize())
        self.progressBar.setValue(size)
        fSize = self.dll.GetCurrentDownloadFileSize()
        tFSize = self.dll.GetCurrentTotalDownloadFileSize()
        if size == 1:
            self.totalDownloadLabel.setGeometry(QRect(100, 30, 161, 31))
            self.totalDownloadLabel.setText("""<html><span style="font-size:16pt;">Done</span></html>""")

        if fSize == 1 and tFSize == 1:
            self.currentDownloadSizeWorker.setRunState(False)
            self.currentDownloadSizeThread.quit()
            self.currentDownloadSizeThread.wait()

    @pyqtSlot(str)
    def appendListWidget(self,item: str):
        listItem = QListWidgetItem(item)
        if self.isDownload:
            listItem.setIcon(QIcon(":/20x20/assets/20x20/cil-vertical-align-bottom.png"))
            self.downloadedFileListWidget.addItem(listItem)
        else:
            listItem.setIcon(QIcon(":/20x20/assets/20x20/cil-vertical-align-top.png"))
            self.downloadedFileListWidget.addItem(listItem)

    def eventFilter(self, source: QObject, event: QEvent) -> bool:
        if source == self.frame:
            if event.type() == QEvent.MouseButtonPress:
                self.offset = event.pos()
                
            elif event.type() == QEvent.MouseMove and self.offset is not None:
                self.move(self.pos() - self.offset + event.pos())
                return True
            
            elif event.type() == QEvent.MouseButtonRelease:
                self.offset = None
        return super().eventFilter(source, event)