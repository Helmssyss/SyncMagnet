# -*- coding: utf-8 -*-

from time import sleep
from PyQt5.QtCore                import *
from PyQt5.QtGui                 import *
from PyQt5.QtWidgets             import *
from src.funcs.sync_workers      import SyncCheckNetWorker
from src.pages.sync_connect_page import ConnectWindow
from src.funcs.sync_style        import SyncStyle
from .sync_source                import *

class CheckNetWindow(QMainWindow):
    def __init__(self,application) -> None:
        super().__init__()
        self.application = application
        self.waitcount = 0
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.setAttribute(Qt.WA_TranslucentBackground)
        self.setupUi(self)

    def setupUi(self, MainWindow: QMainWindow):
        MainWindow.resize(596, 333)
        MainWindow.setMinimumSize(QSize(596, 333))
        MainWindow.setMaximumSize(QSize(596, 333))
        MainWindow.setStyleSheet(SyncStyle.serverPageMainFrame)
        MainWindow.setWindowIcon(QIcon(u":/image/assets/logo.png"))

        self.centralwidget = QWidget(MainWindow)
        self.frame = QFrame(self.centralwidget)
        self.frame.installEventFilter(self)
        self.frame.setGeometry(QRect(10, 10, 571, 311))
        self.frame.setStyleSheet(u"QFrame{background-color:rgb(44, 49, 60);border-radius:10px;}")
        self.frame.setFrameShape(QFrame.StyledPanel)
        self.frame.setFrameShadow(QFrame.Raised)

        self.shadow = QGraphicsDropShadowEffect(self)
        self.shadow.setBlurRadius(13)
        self.shadow.setXOffset(0)
        self.shadow.setYOffset(0)
        self.shadow.setColor(QColor(0, 0, 0, 150))
        self.frame.setGraphicsEffect(self.shadow)

        self.closeButton = QPushButton(self.frame)
        self.closeButton.setGeometry(QRect(530,0,41,31))
        self.closeButton.setStyleSheet(SyncStyle.serverPageCloseButton)
        self.closeButton.setIcon(QIcon(u":/24x24/assets/24x24/cil-x.png"))
        self.closeButton.setHidden(True)
        
        self.progressBar = QProgressBar(self.frame)
        self.progressBar.setGeometry(QRect(40, 200, 511, 23))
        self.progressBar.setStyleSheet(SyncStyle.loadPageProgressBar)
        self.progressBar.setValue(19)
        self.progressBar.setAlignment(Qt.AlignLeading|Qt.AlignLeft|Qt.AlignVCenter)
        self.progressBar.setTextVisible(False)
        self.progressBar.setOrientation(Qt.Horizontal)
        self.progressBar.setInvertedAppearance(False)
        self.progressBar.setMaximum(0)
        self.progressBar.setMinimum(0)
        self.progressBar.setValue(0)

        self.label = QLabel(self.frame)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(100, 250, 391, 41))

        font = QFont()
        font.setFamily(u"Segoe UI")
        font.setPointSize(22)
        font.setBold(True)
        font.setItalic(True)
        font.setWeight(75)

        self.label.setFont(font)
        self.label.setStyleSheet(u"color: rgb(85, 170, 255);")
        self.label.setAlignment(Qt.AlignCenter)

        self.label_2 = QLabel(self.frame)
        self.label_2.setGeometry(QRect(210, 10, 151, 161))
        self.label_2.setPixmap(QPixmap(u":/image/assets/logo.png"))
        self.label_2.setScaledContents(True)

        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)
        self.connectButton()

        self.checkWorker = SyncCheckNetWorker()
        self.checkThread = QThread(self)
        self.checkWorker.moveToThread(self.checkThread)
        self.checkThread.started.connect(self.checkWorker.checkStart)
        self.checkThread.start()
        self.checkWorker.checkNet.connect(self.progressBarState)

    def retranslateUi(self, MainWindow: QMainWindow):
        MainWindow.setWindowTitle("Sync Magnet")
        self.label.setText("Checking Connection...")

    def connectButton(self):
        self.closeButton.clicked.connect(lambda: self.closeApp())

    def eventFilter(self, source, event) -> bool:
        if source == self.frame:
            if event.type() == QEvent.MouseButtonPress:
                self.offset = event.pos()
            elif event.type() == QEvent.MouseMove and self.offset is not None:
                self.move(self.pos() - self.offset + event.pos())
                return True
            elif event.type() == QEvent.MouseButtonRelease:
                self.offset = None
        return super().eventFilter(source, event)

    @pyqtSlot(bool)
    def progressBarState(self,check: bool):
        print(self.waitcount)
        if check and self.waitcount == 13:
            self.checkWorker.setRunState(False)
            self.checkThread.quit()
            self.checkThread.wait()
            self.connect = ConnectWindow(application=self.application)
            self.connect.show()
            self.close()
        else:
            self.waitcount += 1
            if self.waitcount > 50:
                self.waitcount = 0
                self.label.setText("No Connection")
                self.closeButton.setHidden(False)
    
    def closeApp(self):
        self.checkWorker.setRunState(False)
        self.checkThread.quit()
        self.checkThread.wait()
        self.close()