# -*- coding: utf-8 -*-

import os
import xml.etree.ElementTree    as ET
from PyQt5.QtCore               import *
from PyQt5.QtGui                import *
from PyQt5.QtWidgets            import *
from src.funcs.sync_dll_service import SyncMagnetDllService
from src.funcs.sync_style       import SyncStyle
from src.funcs.sync_workers     import SyncClientInfoWorker
from src.funcs.sync_workers     import SyncFileSenderWorker
from src.funcs.sync_workers     import SyncProcessRunWorker
from src.funcs.sync_workers     import SyncFileDownloadWorker
from src.funcs.sync_workers     import SyncLoadFileListener
from src.funcs.sync_workers     import ThrowSyncClose
from src.pages.sync_load_page   import LoadWindow
from src.widgets                import SyncListWidget
from src.widgets                import SyncTableWidget
from webbrowser                 import open as openSourcePage

class ServerWindow(QMainWindow):
    def __init__(self,__APPLICATION__: QApplication,dllService: SyncMagnetDllService) -> None:
        super(ServerWindow,self).__init__()
        self.APPLICATON = __APPLICATION__
        
        self.isSelectAll = False
        self.isDownload = True
        self.sendFileStartProcess = False
        self.SAVE_FILE_THREAD = None
        self.isBack = False
        self.run = True
        self.syncMagnetDllService = dllService
        self.syncMagnetDllService.GetChangeLog()
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.setAttribute(Qt.WA_TranslucentBackground)
        self.setupUi(self)

    def setupUi(self, MainWindow: QMainWindow):
        MainWindow.resize(814, 784)
        MainWindow.setMinimumSize(QSize(693, 784))
        palette = QPalette()
        brush = QBrush(QColor(255, 255, 255, 255))
        brush.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.WindowText, brush)
        brush1 = QBrush(QColor(0, 0, 0, 0))
        brush1.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Button, brush1)
        brush2 = QBrush(QColor(66, 73, 90, 255))
        brush2.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Light, brush2)
        brush3 = QBrush(QColor(55, 61, 75, 255))
        brush3.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Midlight, brush3)
        brush4 = QBrush(QColor(22, 24, 30, 255))
        brush4.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Dark, brush4)
        brush5 = QBrush(QColor(29, 32, 40, 255))
        brush5.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Mid, brush5)
        brush6 = QBrush(QColor(210, 210, 210, 255))
        brush6.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Text, brush6)
        palette.setBrush(QPalette.Active, QPalette.BrightText, brush)
        palette.setBrush(QPalette.Active, QPalette.ButtonText, brush)
        palette.setBrush(QPalette.Active, QPalette.Base, brush1)
        palette.setBrush(QPalette.Active, QPalette.Window, brush1)
        brush7 = QBrush(QColor(0, 0, 0, 255))
        brush7.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Shadow, brush7)
        brush8 = QBrush(QColor(85, 170, 255, 255))
        brush8.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.Highlight, brush8)
        palette.setBrush(QPalette.Active, QPalette.Link, brush8)
        brush9 = QBrush(QColor(255, 0, 127, 255))
        brush9.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.LinkVisited, brush9)
        palette.setBrush(QPalette.Active, QPalette.AlternateBase, brush4)
        brush10 = QBrush(QColor(44, 49, 60, 255))
        brush10.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Active, QPalette.ToolTipBase, brush10)
        palette.setBrush(QPalette.Active, QPalette.ToolTipText, brush6)
        brush11 = QBrush(QColor(210, 210, 210, 128))
        brush11.setStyle(Qt.NoBrush)

        palette.setBrush(QPalette.Active, QPalette.PlaceholderText, brush11)
        palette.setBrush(QPalette.Inactive, QPalette.WindowText, brush)
        palette.setBrush(QPalette.Inactive, QPalette.Button, brush1)
        palette.setBrush(QPalette.Inactive, QPalette.Light, brush2)
        palette.setBrush(QPalette.Inactive, QPalette.Midlight, brush3)
        palette.setBrush(QPalette.Inactive, QPalette.Dark, brush4)
        palette.setBrush(QPalette.Inactive, QPalette.Mid, brush5)
        palette.setBrush(QPalette.Inactive, QPalette.Text, brush6)
        palette.setBrush(QPalette.Inactive, QPalette.BrightText, brush)
        palette.setBrush(QPalette.Inactive, QPalette.ButtonText, brush)
        palette.setBrush(QPalette.Inactive, QPalette.Base, brush1)
        palette.setBrush(QPalette.Inactive, QPalette.Window, brush1)
        palette.setBrush(QPalette.Inactive, QPalette.Shadow, brush7)
        palette.setBrush(QPalette.Inactive, QPalette.Highlight, brush8)
        palette.setBrush(QPalette.Inactive, QPalette.Link, brush8)
        palette.setBrush(QPalette.Inactive, QPalette.LinkVisited, brush9)
        palette.setBrush(QPalette.Inactive, QPalette.AlternateBase, brush4)
        palette.setBrush(QPalette.Inactive, QPalette.ToolTipBase, brush10)
        palette.setBrush(QPalette.Inactive, QPalette.ToolTipText, brush6)
        brush12 = QBrush(QColor(210, 210, 210, 128))
        brush12.setStyle(Qt.NoBrush)

        palette.setBrush(QPalette.Inactive, QPalette.PlaceholderText, brush12)
        palette.setBrush(QPalette.Disabled, QPalette.WindowText, brush4)
        palette.setBrush(QPalette.Disabled, QPalette.Button, brush1)
        palette.setBrush(QPalette.Disabled, QPalette.Light, brush2)
        palette.setBrush(QPalette.Disabled, QPalette.Midlight, brush3)
        palette.setBrush(QPalette.Disabled, QPalette.Dark, brush4)
        palette.setBrush(QPalette.Disabled, QPalette.Mid, brush5)
        palette.setBrush(QPalette.Disabled, QPalette.Text, brush4)
        palette.setBrush(QPalette.Disabled, QPalette.BrightText, brush)
        palette.setBrush(QPalette.Disabled, QPalette.ButtonText, brush4)
        palette.setBrush(QPalette.Disabled, QPalette.Base, brush1)
        palette.setBrush(QPalette.Disabled, QPalette.Window, brush1)
        palette.setBrush(QPalette.Disabled, QPalette.Shadow, brush7)
        brush13 = QBrush(QColor(51, 153, 255, 255))
        brush13.setStyle(Qt.SolidPattern)
        palette.setBrush(QPalette.Disabled, QPalette.Highlight, brush13)
        palette.setBrush(QPalette.Disabled, QPalette.Link, brush8)
        palette.setBrush(QPalette.Disabled, QPalette.LinkVisited, brush9)
        palette.setBrush(QPalette.Disabled, QPalette.AlternateBase, brush10)
        palette.setBrush(QPalette.Disabled, QPalette.ToolTipBase, brush10)
        palette.setBrush(QPalette.Disabled, QPalette.ToolTipText, brush6)
        brush14 = QBrush(QColor(210, 210, 210, 128))
        brush14.setStyle(Qt.NoBrush)
        palette.setBrush(QPalette.Disabled, QPalette.PlaceholderText, brush14)

        MainWindow.setPalette(palette)
        font = QFont()
        font.setFamily(u"Segoe UI")
        font.setPointSize(10)
        MainWindow.setFont(font)
        icon = QIcon()
        icon.addFile(u":/image/assets/logo.png", QSize(), QIcon.Normal, QIcon.Off)
        MainWindow.setWindowIcon(icon)
        MainWindow.setStyleSheet(SyncStyle.serverPageMainWindow)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.centralwidget.setStyleSheet(u"background: transparent;color: rgb(210, 210, 210);")
        self.verticalLayout_12 = QVBoxLayout(self.centralwidget)
        self.verticalLayout_12.setSpacing(0)
        self.verticalLayout_12.setObjectName(u"verticalLayout_12")
        self.verticalLayout_12.setContentsMargins(10, 10, 10, 10)
        self.frame_main = QFrame(self.centralwidget)
        self.frame_main.setObjectName(u"frame_main")
        self.frame_main.setStyleSheet(SyncStyle.serverPageMainFrame)
        self.frame_main.setFrameShape(QFrame.NoFrame)
        self.frame_main.setFrameShadow(QFrame.Raised)
        self.verticalLayout = QVBoxLayout(self.frame_main)
        self.verticalLayout.setSpacing(0)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.frame_top = QFrame(self.frame_main)
        self.frame_top.setObjectName(u"frame_top")
        self.frame_top.setMinimumSize(QSize(0, 65))
        self.frame_top.setMaximumSize(QSize(16777215, 65))
        self.frame_top.setStyleSheet(u"background-color: transparent;")
        self.frame_top.setFrameShape(QFrame.NoFrame)
        self.frame_top.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_3 = QHBoxLayout(self.frame_top)
        self.horizontalLayout_3.setSpacing(0)
        self.horizontalLayout_3.setObjectName(u"horizontalLayout_3")
        self.horizontalLayout_3.setContentsMargins(0, 0, 0, 0)
        self.frame_toggle = QFrame(self.frame_top)
        self.frame_toggle.setObjectName(u"frame_toggle")
        self.frame_toggle.setMaximumSize(QSize(70, 16777215))
        self.frame_toggle.setStyleSheet(u"background-color: rgb(27, 29, 35);border-top-left-radius: 10px;")
        self.frame_toggle.setFrameShape(QFrame.NoFrame)
        self.frame_toggle.setFrameShadow(QFrame.Raised)
        self.verticalLayout_3 = QVBoxLayout(self.frame_toggle)
        self.verticalLayout_3.setSpacing(0)
        self.verticalLayout_3.setObjectName(u"verticalLayout_3")
        self.verticalLayout_3.setContentsMargins(0, 0, 0, 0)
        self.btn_toggle_menu = QPushButton(self.frame_toggle)
        self.btn_toggle_menu.setObjectName(u"btn_toggle_menu")
        sizePolicy = QSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.btn_toggle_menu.sizePolicy().hasHeightForWidth())
        self.btn_toggle_menu.setSizePolicy(sizePolicy)
        self.btn_toggle_menu.setStyleSheet(SyncStyle.serverPageToggleMenuButton)

        icon1 = QIcon()
        icon1.addFile(u":/24x24/assets/24x24/cil-menu.png", QSize(), QIcon.Normal, QIcon.Off)
        self.btn_toggle_menu.setIcon(icon1)
        self.btn_toggle_menu.setIconSize(QSize(37, 37))
        self.verticalLayout_3.addWidget(self.btn_toggle_menu)
        self.horizontalLayout_3.addWidget(self.frame_toggle)
        self.frame_top_right = QFrame(self.frame_top)
        self.frame_top_right.setObjectName(u"frame_top_right")
        self.frame_top_right.setStyleSheet(u"background: transparent;")
        self.frame_top_right.setFrameShape(QFrame.NoFrame)
        self.frame_top_right.setFrameShadow(QFrame.Raised)
        self.verticalLayout_2 = QVBoxLayout(self.frame_top_right)
        self.verticalLayout_2.setSpacing(0)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.frame_top_btns = QFrame(self.frame_top_right)
        self.frame_top_btns.installEventFilter(self)
        self.frame_top_btns.setObjectName(u"frame_top_btns")
        self.frame_top_btns.setMaximumSize(QSize(16777215, 42))
        self.frame_top_btns.setStyleSheet(u"background-color: rgba(27, 29, 35, 200);border-top-right-radius: 10px;")
        self.frame_top_btns.setFrameShape(QFrame.NoFrame)
        self.frame_top_btns.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_4 = QHBoxLayout(self.frame_top_btns)
        self.horizontalLayout_4.setSpacing(0)
        self.horizontalLayout_4.setObjectName(u"horizontalLayout_4")
        self.horizontalLayout_4.setContentsMargins(0, 0, 0, 0)
        self.frame_label_top_btns = QFrame(self.frame_top_btns)
        self.frame_label_top_btns.setObjectName(u"frame_label_top_btns")
        sizePolicy1 = QSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
        sizePolicy1.setHorizontalStretch(0)
        sizePolicy1.setVerticalStretch(0)
        sizePolicy1.setHeightForWidth(self.frame_label_top_btns.sizePolicy().hasHeightForWidth())
        self.frame_label_top_btns.setSizePolicy(sizePolicy1)
        self.frame_label_top_btns.setStyleSheet(u"border-top-right-radius: 0px;")
        self.frame_label_top_btns.setFrameShape(QFrame.NoFrame)
        self.frame_label_top_btns.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_10 = QHBoxLayout(self.frame_label_top_btns)
        self.horizontalLayout_10.setSpacing(0)
        self.horizontalLayout_10.setObjectName(u"horizontalLayout_10")
        self.horizontalLayout_10.setContentsMargins(5, 0, 10, 0)
        self.frame_icon_top_bar = QFrame(self.frame_label_top_btns)
        self.frame_icon_top_bar.setObjectName(u"frame_icon_top_bar")
        self.frame_icon_top_bar.setMaximumSize(QSize(30, 30))
        self.frame_icon_top_bar.setFrameShape(QFrame.StyledPanel)
        self.frame_icon_top_bar.setFrameShadow(QFrame.Raised)
        self.label_2 = QLabel(self.frame_icon_top_bar)
        self.label_2.setObjectName(u"label_2")
        self.label_2.setGeometry(QRect(2, 3, 25, 25))
        self.label_2.setPixmap(QPixmap(u":/image/assets/logo.png"))
        self.label_2.setScaledContents(True)

        self.horizontalLayout_10.addWidget(self.frame_icon_top_bar)

        self.label_title_bar_top = QLabel(self.frame_label_top_btns)
        self.label_title_bar_top.setObjectName(u"label_title_bar_top")
        font1 = QFont()
        font1.setFamily(u"Segoe UI")
        font1.setPointSize(10)
        font1.setBold(True)
        font1.setWeight(75)
        self.label_title_bar_top.setFont(font1)
        self.label_title_bar_top.setStyleSheet(u"background: transparent;")
        self.label_title_bar_top.setMargin(6)

        self.horizontalLayout_10.addWidget(self.label_title_bar_top)
        self.horizontalLayout_4.addWidget(self.frame_label_top_btns)

        self.frame_btns_right = QFrame(self.frame_top_btns)
        self.frame_btns_right.setObjectName(u"frame_btns_right")
        sizePolicy1.setHeightForWidth(self.frame_btns_right.sizePolicy().hasHeightForWidth())
        self.frame_btns_right.setSizePolicy(sizePolicy1)
        self.frame_btns_right.setMaximumSize(QSize(120, 16777215))
        self.frame_btns_right.setStyleSheet(u"border-top-right-radius: 10px;")
        self.frame_btns_right.setFrameShape(QFrame.NoFrame)
        self.frame_btns_right.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_5 = QHBoxLayout(self.frame_btns_right)
        self.horizontalLayout_5.setSpacing(0)
        self.horizontalLayout_5.setObjectName(u"horizontalLayout_5")
        self.horizontalLayout_5.setContentsMargins(0, 0, 0, 0)
        self.btn_minimize = QPushButton(self.frame_btns_right)
        self.btn_minimize.setObjectName(u"btn_minimize")
        sizePolicy2 = QSizePolicy(QSizePolicy.Minimum, QSizePolicy.Expanding)
        sizePolicy2.setHorizontalStretch(0)
        sizePolicy2.setVerticalStretch(0)
        sizePolicy2.setHeightForWidth(self.btn_minimize.sizePolicy().hasHeightForWidth())
        self.btn_minimize.setSizePolicy(sizePolicy2)
        self.btn_minimize.setMinimumSize(QSize(40, 0))
        self.btn_minimize.setMaximumSize(QSize(40, 16777215))
        self.btn_minimize.setStyleSheet(SyncStyle.serverPageMinimizeButton)
        icon2 = QIcon()
        icon2.addFile(u":/16x16/assets/16x16/cil-window-minimize.png", QSize(), QIcon.Normal, QIcon.Off)
        self.btn_minimize.setIcon(icon2)

        self.horizontalLayout_5.addWidget(self.btn_minimize)

        self.btn_maximize_restore = QPushButton(self.frame_btns_right)
        self.btn_maximize_restore.setObjectName(u"btn_maximize_restore")
        sizePolicy2.setHeightForWidth(self.btn_maximize_restore.sizePolicy().hasHeightForWidth())
        self.btn_maximize_restore.setSizePolicy(sizePolicy2)
        self.btn_maximize_restore.setMinimumSize(QSize(40, 0))
        self.btn_maximize_restore.setMaximumSize(QSize(40, 16777215))
        self.btn_maximize_restore.setStyleSheet(SyncStyle.serverPageMinimizeButton)
        icon3 = QIcon()
        icon3.addFile(u":/16x16/assets/16x16/cil-window-maximize.png", QSize(), QIcon.Normal, QIcon.Off)
        self.btn_maximize_restore.setIcon(icon3)

        self.horizontalLayout_5.addWidget(self.btn_maximize_restore)

        self.btn_close = QPushButton(self.frame_btns_right)
        self.btn_close.setObjectName(u"btn_close")
        sizePolicy2.setHeightForWidth(self.btn_close.sizePolicy().hasHeightForWidth())
        self.btn_close.setSizePolicy(sizePolicy2)
        self.btn_close.setMinimumSize(QSize(40, 0))
        self.btn_close.setMaximumSize(QSize(40, 16777215))
        self.btn_close.setStyleSheet(SyncStyle.serverPageCloseButton)
        icon4 = QIcon()
        icon4.addFile(u":/16x16/assets/16x16/cil-x.png", QSize(), QIcon.Normal, QIcon.Off)
        self.btn_close.setIcon(icon4)

        self.horizontalLayout_5.addWidget(self.btn_close)
        self.horizontalLayout_4.addWidget(self.frame_btns_right, 0, Qt.AlignRight)
        self.verticalLayout_2.addWidget(self.frame_top_btns)

        self.frame_top_info = QFrame(self.frame_top_right)
        self.frame_top_info.setObjectName(u"frame_top_info")
        self.frame_top_info.setMaximumSize(QSize(16777215, 65))
        self.frame_top_info.setStyleSheet(u"background-color: rgb(39, 44, 54);")
        self.frame_top_info.setFrameShape(QFrame.NoFrame)
        self.frame_top_info.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_8 = QHBoxLayout(self.frame_top_info)
        self.horizontalLayout_8.setSpacing(0)
        self.horizontalLayout_8.setObjectName(u"horizontalLayout_8")
        self.horizontalLayout_8.setContentsMargins(10, 0, 10, 0)
        self.label_top_info_1 = QLabel(self.frame_top_info)
        self.label_top_info_1.setObjectName(u"label_top_info_1")
        self.label_top_info_1.setMaximumSize(QSize(16777215, 15))
        font2 = QFont()
        font2.setFamily(u"Segoe UI")
        self.label_top_info_1.setFont(font2)
        self.label_top_info_1.setStyleSheet(u"color: rgb(98, 103, 111); ")

        self.horizontalLayout_8.addWidget(self.label_top_info_1)

        self.label_top_info_2 = QLabel(self.frame_top_info)
        self.label_top_info_2.setObjectName(u"label_top_info_2")
        self.label_top_info_2.setMinimumSize(QSize(0, 0))
        self.label_top_info_2.setMaximumSize(QSize(250, 20))
        font3 = QFont()
        font3.setFamily(u"Segoe UI")
        font3.setBold(True)
        font3.setWeight(75)
        self.label_top_info_2.setFont(font3)
        self.label_top_info_2.setStyleSheet(u"color: rgb(98, 103, 111);")
        self.label_top_info_2.setAlignment(Qt.AlignRight|Qt.AlignTrailing|Qt.AlignVCenter)

        self.horizontalLayout_8.addWidget(self.label_top_info_2)
        self.verticalLayout_2.addWidget(self.frame_top_info)
        self.horizontalLayout_3.addWidget(self.frame_top_right)
        self.verticalLayout.addWidget(self.frame_top)

        self.frame_center = QFrame(self.frame_main)
        self.frame_center.setObjectName(u"frame_center")
        sizePolicy.setHeightForWidth(self.frame_center.sizePolicy().hasHeightForWidth())
        self.frame_center.setSizePolicy(sizePolicy)
        self.frame_center.setStyleSheet(u"background-color: rgb(40, 44, 52);")
        self.frame_center.setFrameShape(QFrame.NoFrame)
        self.frame_center.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_2 = QHBoxLayout(self.frame_center)
        self.horizontalLayout_2.setSpacing(0)
        self.horizontalLayout_2.setObjectName(u"horizontalLayout_2")
        self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.frame_left_menu = QFrame(self.frame_center)
        self.frame_left_menu.setObjectName(u"frame_left_menu")
        sizePolicy3 = QSizePolicy(QSizePolicy.Preferred, QSizePolicy.Preferred)
        sizePolicy3.setHorizontalStretch(0)
        sizePolicy3.setVerticalStretch(0)
        sizePolicy3.setHeightForWidth(self.frame_left_menu.sizePolicy().hasHeightForWidth())
        self.frame_left_menu.setSizePolicy(sizePolicy3)
        self.frame_left_menu.setMinimumSize(QSize(70, 0))
        self.frame_left_menu.setMaximumSize(QSize(70, 16777215))
        self.frame_left_menu.setLayoutDirection(Qt.LeftToRight)
        self.frame_left_menu.setStyleSheet(u"background-color: rgb(27, 29, 35);")
        self.frame_left_menu.setFrameShape(QFrame.NoFrame)
        self.frame_left_menu.setFrameShadow(QFrame.Raised)
        self.verticalLayout_5 = QVBoxLayout(self.frame_left_menu)
        self.verticalLayout_5.setSpacing(1)
        self.verticalLayout_5.setObjectName(u"verticalLayout_5")
        self.verticalLayout_5.setContentsMargins(0, 0, 0, 0)
        self.frame_menus = QFrame(self.frame_left_menu)
        self.frame_menus.setObjectName(u"frame_menus")
        self.frame_menus.setFrameShape(QFrame.NoFrame)
        self.frame_menus.setFrameShadow(QFrame.Raised)
        self.layout_menus = QVBoxLayout(self.frame_menus)
        self.layout_menus.setSpacing(0)
        self.layout_menus.setObjectName(u"layout_menus")
        self.layout_menus.setContentsMargins(0, 0, 0, 0)
        self.homeMenuButton = QPushButton(self.frame_menus)
        self.homeMenuButton.setObjectName(u"homeMenuButton")
        self.homeMenuButton.setStyleSheet(SyncStyle.serverPageHomeButton)
        icon5 = QIcon()
        icon5.addFile(u":/20x20/assets/20x20/cil-home.png", QSize(), QIcon.Normal, QIcon.Off)
        self.homeMenuButton.setIcon(icon5)
        self.homeMenuButton.setIconSize(QSize(40, 57))

        self.layout_menus.addWidget(self.homeMenuButton)

        self.downloadMenuButton = QPushButton(self.frame_menus)
        self.downloadMenuButton.setObjectName(u"downloadMenuButton")
        self.downloadMenuButton.setStyleSheet(SyncStyle.serverPageDownloadMenuButton)
        icon6 = QIcon()
        icon6.addFile(u":/24x24/assets/24x24/cil-vertical-align-bottom.png", QSize(), QIcon.Normal, QIcon.Off)
        self.downloadMenuButton.setIcon(icon6)
        self.downloadMenuButton.setIconSize(QSize(29, 49))

        self.layout_menus.addWidget(self.downloadMenuButton)

        self.uploadMenuButton = QPushButton(self.frame_menus)
        self.uploadMenuButton.setObjectName(u"uploadMenuButton")
        self.uploadMenuButton.setStyleSheet(SyncStyle.serverPageUploadMenuButton)
        icon7 = QIcon()
        icon7.addFile(u":/24x24/assets/24x24/cil-vertical-align-top.png", QSize(), QIcon.Normal, QIcon.Off)
        self.uploadMenuButton.setIcon(icon7)
        self.uploadMenuButton.setIconSize(QSize(29, 49))

        self.layout_menus.addWidget(self.uploadMenuButton)

        self.deviceButton = QPushButton(self.frame_menus)
        self.deviceButton.setEnabled(False)
        self.deviceButton.setObjectName(u"deviceButton")
        self.deviceButton.setStyleSheet(SyncStyle.serverPageDeviceButton)
        icon8 = QIcon()
        icon8.addFile(u":/16x16/assets/16x16/cil-screen-smartphone.png", QSize(), QIcon.Normal, QIcon.Off)
        self.deviceButton.setIcon(icon8)
        self.deviceButton.setIconSize(QSize(40, 57))

        self.layout_menus.addWidget(self.deviceButton)

        self.batteryButton = QPushButton(self.frame_menus)
        self.batteryButton.setEnabled(False)
        self.batteryButton.setObjectName(u"batteryButton")
        self.batteryButton.setStyleSheet(SyncStyle.serverPageBatteryButton)
        icon9 = QIcon()
        icon9.addFile(u":/24x24/assets/24x24/battery_3_bar_FILL0_wght400_GRAD0_opsz24.png", QSize(), QIcon.Normal, QIcon.Off)
        self.batteryButton.setIcon(icon9)
        self.batteryButton.setIconSize(QSize(18, 45))

        self.layout_menus.addWidget(self.batteryButton)

        self.menuBatteryPercentLabel = QLabel(self.frame_menus)
        self.menuBatteryPercentLabel.setObjectName(u"menuBatteryPercentLabel")
        self.menuBatteryPercentLabel.setStyleSheet(u"margin-left: 10px;")
        self.menuBatteryPercentLabel.setTextFormat(Qt.RichText)
        self.menuBatteryPercentLabel.setAlignment(Qt.AlignCenter)

        self.layout_menus.addWidget(self.menuBatteryPercentLabel)
        self.verticalLayout_5.addWidget(self.frame_menus, 0, Qt.AlignTop)

        self.frame_extra_menus = QFrame(self.frame_left_menu)
        self.frame_extra_menus.setObjectName(u"frame_extra_menus")
        sizePolicy3.setHeightForWidth(self.frame_extra_menus.sizePolicy().hasHeightForWidth())
        self.frame_extra_menus.setSizePolicy(sizePolicy3)
        self.frame_extra_menus.setFrameShape(QFrame.NoFrame)
        self.frame_extra_menus.setFrameShadow(QFrame.Raised)
        self.layout_menu_bottom = QVBoxLayout(self.frame_extra_menus)
        self.layout_menu_bottom.setSpacing(10)
        self.layout_menu_bottom.setObjectName(u"layout_menu_bottom")
        self.layout_menu_bottom.setContentsMargins(0, 0, 0, 25)
        self.githubButtonFrame = QFrame(self.frame_extra_menus)
        self.githubButtonFrame.setObjectName(u"githubButtonFrame")
        self.githubButtonFrame.setFrameShape(QFrame.StyledPanel)
        self.githubButtonFrame.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_16 = QHBoxLayout(self.githubButtonFrame)
        self.horizontalLayout_16.setObjectName(u"horizontalLayout_16")
        self.githubButton = QPushButton(self.githubButtonFrame)
        self.githubButton.setObjectName(u"githubButton")
        self.githubButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.githubButton.setStyleSheet(SyncStyle.serverPageGithubButton)
        icon10 = QIcon()
        icon10.addFile(u":/image/assets/github_logo.png", QSize(), QIcon.Normal, QIcon.Off)
        self.githubButton.setIcon(icon10)
        self.githubButton.setIconSize(QSize(45, 50))
        self.horizontalLayout_16.addWidget(self.githubButton)
        self.layout_menu_bottom.addWidget(self.githubButtonFrame, 0, Qt.AlignBottom)
        self.verticalLayout_5.addWidget(self.frame_extra_menus, 0, Qt.AlignBottom)
        self.horizontalLayout_2.addWidget(self.frame_left_menu)

        self.frame_content_right = QFrame(self.frame_center)
        self.frame_content_right.setObjectName(u"frame_content_right")
        self.frame_content_right.setStyleSheet(u"background-color: rgb(44, 49, 60);")
        self.frame_content_right.setFrameShape(QFrame.NoFrame)
        self.frame_content_right.setFrameShadow(QFrame.Raised)
        self.verticalLayout_4 = QVBoxLayout(self.frame_content_right)
        self.verticalLayout_4.setSpacing(0)
        self.verticalLayout_4.setObjectName(u"verticalLayout_4")
        self.verticalLayout_4.setContentsMargins(0, 0, 0, 0)

        self.frame_content = QFrame(self.frame_content_right)
        self.frame_content.setObjectName(u"frame_content")
        self.frame_content.setFrameShape(QFrame.NoFrame)
        self.frame_content.setFrameShadow(QFrame.Raised)
        self.verticalLayout_9 = QVBoxLayout(self.frame_content)
        self.verticalLayout_9.setSpacing(0)
        self.verticalLayout_9.setObjectName(u"verticalLayout_9")
        self.verticalLayout_9.setContentsMargins(5, 5, 5, 5)
        self.stackedWidget = QStackedWidget(self.frame_content)
        self.stackedWidget.setObjectName(u"stackedWidget")
        self.stackedWidget.setStyleSheet(u"background: transparent;")

        self.page_home = QWidget()
        self.page_home.setObjectName(u"page_home")
        self.verticalLayout_10 = QVBoxLayout(self.page_home)
        self.verticalLayout_10.setObjectName(u"verticalLayout_10")
        self.frame_6 = QFrame(self.page_home)
        self.frame_6.setObjectName(u"frame_6")
        self.frame_6.setFrameShape(QFrame.StyledPanel)
        self.frame_6.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_15 = QHBoxLayout(self.frame_6)
        self.horizontalLayout_15.setObjectName(u"horizontalLayout_15")
        self.contentHorizontalSpacer1 = QSpacerItem(40, 20, QSizePolicy.Preferred, QSizePolicy.Minimum)
        self.horizontalLayout_15.addItem(self.contentHorizontalSpacer1)

        self.contentTitleLabel = QLabel(self.frame_6)
        self.contentTitleLabel.setObjectName(u"contentTitleLabel")
        sizePolicy4 = QSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        sizePolicy4.setHorizontalStretch(0)
        sizePolicy4.setVerticalStretch(0)
        sizePolicy4.setHeightForWidth(self.contentTitleLabel.sizePolicy().hasHeightForWidth())
        self.contentTitleLabel.setSizePolicy(sizePolicy4)
        self.contentTitleLabel.setMinimumSize(QSize(10, 28))
        self.contentTitleLabel.setMaximumSize(QSize(16777215, 16777215))
        font4 = QFont()
        font4.setPointSize(5)
        font4.setKerning(False)
        self.contentTitleLabel.setFont(font4)
        self.contentTitleLabel.setStyleSheet(u"")
        self.contentTitleLabel.setPixmap(QPixmap(u":/image/assets/app_name.png"))
        self.contentTitleLabel.setScaledContents(True)
        self.contentTitleLabel.setAlignment(Qt.AlignCenter)

        self.horizontalLayout_15.addWidget(self.contentTitleLabel)
        self.contentHorizontalSpacer2 = QSpacerItem(40, 20, QSizePolicy.Preferred, QSizePolicy.Minimum)
        self.horizontalLayout_15.addItem(self.contentHorizontalSpacer2)
        self.verticalLayout_10.addWidget(self.frame_6)
        self.verticalSpacer_3 = QSpacerItem(20, 68, QSizePolicy.Minimum, QSizePolicy.Expanding)
        self.verticalLayout_10.addItem(self.verticalSpacer_3)

        self.frame_4 = QFrame(self.page_home)
        self.frame_4.setObjectName(u"frame_4")
        self.frame_4.setMinimumSize(QSize(0, 78))
        self.frame_4.setMaximumSize(QSize(16777215, 170))
        self.frame_4.setFrameShape(QFrame.StyledPanel)
        self.frame_4.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_13 = QHBoxLayout(self.frame_4)
        self.horizontalLayout_13.setSpacing(4)
        self.horizontalLayout_13.setObjectName(u"horizontalLayout_13")
        self.horizontalLayout_13.setContentsMargins(0, 0, 26, 0)
        self.contentButtonHorizontalSpacer1 = QSpacerItem(103, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.horizontalLayout_13.addItem(self.contentButtonHorizontalSpacer1)

        self.downloadButton = QPushButton(self.frame_4)
        self.downloadButton.setObjectName(u"downloadButton")
        sizePolicy3.setHeightForWidth(self.downloadButton.sizePolicy().hasHeightForWidth())
        self.downloadButton.setSizePolicy(sizePolicy3)
        self.downloadButton.setMinimumSize(QSize(5, 8))
        self.downloadButton.setMaximumSize(QSize(127, 53))
        font5 = QFont()
        font5.setPointSize(10)
        font5.setBold(True)
        font5.setItalic(False)
        font5.setWeight(75)
        self.downloadButton.setFont(font5)
        self.downloadButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.downloadButton.setStyleSheet(SyncStyle.serverPageDownloadButton)
        icon11 = QIcon()
        icon11.addFile(u":/16x16/assets/16x16/cil-cloud-download.png", QSize(), QIcon.Normal, QIcon.Off)
        self.downloadButton.setIcon(icon11)
        self.downloadButton.setIconSize(QSize(16, 16))

        self.horizontalLayout_13.addWidget(self.downloadButton)

        self.line = QFrame(self.frame_4)
        self.line.setObjectName(u"line")
        self.line.setLineWidth(8)
        self.line.setFrameShape(QFrame.VLine)
        self.line.setFrameShadow(QFrame.Sunken)

        self.horizontalLayout_13.addWidget(self.line)

        self.uploadButton = QPushButton(self.frame_4)
        self.uploadButton.setObjectName(u"uploadButton")
        sizePolicy3.setHeightForWidth(self.uploadButton.sizePolicy().hasHeightForWidth())
        self.uploadButton.setSizePolicy(sizePolicy3)
        self.uploadButton.setMaximumSize(QSize(127, 53))
        font6 = QFont()
        font6.setPointSize(10)
        font6.setBold(True)
        font6.setWeight(75)
        self.uploadButton.setFont(font6)
        self.uploadButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.uploadButton.setStyleSheet(SyncStyle.serverPageUploadButton)
        icon12 = QIcon()
        icon12.addFile(u":/16x16/assets/16x16/cil-cloud-upload.png", QSize(), QIcon.Normal, QIcon.Off)
        self.uploadButton.setIcon(icon12)
        self.uploadButton.setIconSize(QSize(16, 16))

        self.horizontalLayout_13.addWidget(self.uploadButton)
        self.contentButtonHorizontalSpacer2 = QSpacerItem(103, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.horizontalLayout_13.addItem(self.contentButtonHorizontalSpacer2)

        self.verticalLayout_10.addWidget(self.frame_4)
        self.verticalSpacer_2 = QSpacerItem(20, 51, QSizePolicy.Minimum, QSizePolicy.Expanding)
        self.verticalLayout_10.addItem(self.verticalSpacer_2)

        self.changelogTextEdit = QTextEdit(self.page_home)
        self.changelogTextEdit.setMinimumSize(QSize(200, 200))
        self.changelogTextEdit.setStyleSheet(SyncStyle.serverPageChangelogTextEdit)
        self.changelogTextEdit.setReadOnly(True)

        self.verticalLayout_10.addWidget(self.changelogTextEdit)

        self.stackedWidget.addWidget(self.page_home)
        self.downloadPage = QWidget()
        self.downloadPage.setObjectName(u"downloadPage")
        self.verticalLayout_6 = QVBoxLayout(self.downloadPage)
        self.verticalLayout_6.setObjectName(u"verticalLayout_6")
        self.verticalSpacer = QSpacerItem(20, 267, QSizePolicy.Minimum, QSizePolicy.Expanding)

        self.verticalLayout_6.addItem(self.verticalSpacer)

        self.horizontalLayout = QHBoxLayout()
        self.horizontalLayout.setSpacing(8)
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.horizontalLayout.setContentsMargins(-1, 11, -1, 5)
        self.openDownloadFolderButton = QPushButton(self.downloadPage)
        self.openDownloadFolderButton.setObjectName(u"pushButton")
        self.openDownloadFolderButton.setMinimumSize(QSize(0, 47))
        self.openDownloadFolderButton.setMaximumSize(QSize(157, 47))
        self.openDownloadFolderButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.openDownloadFolderButton.setStyleSheet(SyncStyle.serverPageOpenDownloadFolderButton)
        icon13 = QIcon()
        icon13.addFile(u":/16x16/assets/16x16/cil-folder-open.png", QSize(), QIcon.Normal, QIcon.Off)
        self.openDownloadFolderButton.setIcon(icon13)

        self.horizontalLayout.addWidget(self.openDownloadFolderButton)

        self.horizontalSpacer = QSpacerItem(49, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer)
        self.verticalLayout_6.addLayout(self.horizontalLayout)

        self.downloadedFilesTable = SyncTableWidget(self.downloadPage)
        if (self.downloadedFilesTable.columnCount() < 2):
            self.downloadedFilesTable.setColumnCount(2)
        __qtablewidgetitem = QTableWidgetItem()
        self.downloadedFilesTable.setHorizontalHeaderItem(0, __qtablewidgetitem)
        __qtablewidgetitem1 = QTableWidgetItem()
        self.downloadedFilesTable.setHorizontalHeaderItem(1, __qtablewidgetitem1)
        if (self.downloadedFilesTable.rowCount() < 2):
            self.downloadedFilesTable.setRowCount(2)
            
        self.downloadedFilesTable.setObjectName(u"downloadedFilesTable")
        self.downloadedFilesTable.setEnabled(True)
        sizePolicy.setHeightForWidth(self.downloadedFilesTable.sizePolicy().hasHeightForWidth())
        self.downloadedFilesTable.setSizePolicy(sizePolicy)
        self.downloadedFilesTable.setMinimumSize(QSize(0, 326))
        self.downloadedFilesTable.setMaximumSize(QSize(16777215, 326))
        palette1 = QPalette()
        palette1.setBrush(QPalette.Active, QPalette.WindowText, brush6)
        brush15 = QBrush(QColor(39, 44, 54, 255))
        brush15.setStyle(Qt.SolidPattern)
        palette1.setBrush(QPalette.Active, QPalette.Button, brush15)
        palette1.setBrush(QPalette.Active, QPalette.Text, brush6)
        palette1.setBrush(QPalette.Active, QPalette.ButtonText, brush6)
        palette1.setBrush(QPalette.Active, QPalette.Base, brush15)
        palette1.setBrush(QPalette.Active, QPalette.Window, brush15)
        brush16 = QBrush(QColor(210, 210, 210, 128))
        brush16.setStyle(Qt.NoBrush)
        palette1.setBrush(QPalette.Active, QPalette.PlaceholderText, brush16)
        palette1.setBrush(QPalette.Inactive, QPalette.WindowText, brush6)
        palette1.setBrush(QPalette.Inactive, QPalette.Button, brush15)
        palette1.setBrush(QPalette.Inactive, QPalette.Text, brush6)
        palette1.setBrush(QPalette.Inactive, QPalette.ButtonText, brush6)
        palette1.setBrush(QPalette.Inactive, QPalette.Base, brush15)
        palette1.setBrush(QPalette.Inactive, QPalette.Window, brush15)
        brush17 = QBrush(QColor(210, 210, 210, 128))
        brush17.setStyle(Qt.NoBrush)
        palette1.setBrush(QPalette.Inactive, QPalette.PlaceholderText, brush17)
        palette1.setBrush(QPalette.Disabled, QPalette.WindowText, brush6)
        palette1.setBrush(QPalette.Disabled, QPalette.Button, brush15)
        palette1.setBrush(QPalette.Disabled, QPalette.Text, brush6)
        palette1.setBrush(QPalette.Disabled, QPalette.ButtonText, brush6)
        palette1.setBrush(QPalette.Disabled, QPalette.Base, brush15)
        palette1.setBrush(QPalette.Disabled, QPalette.Window, brush15)
        brush18 = QBrush(QColor(210, 210, 210, 128))
        brush18.setStyle(Qt.NoBrush)
        palette1.setBrush(QPalette.Disabled, QPalette.PlaceholderText, brush18)
        self.downloadedFilesTable.setPalette(palette1)

        self.verticalLayout_6.addWidget(self.downloadedFilesTable)

        self.stackedWidget.addWidget(self.downloadPage)
        self.uploadPage = QWidget()
        self.uploadPage.setObjectName(u"uploadPage")
        self.verticalLayout_13 = QVBoxLayout(self.uploadPage)
        self.verticalLayout_13.setObjectName(u"verticalLayout_13")
        self.sendFileListWidget = SyncListWidget(self.uploadPage)
        self.sendFileListWidget.setMinimumSize(QSize(0, 263))
        self.sendFileListWidget.setMaximumSize(QSize(16777215, 326))
        font8 = QFont()
        font8.setPointSize(10)
        font8.setBold(True)
        font8.setItalic(True)
        font8.setWeight(75)
        self.sendFileListWidget.setFont(font8)

        self.verticalLayout_13.addWidget(self.sendFileListWidget)

        self.buttonManageHorizontalLayout1 = QHBoxLayout()
        self.buttonManageHorizontalLayout1.setObjectName(u"buttonManageHorizontalLayout1")
        self.buttonManageHorizontalSpacer1 = QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)

        self.buttonManageHorizontalLayout1.addItem(self.buttonManageHorizontalSpacer1)

        self.buttonManageHorizontalLayout2 = QHBoxLayout()
        self.buttonManageHorizontalLayout2.setSpacing(6)
        self.buttonManageHorizontalLayout2.setObjectName(u"buttonManageHorizontalLayout2")
        self.buttonManageHorizontalLayout2.setContentsMargins(0, -1, -1, -1)
        self.openFolderButton = QPushButton(self.uploadPage)
        self.openFolderButton.setObjectName(u"openFolderButton")
        self.openFolderButton.setMinimumSize(QSize(150, 30))
        font9 = QFont()
        font9.setFamily(u"Segoe UI")
        font9.setPointSize(9)
        self.openFolderButton.setFont(font9)
        self.openFolderButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.openFolderButton.setStyleSheet(SyncStyle.serverPageOpenFolderButton)
        icon16 = QIcon()
        icon16.addFile(u":/20x20/assets/20x20/cil-folder-open.png", QSize(), QIcon.Normal, QIcon.Off)
        self.openFolderButton.setIcon(icon16)
        self.openFolderButton.setIconSize(QSize(16, 16))

        self.buttonManageHorizontalLayout2.addWidget(self.openFolderButton)

        self.selectAllButton = QPushButton(self.uploadPage)
        self.selectAllButton.setObjectName(u"selectAllButton")
        self.selectAllButton.setMinimumSize(QSize(150, 30))
        self.selectAllButton.setFont(font9)
        self.selectAllButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.selectAllButton.setStyleSheet(SyncStyle.serverPageSelectAllButton)
        icon17 = QIcon()
        icon17.addFile(u":/20x20/assets/20x20/cil-task.png", QSize(), QIcon.Normal, QIcon.Off)
        self.selectAllButton.setIcon(icon17)
        self.selectAllButton.setIconSize(QSize(16, 16))

        self.buttonManageHorizontalLayout2.addWidget(self.selectAllButton)

        self.sendButton = QPushButton(self.uploadPage)
        self.sendButton.setObjectName(u"sendButton")
        self.sendButton.setEnabled(True)
        self.sendButton.setMinimumSize(QSize(150, 30))
        self.sendButton.setFont(font)
        self.sendButton.setCursor(QCursor(Qt.PointingHandCursor))
        self.sendButton.setStyleSheet(SyncStyle.serverPageSendButton)
        icon18 = QIcon()
        icon18.addFile(u":/20x20/assets/20x20/cil-arrow-right.png", QSize(), QIcon.Normal, QIcon.Off)
        self.sendButton.setIcon(icon18)
        self.sendButton.setIconSize(QSize(24, 24))

        self.buttonManageHorizontalLayout2.addWidget(self.sendButton)
        self.buttonManageHorizontalLayout1.addLayout(self.buttonManageHorizontalLayout2)
        self.buttonManageHorizontalSpacer2 = QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.buttonManageHorizontalLayout1.addItem(self.buttonManageHorizontalSpacer2)
        self.verticalLayout_13.addLayout(self.buttonManageHorizontalLayout1)

        self.completedFileTableWidget = SyncTableWidget(self.uploadPage)
        if (self.completedFileTableWidget.columnCount() < 2):
            self.completedFileTableWidget.setColumnCount(2)
        __qtablewidgetitem4 = QTableWidgetItem()
        self.completedFileTableWidget.setHorizontalHeaderItem(0, __qtablewidgetitem4)
        __qtablewidgetitem5 = QTableWidgetItem()
        self.completedFileTableWidget.setHorizontalHeaderItem(1, __qtablewidgetitem5)
        if (self.completedFileTableWidget.rowCount() < 2):
            self.completedFileTableWidget.setRowCount(2)
        sizePolicy.setHeightForWidth(self.completedFileTableWidget.sizePolicy().hasHeightForWidth())

        palette2 = QPalette()
        palette2.setBrush(QPalette.Active, QPalette.WindowText, brush6)
        palette2.setBrush(QPalette.Active, QPalette.Button, brush15)
        palette2.setBrush(QPalette.Active, QPalette.Text, brush6)
        palette2.setBrush(QPalette.Active, QPalette.ButtonText, brush6)
        palette2.setBrush(QPalette.Active, QPalette.Base, brush15)
        palette2.setBrush(QPalette.Active, QPalette.Window, brush15)

        brush19 = QBrush(QColor(210, 210, 210, 128))
        brush19.setStyle(Qt.NoBrush)

        palette2.setBrush(QPalette.Active, QPalette.PlaceholderText, brush19)
        palette2.setBrush(QPalette.Inactive, QPalette.WindowText, brush6)
        palette2.setBrush(QPalette.Inactive, QPalette.Button, brush15)
        palette2.setBrush(QPalette.Inactive, QPalette.Text, brush6)
        palette2.setBrush(QPalette.Inactive, QPalette.ButtonText, brush6)
        palette2.setBrush(QPalette.Inactive, QPalette.Base, brush15)
        palette2.setBrush(QPalette.Inactive, QPalette.Window, brush15)

        brush20 = QBrush(QColor(210, 210, 210, 128))
        brush20.setStyle(Qt.NoBrush)

        palette2.setBrush(QPalette.Inactive, QPalette.PlaceholderText, brush20)
        palette2.setBrush(QPalette.Disabled, QPalette.WindowText, brush6)
        palette2.setBrush(QPalette.Disabled, QPalette.Button, brush15)
        palette2.setBrush(QPalette.Disabled, QPalette.Text, brush6)
        palette2.setBrush(QPalette.Disabled, QPalette.ButtonText, brush6)
        palette2.setBrush(QPalette.Disabled, QPalette.Base, brush15)
        palette2.setBrush(QPalette.Disabled, QPalette.Window, brush15)

        brush21 = QBrush(QColor(210, 210, 210, 128))
        brush21.setStyle(Qt.NoBrush)
        palette2.setBrush(QPalette.Disabled, QPalette.PlaceholderText, brush21)

        self.completedFileTableWidget.setPalette(palette2)

        self.verticalLayout_13.addWidget(self.completedFileTableWidget)
        self.stackedWidget.addWidget(self.uploadPage)
        self.verticalLayout_9.addWidget(self.stackedWidget)
        self.verticalLayout_4.addWidget(self.frame_content)

        self.frame_grip = QFrame(self.frame_content_right)
        self.frame_grip.setObjectName(u"frame_grip")
        self.frame_grip.setMinimumSize(QSize(0, 25))
        self.frame_grip.setMaximumSize(QSize(16777215, 25))
        self.frame_grip.setStyleSheet(u"background-color: rgb(33, 37, 43);")
        self.frame_grip.setFrameShape(QFrame.NoFrame)
        self.frame_grip.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_6 = QHBoxLayout(self.frame_grip)
        self.horizontalLayout_6.setSpacing(0)
        self.horizontalLayout_6.setObjectName(u"horizontalLayout_6")
        self.horizontalLayout_6.setContentsMargins(0, 0, 2, 0)
        self.frame_label_bottom = QFrame(self.frame_grip)
        self.frame_label_bottom.setObjectName(u"frame_label_bottom")
        self.frame_label_bottom.setFrameShape(QFrame.NoFrame)
        self.frame_label_bottom.setFrameShadow(QFrame.Raised)
        self.horizontalLayout_7 = QHBoxLayout(self.frame_label_bottom)
        self.horizontalLayout_7.setSpacing(0)
        self.horizontalLayout_7.setObjectName(u"horizontalLayout_7")
        self.horizontalLayout_7.setContentsMargins(10, 0, 10, 0)
        self.label_credits = QLabel(self.frame_label_bottom)
        self.label_credits.setObjectName(u"label_credits")
        self.label_credits.setFont(font2)
        self.label_credits.setStyleSheet(u"color: rgb(98, 103, 111);")

        self.horizontalLayout_7.addWidget(self.label_credits)

        self.label_version = QLabel(self.frame_label_bottom)
        self.label_version.setObjectName(u"label_version")
        self.label_version.setMaximumSize(QSize(100, 16777215))
        self.label_version.setFont(font2)
        self.label_version.setStyleSheet(u"color: rgb(98, 103, 111);")
        self.label_version.setAlignment(Qt.AlignRight|Qt.AlignTrailing|Qt.AlignVCenter)

        self.horizontalLayout_7.addWidget(self.label_version)
        self.horizontalLayout_6.addWidget(self.frame_label_bottom)

        self.frame_size_grip = QFrame(self.frame_grip)
        self.frame_size_grip.setObjectName(u"frame_size_grip")
        self.frame_size_grip.setMaximumSize(QSize(20, 20))
        self.frame_size_grip.setStyleSheet("""QSizeGrip {background-position: center;background-repeat: no-reperat;}""")
        self.frame_size_grip.setFrameShape(QFrame.NoFrame)
        self.frame_size_grip.setFrameShadow(QFrame.Raised)

        self.shadow = QGraphicsDropShadowEffect(self)
        self.shadow.setBlurRadius(17)
        self.shadow.setXOffset(0)
        self.shadow.setYOffset(0)
        self.shadow.setColor(QColor(0, 0, 0, 150))
        self.frame_main.setGraphicsEffect(self.shadow)

        self.sizegrip = QSizeGrip(self.frame_size_grip)
        self.sizegrip.setStyleSheet("width: 20px; height: 20px; margin 0px; padding: 0px;")

        self.horizontalLayout_6.addWidget(self.frame_size_grip)
        self.verticalLayout_4.addWidget(self.frame_grip)
        self.horizontalLayout_2.addWidget(self.frame_content_right)
        self.verticalLayout.addWidget(self.frame_center)
        self.verticalLayout_12.addWidget(self.frame_main)

        MainWindow.setCentralWidget(self.centralwidget)
        QWidget.setTabOrder(self.btn_minimize, self.btn_maximize_restore)
        QWidget.setTabOrder(self.btn_maximize_restore, self.btn_close)
        QWidget.setTabOrder(self.btn_close, self.btn_toggle_menu)

        self.retranslateUi(MainWindow)
        self.stackedWidget.setCurrentIndex(0)
        QMetaObject.connectSlotsByName(MainWindow)

        self.connectedButtons()

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Sync Magnet", None))
        self.readChangelog()
        self.label_title_bar_top.setText(QCoreApplication.translate("MainWindow", u"Sync Magnet", None))
        self.btn_minimize.setToolTip(QCoreApplication.translate("MainWindow", u"Minimize", None))
        self.btn_maximize_restore.setToolTip(QCoreApplication.translate("MainWindow", u"Maximize", None))
        self.btn_close.setToolTip(QCoreApplication.translate("MainWindow", u"Close", None))
        self.label_top_info_2.setText(QCoreApplication.translate("MainWindow", u"| HOME", None))
        self.homeMenuButton.setToolTip(QCoreApplication.translate("MainWindow", u"<html><head/><body><p>HOME</p></body></html>", None))
        self.homeMenuButton.setText(QCoreApplication.translate("MainWindow", u"        HOME", None))
        self.downloadMenuButton.setToolTip(QCoreApplication.translate("MainWindow", u"<html><head/><body><p>DOWNLOAD FILE</p></body></html>", None))
        self.downloadMenuButton.setText(QCoreApplication.translate("MainWindow", u"      DOWNLOAD", None))
        self.uploadMenuButton.setToolTip(QCoreApplication.translate("MainWindow", u"<html><head/><body><p>UPLOAD FILE</p></body></html>", None))
        self.uploadMenuButton.setText(QCoreApplication.translate("MainWindow", u"      UPLOAD", None))
        self.downloadButton.setText(QCoreApplication.translate("MainWindow", u"DOWNLOAD", None))
        self.uploadButton.setText(QCoreApplication.translate("MainWindow", u"UPLOAD", None))
        self.openDownloadFolderButton.setText(QCoreApplication.translate("MainWindow", u"Open Download Folder", None))
        ___qtablewidgetitem = self.downloadedFilesTable.horizontalHeaderItem(0)
        ___qtablewidgetitem.setText("File Size")
        ___qtablewidgetitem1 = self.downloadedFilesTable.horizontalHeaderItem(1)
        ___qtablewidgetitem1.setText("File Name")

        self.openFolderButton.setText(QCoreApplication.translate("MainWindow", u"Open Folder", None))
        self.selectAllButton.setText(QCoreApplication.translate("MainWindow", u"Select All", None))
        self.sendButton.setText(QCoreApplication.translate("MainWindow", u"Send", None))
        ___qtablewidgetitem4 = self.completedFileTableWidget.horizontalHeaderItem(0)
        ___qtablewidgetitem4.setText("File Size")
        ___qtablewidgetitem5 = self.completedFileTableWidget.horizontalHeaderItem(1)
        ___qtablewidgetitem5.setText("File Name")

        self.label_version.setText("v0.0.6.3")

    def eventFilter(self, source, event) -> bool:
        if source == self.frame_top_btns:
            if event.type() == QEvent.MouseButtonPress:
                self.offset = event.pos()
            elif event.type() == QEvent.MouseMove and self.offset is not None:
                self.move(self.pos() - self.offset + event.pos())
                return True
            elif event.type() == QEvent.MouseButtonRelease:
                self.offset = None
        return super().eventFilter(source, event)

    def readChangelog(self):
        with open(r".\CHANGELOG.md","r",encoding="utf-8") as mdFile:
            self.changelogTextEdit.setMarkdown(mdFile.read())
        os.remove(r".\CHANGELOG.md")

    def connectedButtons(self):
        self.homeMenuButton.clicked.connect(lambda: self.goHomePage())
        self.uploadButton.clicked.connect(lambda: self.goUploadPage())
        self.uploadMenuButton.clicked.connect(lambda: self.goUploadPage())
        self.downloadMenuButton.clicked.connect(lambda: self.goDownloadPage())
        self.downloadButton.clicked.connect(lambda: self.goDownloadPage())
        self.selectAllButton.clicked.connect(lambda: self.allSelectItemsButtonState())
        self.sendButton.clicked.connect(lambda: self.sendFiles())
        self.btn_close.clicked.connect(lambda: self.closeApplication())
        self.btn_maximize_restore.clicked.connect(lambda: self.setMaximized())
        self.btn_minimize.clicked.connect(lambda: self.showMinimized())
        self.btn_toggle_menu.clicked.connect(lambda: self.toggleMenu(220, True))
        self.githubButton.clicked.connect(lambda: openSourcePage("https://github.com/Helmssyss/SyncMagnet"))
        self.openDownloadFolderButton.clicked.connect(lambda: self.openFolder())

        self.appRunWorker = SyncProcessRunWorker(self.APPLICATON)
        self.appRunThread = QThread(self)
        self.appRunWorker.moveToThread(self.appRunThread)
        self.appRunThread.started.connect(self.appRunWorker.start)
        self.appRunThread.start()
        self.appRunWorker.isBackground.connect(self.onAppIsBackground)

        self.getInfoWorker = SyncClientInfoWorker()
        self.getInfoThread = QThread(self)
        self.getInfoWorker.moveToThread(self.getInfoThread)
        self.getInfoThread.started.connect(self.getInfoWorker.start)
        self.getInfoThread.start()
        self.getInfoWorker.connectGetClientInfo.connect(self.getClientInfo)
        self.frame_top_btns.mouseDoubleClickEvent = self.doubleClickMaximizeRestore

    @pyqtSlot(bool)
    def onAppIsBackground(self, isBackground: bool):
        if isBackground:
            pass
            # print("Background")
        else:
            pass
            # print("Foreground")

    def closeApplication(self):
        try:
            self.run = False
            self.isBack = True
            self.appRunWorker.setRunState(False)
            self.appRunWorker.disconnect()
            self.getInfoWorker.setRunState(False)
            self.getInfoWorker.disconnect()
            self.downloadFileWorker.setRunState(False)
            self.appRunThread.quit()
            self.appRunThread.wait()
            self.getInfoThread.quit()
            self.getInfoThread.wait()
            self.downloadFileThread.quit()
            self.downloadFileThread.wait()
            self.close()
        finally:
            raise ThrowSyncClose()

    def setMaximized(self):
        if self.isMaximized():
            ico = QIcon()
            ico.addFile(u":/16x16/assets/16x16/cil-window-maximize.png")
            self.btn_maximize_restore.setIcon(ico)
            self.btn_maximize_restore.setIconSize(QSize(27, 17))
            self.showNormal()
        else:
            ico = QIcon()
            ico.addFile(u":/16x16/assets/16x16/cil-window-restore.png")
            self.btn_maximize_restore.setIcon(ico)
            self.btn_maximize_restore.setIconSize(QSize(27, 17))
            self.showMaximized()

    def doubleClickMaximizeRestore(self,event):
        if event.type() == QEvent.MouseButtonDblClick:
            QTimer.singleShot(250, lambda: self.setMaximized())

    def openFolder(self):
        print(self.label_top_info_1.text())
        return os.startfile(self.label_top_info_1.text())

    def goHomePage(self):
        self.stackedWidget.setCurrentIndex(0)
        self.label_top_info_2.setText("| HOME")
        self.label_top_info_1.setText("")
        if not self.downloadMenuButton.isEnabled():
            if getattr(self, 'listener', None):
                self.listener.setRunState(False)
                self.listenerThread.quit()
                self.listenerThread.wait()

            self.downloadMenuButton.setEnabled(True)
            self.downloadFileWorker.setRunState(False)
            self.downloadFileThread.quit()
            self.downloadFileThread.wait()
            self.syncMagnetDllService.SetCanDeviceState()

    def goUploadPage(self):
        self.stackedWidget.setCurrentIndex(2)
        self.label_top_info_2.setText("| UPLOAD")
        self.label_top_info_1.setText("")
        if not self.downloadMenuButton.isEnabled():
            if getattr(self, 'listener', None):
                self.listener.setRunState(False)
                self.listenerThread.quit()
                self.listenerThread.wait()
                
            self.downloadMenuButton.setEnabled(True)
            self.downloadFileWorker.setRunState(False)
            self.downloadFileThread.quit()
            self.downloadFileThread.wait()
            self.syncMagnetDllService.SetCanDeviceState()

    def goDownloadPage(self):
        self.stackedWidget.setCurrentIndex(1)
        self.label_top_info_2.setText("| DOWNLOAD")
        root = ET.parse(r".\MagnetManifest.xml")
        fPathTag = root.find('.//FolderPath')
        fPath = fPathTag.attrib["default_folder_path"]
        self.label_top_info_1.setText(fPath)
        if getattr(self, 'listener', None):
            self.listener.setRunState(False)
            self.listenerThread.quit()
            self.listenerThread.wait()
        
        self.downloadMenuButton.setEnabled(False)
        self.downloadFileWorker = SyncFileDownloadWorker()
        self.downloadFileThread = QThread()
        self.downloadFileWorker.moveToThread(self.downloadFileThread)
        self.downloadFileThread.started.connect(self.downloadFileWorker.start)
        self.downloadFileThread.start()
        self.isDownload = True
        self.loadPageListener()

    def loadPageListener(self):
        self.listener = SyncLoadFileListener()
        self.listenerThread = QThread()
        self.listener.moveToThread(self.listenerThread)
        self.listenerThread.started.connect(self.listener.listen)
        self.listenerThread.start()
        self.listener.connectShowLoadPage.connect(self.loadPage)
        self.loadWindow = None

    @pyqtSlot(bool)
    def loadPage(self, isShow: bool):
        if isShow:
            if self.loadWindow is None:
                self.loadWindowOpened()
        else:
            if self.loadWindow is not None:
                QTimer.singleShot(5000,lambda: self.loadWindowClosed())
    
    def loadWindowOpened(self):
        self.loadWindow = LoadWindow(self,self.syncMagnetDllService,self.isDownload)
        self.loadWindow.show()
        self.homeMenuButton.setEnabled(False)
        self.uploadButton.setEnabled(False)
        self.uploadMenuButton.setEnabled(False)
        self.downloadMenuButton.setEnabled(False)
        self.downloadButton.setEnabled(False)
        self.selectAllButton.setEnabled(False)
        self.sendButton.setEnabled(False)
        self.btn_close.setEnabled(False)
        self.btn_maximize_restore.setEnabled(False)
        self.btn_minimize.setEnabled(False)
        self.btn_toggle_menu.setEnabled(False)
        self.openDownloadFolderButton.setEnabled(False)

    def loadWindowClosed(self):
        try:
            self.loadWindow.close()
            self.loadWindow = None
            self.homeMenuButton.setEnabled(True)
            self.uploadButton.setEnabled(True)
            self.uploadMenuButton.setEnabled(True)
            self.downloadMenuButton.setEnabled(True)
            self.downloadButton.setEnabled(True)
            self.selectAllButton.setEnabled(True)
            self.sendButton.setEnabled(True)
            self.btn_close.setEnabled(True)
            self.btn_maximize_restore.setEnabled(True)
            self.btn_minimize.setEnabled(True)
            self.btn_toggle_menu.setEnabled(True)
            self.openDownloadFolderButton.setEnabled(True)
            if self.stackedWidget.currentIndex() == 1:
                self.downloadMenuButton.setEnabled(False)
            else:
                self.downloadMenuButton.setEnabled(True)
        except:
            pass

    @pyqtSlot(dict)
    def getClientInfo(self,param: dict):
        if param["device_battery"] > 90 and param["device_battery"] <= 100:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_full_FILL0_wght400_GRAD0_opsz24.png"))
        
        if param["device_battery"] >= 80 and param["device_battery"] <= 90:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_6_bar_FILL0_wght400_GRAD0_opsz24.png"))
        
        if param["device_battery"] >= 60 and param["device_battery"] <= 79:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_5_bar_FILL0_wght400_GRAD0_opsz24.png"))
        
        if param["device_battery"] >= 40 and param["device_battery"] <= 59:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_4_bar_FILL0_wght400_GRAD0_opsz24.png"))
        
        if param["device_battery"] >= 20 and param["device_battery"] <= 39:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_3_bar_FILL0_wght400_GRAD0_opsz24.png"))
        
        if param["device_battery"] >= 10 and param["device_battery"] <= 19:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_2_bar_FILL0_wght400_GRAD0_opsz24.png"))
        
        if param["device_battery"] >= 3 and param["device_battery"] <= 9:
            self.batteryButton.setIcon(QIcon(":/24x24/assets/24x24/battery_1_bar_FILL0_wght400_GRAD0_opsz24.png"))
        
        self.menuBatteryPercentLabel.setText(f"""<html><head/><body><p><span style=" font-size:10pt;">{param['device_battery']}</span><span style=" font-size:10pt; vertical-align:super;">%</span></p></body></html>""")
        self.deviceButton.setText(f'         {param["device_name"]}')
        self.deviceButton.setToolTip(f"<html><head/><body><p>{param['device_name']}</p></body></html>")
        self.batteryButton.setText(f"        {param['device_battery']}%")
    
    def allSelectItemsButtonState(self):
        if not self.isSelectAll:
            self.selectAllButton.setText("Unselect")
            self.selectAllButton.setIcon(QIcon(u":/16x16/assets/16x16/cil-x.png"))
            self.sendFileListWidget.selectAllItems()
            self.isSelectAll = True
        else:
            self.selectAllButton.setText("Select All")
            self.selectAllButton.setIcon(QIcon(u":/20x20/assets/20x20/cil-task.png"))
            self.sendFileListWidget.unSelectAllItems()
            self.isSelectAll = False

    def sendFiles(self):
        if len(self.sendFileListWidget.selectedItems()) > 0:
            if getattr(self, 'listener', None):
                self.listener.setRunState(False)
                self.listenerThread.quit()
                self.listenerThread.wait()
            self.isDownload = False
            self.loadPageListener()
            self.homeMenuButton.setEnabled(False)
            self.uploadMenuButton.setEnabled(False)
            self.downloadMenuButton.setEnabled(False)
            self.selectItemSendWorker = SyncFileSenderWorker(sendListWidget=self.sendFileListWidget)
            self.selectItemSendThread = QThread(self)
            self.selectItemSendWorker.moveToThread(self.selectItemSendThread)
            self.selectItemSendWorker.sendCompleted.connect(self.onSendWorkerCompleted)
            self.selectItemSendThread.started.connect(self.selectItemSendWorker.start)
            self.selectItemSendThread.start()

    @pyqtSlot(list)
    def onSendWorkerCompleted(self,sendFiles: list):
        for row, file_info in enumerate(sendFiles):
            self.completedFileTableWidget.insertRow(row)
            size_item = QTableWidgetItem(self.syncMagnetDllService.formatSize(file_info[0]))
            size_item.setIcon(QIcon(":/16x16/assets/16x16/cil-check-alt.png"))
            name_item = QTableWidgetItem(file_info[1])
            self.completedFileTableWidget.setItem(row, 0, size_item)
            self.completedFileTableWidget.setItem(row, 1, name_item)

        for item in self.sendFileListWidget.selectedItems():
            self.sendFileListWidget.deleteSelectedItem(item)

        self.selectItemSendThread.quit()
        self.selectItemSendThread.wait()
        self.homeMenuButton.setEnabled(True)
        self.uploadMenuButton.setEnabled(True)
        self.downloadMenuButton.setEnabled(True)
        self.isSelectAll = False
        self.allSelectItemsButtonState()

    def toggleMenu(self, maxWidth, enable):
        isHidden = False
        if enable:
            isHidden = True
            self.menuBatteryPercentLabel.setVisible(False)
            width = self.frame_left_menu.width()
            maxExtend = maxWidth
            standard = 70

            if width == 70:
                widthExtended = maxExtend

            else:
                widthExtended = standard
                isHidden = False

            self.animation = QPropertyAnimation(self.frame_left_menu, b"minimumWidth")
            self.animation.setDuration(300)
            self.animation.setStartValue(width)
            self.animation.setEndValue(widthExtended)
            self.animation.setEasingCurve(QEasingCurve.InOutQuart)
            self.animation.start()
            self.animation.finished.connect(lambda: self.menuBatteryPercentLabel.setVisible(False) if isHidden else self.menuBatteryPercentLabel.setVisible(True))