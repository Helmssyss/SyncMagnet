# -*- coding: utf-8 -*-

import threading
from time import sleep
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

from .sync_server_page import ServerWindow
from src import SyncMagnetDllService

from .sync_icons import *

class ConnectWindow(QMainWindow):
    def __init__(self) -> None:
        super(ConnectWindow,self).__init__()
        self._clientIsConnected = False
        self.setupUi(self)

    def setupUi(self, MainWindow):
        icon = QIcon()
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        
        MainWindow.resize(411, 275)
        MainWindow.setMinimumSize(QSize(411, 275))
        MainWindow.setMaximumSize(QSize(411, 275))
        
        icon.addFile(u":/icons/logo1.png", QSize(), QIcon.Normal, QIcon.Off)
        MainWindow.setWindowIcon(icon)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.connectStartButton = QPushButton(self.centralwidget)
        self.connectStartButton.setObjectName(u"connectStartButton")
        self.connectStartButton.setGeometry(QRect(140, 90, 141, 41))
        self.connectStartButton.clicked.connect(lambda: self.connectStartButtonClicked())

        self.sourceCodeButton = QPushButton(self.centralwidget)
        self.sourceCodeButton.setObjectName(u"sourceCodeButton")
        self.sourceCodeButton.setGeometry(QRect(175, 150, 75, 31))
        self.googlePlayButton = QPushButton(self.centralwidget)
        self.googlePlayButton.setObjectName(u"googlePlayButton")
        self.googlePlayButton.setGeometry(QRect(10, 245, 75, 23))
        self.markQuestionButton = QPushButton(self.centralwidget)
        self.markQuestionButton.setObjectName(u"markQuestionButton")
        self.markQuestionButton.setGeometry(QRect(374, 237, 31, 31))
        self.versionLabel = QLabel(self.centralwidget)
        self.versionLabel.setObjectName(u"versionLabel")
        self.versionLabel.setGeometry(QRect(190, 250, 47, 13))
        self.appLogo = QLabel(self.centralwidget)
        self.appLogo.setObjectName(u"appLogo")
        self.appLogo.setGeometry(QRect(181, 16, 61, 61))
        self.appLogo.setPixmap(QPixmap(u":/icons/logo1.png"))
        self.appLogo.setScaledContents(True)
        self.waitLabel = QLabel(self.centralwidget)
        self.waitLabel.setObjectName(u"waitLabel")
        self.waitLabel.setGeometry(QRect(180, 210, 61, 16))
        
        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"SyncMagnet 0.0.6.1", None))
        self.connectStartButton.setText(QCoreApplication.translate("MainWindow", u"Start Connection", None))
        self.sourceCodeButton.setText(QCoreApplication.translate("MainWindow", u"Source", None))
        self.googlePlayButton.setText(QCoreApplication.translate("MainWindow", u"Google Play", None))
        self.markQuestionButton.setText(QCoreApplication.translate("MainWindow", u"?", None))
        self.versionLabel.setText(QCoreApplication.translate("MainWindow", u"v0.0.6.1", None))
        self.waitLabel.setText(QCoreApplication.translate("MainWindow", u"Bekleniyor...", None))
        self.waitLabel.setHidden(True)

    def connectStartButtonClicked(self):
        dllService = SyncMagnetDllService()
        if dllService.LoadMagnetDll():
            loading = threading.Timer(1,self.yuklenmeAnimasyonu)
            loading.start()
            clientIsConnected = dllService.ManageDllStarted()
            self._clientIsConnected = clientIsConnected
            self.clientWindow = ServerWindow(syncMagnetDllService=dllService)
            self.clientWindow.show()
            loading.cancel()
            self.close()
    
    def yuklenmeAnimasyonu(self):
        while not self._clientIsConnected:
            print(threading.current_thread())
            sleep(1)