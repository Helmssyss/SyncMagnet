from PyQt5.QtWidgets import QTextEdit
from PyQt5.QtCore import QSize

from src.funcs.sync_style import SyncStyle

class SyncTextEdit(QTextEdit):
    def __init__(self,parent):
        super().__init__(parent)
        self.setMinimumSize(QSize(200, 200))
        self.setStyleSheet(SyncStyle.serverPageChangelogTextEdit)
        self.setReadOnly(True)
