# -*- coding: utf-8 -*-

import asyncio
import threading
from time import sleep
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtWidgets import QWidget

from src import SyncMagnetDllService
from src import SyncListWidget

class ServerWindow(QMainWindow):
    def __init__(self,syncMagnetDllService:SyncMagnetDllService) -> None:
        super(ServerWindow,self).__init__()
        self.isSelectAll = False
        self.syncMagnetDllService = syncMagnetDllService
        self.lock = threading.Lock()
        print(threading.current_thread())
        self.setupUi(self)
    
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(640, 490)
        MainWindow.setMinimumSize(QSize(640, 490))
        MainWindow.setMaximumSize(QSize(640, 490))
        icon = QIcon()
        icon.addFile(u":/icons/logo1.png", QSize(), QIcon.Normal, QIcon.Off)
        MainWindow.setWindowIcon(icon)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.verticalLayout = QVBoxLayout(self.centralwidget)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.tabWidget = QTabWidget(self.centralwidget)
        self.tabWidget.setObjectName(u"tabWidget")
        self.tabWidget.setUsesScrollButtons(False)
        self.getMenu = QWidget()
        self.getMenu.setObjectName(u"getMenu")
        self.fileGetListWidget = SyncListWidget(self.getMenu)
        self.fileGetListWidget.setObjectName(u"fileGetListWidget")
        self.fileGetListWidget.setGeometry(QRect(350, 10, 256, 381))
        
        self.openFolderButton = QPushButton(self.getMenu)
        self.openFolderButton.setObjectName(u"pushButton_2")
        self.openFolderButton.setGeometry(QRect(530, 399, 75, 31))

        self.tabWidget.addTab(self.getMenu, "")
        self.sendMenu = QWidget()
        self.sendMenu.setObjectName(u"sendMenu")
        self.fileSendListWidget = SyncListWidget(self.sendMenu)
        self.fileSendListWidget.setObjectName(u"fileSendListWidget")
        self.fileSendListWidget.setGeometry(QRect(10, 10, 256, 381))
        self.sendFileButton = QPushButton(self.sendMenu)
        self.sendFileButton.setObjectName(u"sendFileButton")
        self.sendFileButton.setGeometry(QRect(10, 400, 71, 31))
        self.sendFileButton.clicked.connect(self.sendFiles)
        self.openExternalButton = QPushButton(self.sendMenu)
        self.openExternalButton.setObjectName(u"openExternalButton")
        self.openExternalButton.setGeometry(QRect(191, 399, 75, 31))

        self.selectAllButton = QPushButton(self.sendMenu)
        self.selectAllButton.setObjectName(u"pushButton")
        self.selectAllButton.setGeometry(QRect(100, 399, 71, 21))
        self.selectAllButton.clicked.connect(self.SendSelectedItems)

        self.tabWidget.addTab(self.sendMenu, "")
        self.verticalLayout.addWidget(self.tabWidget)
        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)
        self.tabWidget.tabBarClicked.connect(self.handleTabBar)
        self.tabWidget.setCurrentIndex(1)
        QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"SyncMagnet 0.0.6.1", None))

        self.openFolderButton.setText(QCoreApplication.translate("MainWindow", u"Open Folder", None))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.getMenu), QCoreApplication.translate("MainWindow", u"Get", None))

        self.sendFileButton.setText(QCoreApplication.translate("MainWindow", u"Send File(s)", None))
        self.openExternalButton.setText(QCoreApplication.translate("MainWindow", u"Open", None))
        self.selectAllButton.setText(QCoreApplication.translate("MainWindow", u"Select All", None))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.sendMenu), QCoreApplication.translate("MainWindow", u"Send", None))

    def handleTabBar(self, index: int):
        self.SAVE_FILE_TIMER = threading.Timer(1, self.GetSaveFiles)  # Örnek olarak 5 saniyede bir çalıştırılabilir.
        if index == 0:
            self.SAVE_FILE_TIMER.start()
        if index == 1:
            self.SAVE_FILE_TIMER.cancel()

    def SendSelectedItems(self):
        if not self.isSelectAll:
            self.selectAllButton.setText("Unselect All")
            self.fileSendListWidget.selectAllItems()
            self.isSelectAll = True
        else:
            self.selectAllButton.setText("Select All")
            self.fileSendListWidget.unSelectAllItems()
            self.isSelectAll = False

    def GetSaveFiles(self):
        while True:
            self.syncMagnetDllService.HandleFileTransfer()
            sleep(1)
            if not self.SAVE_FILE_TIMER.is_alive():
                break

    def sendFiles(self):
        SELECT_ITEM_SEND_THREAD = threading.Thread(target=self.syncMagnetDllService.SelectSendDllFilePath,args=(self.fileSendListWidget,),daemon=True)
        SELECT_ITEM_SEND_THREAD.start()
        SELECT_ITEM_SEND_THREAD.join()