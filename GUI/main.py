import sys
from   PyQt5 import QtWidgets
from   src   import CheckNetWindow

def main() -> None:
    __APP__ = QtWidgets.QApplication(sys.argv)
    __MAIN_UI__ = CheckNetWindow(__APP__)
    __MAIN_UI__.show()
    sys.exit(__APP__.exec_())

if __name__ == "__main__":
    main()