import sys
from PyQt5 import QtWidgets
from src import ConnectWindow

def main():
    app = QtWidgets.QApplication(sys.argv)
    main_ui = ConnectWindow()
    main_ui.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()