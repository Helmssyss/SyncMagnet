# -*- coding: utf-8 -*-

import os
import sys
import threading
import xml.etree.ElementTree as ET
from time import sleep
from PyQt5 import QtWidgets
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtWidgets import QWidget

from src import SyncMagnetData
from src import SyncMagnetDllService
from src import SyncListWidget

class Ui_MainWindow(QMainWindow):
    def __init__(self) -> None:
        super(Ui_MainWindow,self).__init__()
        self.threads = []
        self.setupUi(self)
        self.process()

    def process(self):
        self.sync = SyncMagnetDllService()
        if self.sync.LoadMagnetDll():
            t1 = threading.Thread(target=self.sync.SetManageDll)
            t1.start()
            t2 = threading.Thread(target=self.displayDeviceName)
            t2.start()
            self.threads.append(t1)
            self.threads.append(t2)

    def displayDeviceName(self):
            while not os.path.exists(r".\magnet.xml"):
                self.label.clear()
                sleep(0.5)

            # XmlTree = ET.parse(r'.\magnet.xml')
            # root = XmlTree.getroot()
            # print(root[0].tag)
            # device_name = root.find('DeviceName').text
            # # device_battery = root.find('DeviceBattery').text
            # self.label.setText(f"Device Name: {device_name}")
            # os.remove(r".\magnet.xml")
            # # self.label_2.setText(f"Battery: {device_battery}%")
    
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")

        MainWindow.resize(615, 554)
        MainWindow.setMinimumSize(QSize(615, 554))
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")

        self.gridLayout = QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName(u"gridLayout")
        self.groupBox = QGroupBox(self.centralwidget)
        self.groupBox.setObjectName(u"groupBox")

        self.verticalLayout_2 = QVBoxLayout(self.groupBox)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")

        self.listWidget_2 = SyncListWidget(self.groupBox)
        self.listWidget_2.setObjectName(u"listWidget_2")
        self.listWidget_2.setDragEnabled(True)
        self.listWidget_2.setDragDropMode(QAbstractItemView.DragDrop)
        self.verticalLayout_2.addWidget(self.listWidget_2)

        self.frame = QFrame(self.groupBox)
        self.frame.setObjectName(u"frame")
        self.frame.setFrameShape(QFrame.StyledPanel)
        self.frame.setFrameShadow(QFrame.Raised)

        self.horizontalLayout = QHBoxLayout(self.frame)
        self.horizontalLayout.setObjectName(u"horizontalLayout")

        self.pushButton = QPushButton(self.frame)
        self.pushButton.setObjectName(u"pushButton")

        self.horizontalLayout.addWidget(self.pushButton)
        self.horizontalSpacer = QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.horizontalLayout.addItem(self.horizontalSpacer)
        self.verticalLayout_2.addWidget(self.frame)

        self.gridLayout.addWidget(self.groupBox, 1, 0, 1, 2)

        self.groupBox_3 = QGroupBox(self.centralwidget)
        self.groupBox_3.setObjectName(u"groupBox_3")
        self.verticalLayout = QVBoxLayout(self.groupBox_3)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.listWidget = SyncListWidget(self.groupBox_3)
        self.listWidget.setSelectionMode(QAbstractItemView.MultiSelection)
        self.listWidget.setObjectName(u"listWidget")
        self.verticalLayout.addWidget(self.listWidget)

        self.frame_2 = QFrame(self.groupBox_3)
        self.frame_2.setObjectName(u"frame_2")
        self.frame_2.setFrameShape(QFrame.StyledPanel)
        self.frame_2.setFrameShadow(QFrame.Raised)

        self.horizontalLayout_2 = QHBoxLayout(self.frame_2)
        self.horizontalLayout_2.setObjectName(u"horizontalLayout_2")

        self.pushButton_3 = QPushButton(self.frame_2)
        self.pushButton_3.setObjectName(u"pushButton_3")
        self.horizontalLayout_2.addWidget(self.pushButton_3)
        self.pushButton_3.clicked.connect(lambda: SyncMagnetData.sendSelectedItem(listWidget=self.listWidget,manageDll=self.sync))

        self.horizontalSpacer_2 = QSpacerItem(94, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(self.horizontalSpacer_2)
        self.verticalLayout.addWidget(self.frame_2)

        self.gridLayout.addWidget(self.groupBox_3, 0, 5, 2, 2)
        self.horizontalSpacer_3 = QSpacerItem(64, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.gridLayout.addItem(self.horizontalSpacer_3, 1, 2, 1, 1)

        self.groupBox_2 = QGroupBox(self.centralwidget)
        self.groupBox_2.setObjectName(u"groupBox_2")

        self.formLayout_2 = QFormLayout(self.groupBox_2)
        self.formLayout_2.setObjectName(u"formLayout_2")

        self.label = QLabel(self.groupBox_2)
        self.label.setObjectName(u"label")
        self.formLayout_2.setWidget(0, QFormLayout.LabelRole, self.label)

        self.label_2 = QLabel(self.groupBox_2)
        self.label_2.setObjectName(u"label_2")

        self.formLayout_2.setWidget(1, QFormLayout.LabelRole, self.label_2)

        self.verticalSpacer = QSpacerItem(20, 100, QSizePolicy.Minimum, QSizePolicy.Preferred)

        self.formLayout_2.setItem(2, QFormLayout.LabelRole, self.verticalSpacer)

        self.frame_3 = QFrame(self.groupBox_2)
        self.frame_3.setObjectName(u"frame_3")
        self.frame_3.setFrameShape(QFrame.StyledPanel)
        self.frame_3.setFrameShadow(QFrame.Raised)
        self.verticalLayout_3 = QVBoxLayout(self.frame_3)
        self.verticalLayout_3.setObjectName(u"verticalLayout_3")
        self.label_3 = QLabel(self.frame_3)
        self.label_3.setObjectName(u"label_3")

        self.verticalLayout_3.addWidget(self.label_3)

        self.frame_5 = QFrame(self.frame_3)
        self.frame_5.setObjectName(u"frame_5")
        self.frame_5.setFrameShape(QFrame.StyledPanel)
        self.frame_5.setFrameShadow(QFrame.Raised)

        self.verticalLayout_3.addWidget(self.frame_5)

        self.frame_4 = QFrame(self.frame_3)
        self.frame_4.setObjectName(u"frame_4")
        self.frame_4.setFrameShape(QFrame.StyledPanel)
        self.frame_4.setFrameShadow(QFrame.Raised)

        self.horizontalLayout_3 = QHBoxLayout(self.frame_4)
        self.horizontalLayout_3.setObjectName(u"horizontalLayout_3")
        self.pushButton_2 = QPushButton(self.frame_4)
        self.pushButton_2.setObjectName(u"pushButton_2")
        self.horizontalLayout_3.addWidget(self.pushButton_2)
        self.horizontalSpacer_5 = QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        self.horizontalLayout_3.addItem(self.horizontalSpacer_5)
        self.verticalLayout_3.addWidget(self.frame_4)
        self.formLayout_2.setWidget(3, QFormLayout.SpanningRole, self.frame_3)
        self.gridLayout.addWidget(self.groupBox_2, 0, 0, 1, 2)
        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"MainWindow", None))
        self.groupBox.setTitle(QCoreApplication.translate("MainWindow", u"Clientten gelen dosyalar", None))
        self.pushButton.setText(QCoreApplication.translate("MainWindow", u"Save", None))
        self.groupBox_3.setTitle(QCoreApplication.translate("MainWindow", u"Cliente G\u00f6nderilecek Dosyalar", None))
        self.pushButton_3.setText(QCoreApplication.translate("MainWindow", u"Send", None))
        self.groupBox_2.setTitle(QCoreApplication.translate("MainWindow", u"cihaz \u00f6zellikleri", None))
        self.label_3.setText(QCoreApplication.translate("MainWindow", u"Depolama alan\u0131", None))
        self.pushButton_2.setText(QCoreApplication.translate("MainWindow", u"Disconnect", None))
    
    def closeEvent(self, event):
        if os.path.exists(r".\magnet.xml"):
            os.remove(r".\magnet.xml")
        print(self.threads)
        self.threads.clear()
        self.sync.ManageDllFinished()
        exit(0)

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    ui = Ui_MainWindow()
    ui.show()
    sys.exit(app.exec_())
