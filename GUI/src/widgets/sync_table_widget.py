from PyQt5.QtWidgets import QTableWidget
from PyQt5.QtWidgets import QFrame
from PyQt5.QtWidgets import QAbstractScrollArea
from PyQt5.QtWidgets import QAbstractItemView
from PyQt5.QtCore    import Qt

from src.funcs.sync_style import SyncStyle

class SyncTableWidget(QTableWidget):
    def __init__(self, parent) -> None:
        super().__init__(parent)
        self.setStyleSheet(SyncStyle.serverPageDownloadedFilesTable)
        self.setFrameShape(QFrame.NoFrame)
        self.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOn)
        self.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
        self.setAutoScrollMargin(16)
        self.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.setAlternatingRowColors(False)
        self.setSelectionMode(QAbstractItemView.NoSelection)
        self.setSelectionBehavior(QAbstractItemView.SelectItems)
        self.setShowGrid(True)
        self.setGridStyle(Qt.CustomDashLine)
        self.setSortingEnabled(False)
        self.setRowCount(2)
        self.setColumnCount(2)
        self.horizontalHeader().setVisible(True)
        self.horizontalHeader().setCascadingSectionResizes(True)
        self.horizontalHeader().setDefaultSectionSize(200)
        self.horizontalHeader().setHighlightSections(False)
        self.horizontalHeader().setStretchLastSection(True)
        self.verticalHeader().setVisible(False)
        self.verticalHeader().setCascadingSectionResizes(False)
        self.verticalHeader().setHighlightSections(False)
        self.verticalHeader().setStretchLastSection(True)
