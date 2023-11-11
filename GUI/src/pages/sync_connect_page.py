# -*- coding: utf-8 -*-

from PyQt5.QtCore             import *
from PyQt5.QtGui              import *
from PyQt5.QtWidgets          import *
from PyQt5.QtWidgets          import QWidget
from .sync_server_page        import ServerWindow
from src                      import SyncConnectWorker
from src.funcs.sync_style     import SyncStyle
from webbrowser               import open as openWeb

class ConnectWindow(QMainWindow):
    def __init__(self,application: QApplication) -> None:
        super(ConnectWindow,self).__init__()
        self.application = application
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.setAttribute(Qt.WA_TranslucentBackground)
        self.setupUi(self)

    def setupUi(self, MainWindow):
        MainWindow.resize(450, 327)
        MainWindow.setMinimumSize(QSize(450, 327))
        MainWindow.setMaximumSize(QSize(450, 327))
        MainWindow.setStyleSheet("""
QMainWindow {background: transparent; }
QToolTip {
	color: #ffffff;
	background-color: rgba(27, 29, 35, 160);
	border: 1px solid rgb(40, 40, 40);
	border-radius: 2px;
}
""")
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.titleFrame = QFrame(self.centralwidget)
        self.titleFrame.installEventFilter(self)
        self.titleFrame.setObjectName(u"titleFrame")
        self.titleFrame.setGeometry(QRect(10, 10, 431, 31))
        self.titleFrame.setStyleSheet(SyncStyle.connectPageTitleFrame)
        self.titleFrame.setFrameShape(QFrame.StyledPanel)
        self.titleFrame.setFrameShadow(QFrame.Raised)
        self.minimizedButton = QPushButton(self.titleFrame)
        self.minimizedButton.setObjectName(u"minimizedButton")
        self.minimizedButton.setGeometry(QRect(350, 0, 40, 31))
        sizePolicy = QSizePolicy(QSizePolicy.Minimum, QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.minimizedButton.sizePolicy().hasHeightForWidth())
        self.minimizedButton.setSizePolicy(sizePolicy)
        self.minimizedButton.setMinimumSize(QSize(40, 0))
        self.minimizedButton.setMaximumSize(QSize(40, 16777215))
        self.minimizedButton.setStyleSheet(SyncStyle.connectPageMinimizedButton)
        icon = QIcon()
        icon.addFile(u":/16x16/assets/16x16/cil-window-minimize.png", QSize(), QIcon.Normal, QIcon.Off)
        self.minimizedButton.setIcon(icon)
        self.closedButton = QPushButton(self.titleFrame)
        self.closedButton.setObjectName(u"closedButton")
        self.closedButton.setGeometry(QRect(395, 0, 36, 31))
        sizePolicy.setHeightForWidth(self.closedButton.sizePolicy().hasHeightForWidth())
        self.closedButton.setSizePolicy(sizePolicy)
        self.closedButton.setMinimumSize(QSize(0, 0))
        self.closedButton.setMaximumSize(QSize(43, 16777215))
        self.closedButton.setStyleSheet(SyncStyle.connectPageCloseButton)
        icon1 = QIcon()
        icon1.addFile(u":/16x16/assets/16x16/cil-x.png", QSize(), QIcon.Normal, QIcon.Off)
        self.closedButton.setIcon(icon1)
        self.titleLabel = QLabel(self.titleFrame)
        self.titleLabel.setObjectName(u"titleLabel")
        self.titleLabel.setGeometry(QRect(50, 5, 101, 21))
        font = QFont()
        font.setFamily(u"Segoe UI")
        font.setPointSize(10)
        font.setBold(True)
        font.setWeight(75)
        self.titleLabel.setFont(font)
        self.titleLabel.setStyleSheet(u"background-color: transparent;color: #ffffff;")
        self.appIconLabel = QLabel(self.titleFrame)
        self.appIconLabel.setObjectName(u"appIconLabel")
        self.appIconLabel.setGeometry(QRect(10, 1, 31, 31))
        self.appIconLabel.setStyleSheet(u"background-color: transparent;color: #ffffff;")
        self.appIconLabel.setPixmap(QPixmap(u":/image/assets/logo.png"))
        self.appIconLabel.setScaledContents(True)
        self.contentFrame = QFrame(self.centralwidget)
        self.contentFrame.setObjectName(u"contentFrame")
        self.contentFrame.setGeometry(QRect(11, 40, 429, 281))
        self.contentFrame.setStyleSheet(SyncStyle.connectPageContentFrame)
        self.contentFrame.setFrameShape(QFrame.StyledPanel)
        self.contentFrame.setFrameShadow(QFrame.Raised)
        self.startServerButton = QPushButton(self.contentFrame)
        self.startServerButton.setObjectName(u"startServerButton")
        self.startServerButton.setGeometry(QRect(160, 100, 111, 41))
        font1 = QFont()
        font1.setFamily(u"Segoe UI")
        font1.setPointSize(8)
        font1.setBold(True)
        font1.setWeight(75)
        self.startServerButton.setFont(font1)
        self.startServerButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.startServerButton.setStyleSheet(SyncStyle.connectPageContentButton)
        self.sourceCodeButton = QPushButton(self.contentFrame)
        self.sourceCodeButton.setObjectName(u"sourceCodeButton")
        self.sourceCodeButton.setGeometry(QRect(170, 150, 91, 31))
        self.sourceCodeButton.setFont(font1)
        self.sourceCodeButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.sourceCodeButton.setStyleSheet(SyncStyle.connectPageContentButton)
        self.versionLabel = QLabel(self.contentFrame)
        self.versionLabel.setObjectName(u"versionLabel")
        self.versionLabel.setGeometry(QRect(162, 250, 101, 21))
        font2 = QFont()
        font2.setPointSize(10)
        font2.setBold(True)
        font2.setWeight(75)
        self.versionLabel.setFont(font2)
        self.versionLabel.setStyleSheet(u"background-color: transparent;color: #ffffff;")
        self.versionLabel.setAlignment(Qt.AlignCenter)
        self.clientWaitLabel = QLabel(self.contentFrame)
        self.clientWaitLabel.setObjectName(u"clientWaitLabel")
        self.clientWaitLabel.setGeometry(QRect(105, 210, 221, 31))
        font3 = QFont()
        font3.setPointSize(10)
        font3.setBold(True)
        font3.setItalic(False)
        font3.setWeight(75)
        font3.setStrikeOut(False)
        self.clientWaitLabel.setFont(font3)
        self.clientWaitLabel.setStyleSheet(u"background-color: transparent;color: #ffffff;")
        self.clientWaitLabel.setAlignment(Qt.AlignCenter)
        self.markQuestionButton = QPushButton(self.contentFrame)
        self.markQuestionButton.setObjectName(u"markQuestionButton")
        self.markQuestionButton.setGeometry(QRect(390, 240, 31, 31))
        self.markQuestionButton.setFont(font1)
        self.markQuestionButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.markQuestionButton.setStyleSheet(SyncStyle.connectPageContentButton)
        self.appStyleNameLabel = QLabel(self.contentFrame)
        self.appStyleNameLabel.setObjectName(u"appStyleNameLabel")
        self.appStyleNameLabel.setGeometry(QRect(90, 0, 251, 91))
        self.appStyleNameLabel.setPixmap(QPixmap(u":/image/assets/app_name.png"))
        self.appStyleNameLabel.setScaledContents(True)
        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)
        self.connectedButtons()

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Sync Magnet", None))
        self.minimizedButton.setToolTip(QCoreApplication.translate("MainWindow", u"Minimize", None))
        self.closedButton.setToolTip(QCoreApplication.translate("MainWindow", u"Close", None))
        self.titleLabel.setText(QCoreApplication.translate("MainWindow", u"Sync Magnet", None))
        self.startServerButton.setText(QCoreApplication.translate("MainWindow", u"Start Connect", None))
        self.sourceCodeButton.setText(QCoreApplication.translate("MainWindow", u"Source", None))
        self.versionLabel.setText(QCoreApplication.translate("MainWindow", u"v0.0.6.3", None))
        self.clientWaitLabel.setText(QCoreApplication.translate("MainWindow", u"Client Waiting...", None))
        self.clientWaitLabel.setHidden(True)
        self.markQuestionButton.setText(QCoreApplication.translate("MainWindow", u"?", None))
    
    def eventFilter(self, source, event) -> bool:
        if source == self.titleFrame:
            if event.type() == QEvent.MouseButtonPress:
                self.offset = event.pos()
            elif event.type() == QEvent.MouseMove and self.offset is not None:
                self.move(self.pos() - self.offset + event.pos())
                return True
            elif event.type() == QEvent.MouseButtonRelease:
                self.offset = None
        return super().eventFilter(source, event)

    def connectedButtons(self):
        self.minimizedButton.clicked.connect(lambda: self.showMinimized())
        self.closedButton.clicked.connect(lambda: self.close())
        self.sourceCodeButton.clicked.connect(lambda: openWeb("https://github.com/Helmssyss/SyncMagnet"))
        self.startServerButton.clicked.connect(lambda: self.connectStart())

    def connectStart(self):
        self.startServerButton.setEnabled(False)
        self.clientWaitLabel.setHidden(False)
        self.connectWorker = SyncConnectWorker()
        self.connectThread = QThread()
        self.connectWorker.moveToThread(self.connectThread)
        self.connectThread.started.connect(self.connectWorker.start)
        self.connectThread.start()
        self.connectWorker.connectStart.connect(self.onConnected)

    @pyqtSlot(dict)
    def onConnected(self, param: dict[str,object]):
        if param['isConnect']:
            print("clientIsConnected: ", param['isConnect'])
            serverPage = ServerWindow(__APPLICATION__=self.application,dllService= param["this"])
            serverPage.show()
            self.close()

    def closeEvent(self, a0: QCloseEvent) -> None:
        if getattr(self,"connectWorker",None):
            self.connectWorker.connectStart.disconnect()
            self.connectThread.quit()
            self.connectThread.wait(1)
            print("connectThread BAŞARIYLA SONLANDIRILDI")
        a0.accept()