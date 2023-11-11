class SyncStyle:
    connectPageContentButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 7px;	
			background-color: rgb(52, 59, 72);
			color: #ffffff;
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    connectPageCloseButton = """
		QPushButton {
			border: none;
			background-color: transparent;
			border-top-right-radius: 10px;
		}
		QPushButton:hover {
			background-color: rgb(52, 59, 72);
		}
		QPushButton:pressed {	
			background-color: red;
		}
	"""
    connectPageMinimizedButton = """
		QPushButton {
			border: none;
			background-color: transparent;
		}
		QPushButton:hover {
			background-color: rgb(52, 59, 72);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
		}
	"""
    connectPageTitleFrame = """
		QFrame{
			background-color: rgba(27, 29, 35, 200);
			border: 2px solid transparent;
			border-top-left-radius: 10px;
			border-top-right-radius: 10px;
		}
	"""
    connectPageContentFrame = """
		QFrame{
			background-color: rgb(44, 49, 60);
			border-bottom-right-radius : 10px;
			border-bottom-left-radius : 10px;
		}
	"""
    serverPageMainWindow = """
		QMainWindow {background: transparent; }
		QToolTip {
			color: #ffffff;
			background-color: rgba(27, 29, 35, 160);
			border: 1px solid rgb(40, 40, 40);
			border-radius: 2px;
		}
	"""
    serverPageToggleMenuButton = """
		QPushButton {
			background-position: center;
			background-repeat: no-reperat;
			border: none;
			background-color: rgb(27, 29, 35);
			border-top-left-radius: 10px;
		}
		QPushButton:hover {
			background-color: rgb(33, 37, 43);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
		}
	"""
    serverPageMinimizeButton = """
		QPushButton {
			border: none;
			background-color: transparent;
			border-top-right-radius: 0px;
		}
		QPushButton:hover {
			background-color: rgb(52, 59, 72);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
		}
	"""
    serverPageDownloadMenuButton = """
		QPushButton {	
			border: none;
			border-left: 25px solid rgb(27, 29, 35);
			background-color: rgb(27, 29, 35);
			text-align: left;
		}
		QPushButton:hover {
			background-color: rgb(33, 37, 43);
			border-right: 3px solid rgb(44, 49, 60);
			border-left: 25px solid rgb(33, 37, 43);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
			border-left: 28px solid rgb(85, 170, 255);
		}
	"""
    serverPageUploadMenuButton = """
		QPushButton {
			border: none;
			border-left: 25px solid rgb(27, 29, 35);
			background-color: rgb(27, 29, 35);
			text-align: left;
		}
		QPushButton:hover {
			background-color: rgb(33, 37, 43);
			border-right: 3px solid rgb(44, 49, 60);
			border-left: 25px solid rgb(33, 37, 43);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
			border-left: 28px solid rgb(85, 170, 255);
		}
	"""
    serverPageHomeButton = """
		QPushButton {
			border: none;
			border-left: 25px solid rgb(27, 29, 35);
			background-color: rgb(27, 29, 35);
			text-align: left;
		}
		QPushButton:hover {
			background-color: rgb(33, 37, 43);
			border-right: 3px solid rgb(44, 49, 60);
			border-left: 25px solid rgb(33, 37, 43);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
			border-left: 28px solid rgb(85, 170, 255);
		}
	"""
    serverPageCloseButton = """
		QPushButton {
			border: none;
			background-color: transparent;
			border-top-right-radius: 10px;
		}
		QPushButton:hover {
			background-color: rgb(52, 59, 72);
		}
		QPushButton:pressed {	
			background-color: red;
		}
	"""
    serverPageDeviceButton = """
		QPushButton {
			border: none;
			border-left: 29px solid rgb(27, 29, 35);
			background-color: rgb(27, 29, 35);
			text-align: left;
		}
		QPushButton:hover {
			background-color: rgb(33, 37, 43);
			border-right: 3px solid rgb(44, 49, 60);
			border-left: 29px solid rgb(33, 37, 43);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
			border-left: 28px solid rgb(85, 170, 255);
		}
	"""
    serverPageDownloadButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {	
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageOpenDownloadFolderButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageChangeDownloadFolderButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {	
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageDownloadedFilesTable = """
		QTableWidget {
			background-color: rgb(39, 44, 54);
			padding: 10px;
			border-radius: 5px;
			gridline-color: rgb(44, 49, 60);
			border-bottom: 1px solid rgb(44, 49, 60);
		}
		QTableWidget::item{
			border-color: rgb(44, 49, 60);
			padding-left: 5px;
			padding-right: 5px;
			gridline-color: rgb(44, 49, 60);
		}
		QTableWidget::item:selected{
			background-color: rgb(85, 170, 255);
		}
		QScrollBar:horizontal {
			border: none;
			background: rgb(52, 59, 72);
			height: 14px;
			margin: 0px 21px 0 21px;
			border-radius: 0px;
		}
		QScrollBar:vertical {
			border: none;
			background: rgb(52, 59, 72);
			width: 14px;
			margin: 21px 0 21px 0;
			border-radius: 0px;
		}
		QHeaderView::section{
			Background-color: rgb(39, 44, 54);
			max-width: 30px;
			border: 1px solid rgb(44, 49, 60);
			border-style: none;
			border-bottom: 1px solid rgb(44, 49, 60);
			border-right: 1px solid rgb(44, 49, 60);
		}
		QTableWidget::horizontalHeader {	
			background-color: rgb(81, 255, 0);
		}
		QHeaderView::section:horizontal
		{
			border: 1px solid rgb(32, 34, 42);
			background-color: rgb(27, 29, 35);
			padding: 3px;
			border-top-left-radius: 7px;
			border-top-right-radius: 7px;
		}
		QHeaderView::section:vertical{border: 1px solid rgb(44, 49, 60);}
	"""
    serverPageChangelogTextEdit = """
		QPlainTextEdit {
			background-color: rgb(27, 29, 35);
			border-radius: 5px;
			padding: 10px;
		}
		QPlainTextEdit:hover {
			border: 2px solid rgb(64, 71, 88);
		}
		QPlainTextEdit:focus {
			border: 2px solid rgb(91, 101, 124);
		}
	"""
    serverPageUploadButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {	
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageGithubButton = """
		QPushButton {
			border: none;
			background-color: transparent;
			border-radius: 25px;
		}
		QPushButton:hover {
			background-color: rgb(52, 59, 72);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
		}
	"""
    serverPageBatteryButton = """
		QPushButton {
			border: none;
			border-left: 29px solid rgb(27, 29, 35);
			background-color: rgb(27, 29, 35);
			text-align: left;
		}
		QPushButton:hover {
			background-color: rgb(33, 37, 43);
			border-right: 3px solid rgb(44, 49, 60);
			border-left: 29px solid rgb(33, 37, 43);
		}
		QPushButton:pressed {	
			background-color: rgb(85, 170, 255);
			border-left: 28px solid rgb(85, 170, 255);
		}
	"""
    serverPageMainFrame = """
	/* LINE EDIT */
	QLineEdit {
		background-color: rgb(27, 29, 35);
		border-radius: 5px;
		border: 2px solid rgb(27, 29, 35);
		padding-left: 10px;
	}
	QLineEdit:hover {
		border: 2px solid rgb(64, 71, 88);
	}
	QLineEdit:focus {
		border: 2px solid rgb(91, 101, 124);
	}
	
	/* SCROLL BARS */
	QScrollBar:horizontal {
	    border: none;
	    background: rgb(52, 59, 72);
	    height: 14px;
	    margin: 0px 21px 0 21px;
		border-radius: 0px;
	}
	QScrollBar::handle:horizontal {
	    background: rgb(85, 170, 255);
	    min-width: 25px;
		border-radius: 7px
	}
	QScrollBar::add-line:horizontal {
		border: none;
		background: rgb(55, 63, 77);
		width: 20px;
		border-top-right-radius: 7px;
		border-bottom-right-radius: 7px;
		subcontrol-position: right;
		subcontrol-origin: margin;
	}
	QScrollBar::sub-line:horizontal {
		border: none;
		background: rgb(55, 63, 77);
		width: 20px;
		border-top-left-radius: 7px;
		border-bottom-left-radius: 7px;
		subcontrol-position: left;
		subcontrol-origin: margin;
	}
	QScrollBar::up-arrow:horizontal, QScrollBar::down-arrow:horizontal{background: none;}
	QScrollBar::add-page:horizontal, QScrollBar::sub-page:horizontal{background: none;}
	QScrollBar:vertical {
		border: none;
		background: rgb(52, 59, 72);
		width: 14px;
		margin: 21px 0 21px 0;
		border-radius: 0px;
	}
	QScrollBar::handle:vertical {	
		background: rgb(85, 170, 255);
		min-height: 25px;
		border-radius: 7px
	}
	QScrollBar::add-line:vertical {
		border: none;
		background: rgb(55, 63, 77);
		height: 20px;
		border-bottom-left-radius: 7px;
		border-bottom-right-radius: 7px;
		subcontrol-position: bottom;
		subcontrol-origin: margin;
	}
	QScrollBar::sub-line:vertical {
		border: none;
		background: rgb(55, 63, 77);
		height: 20px;
		border-top-left-radius: 7px;
		border-top-right-radius: 7px;
		subcontrol-position: top;
		subcontrol-origin: margin;
	}
	QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {background: none;}
	QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {background: none;}
	/* CHECKBOX */
	QCheckBox::indicator {
		border: 3px solid rgb(52, 59, 72);
		width: 15px;
		height: 15px;
		border-radius: 10px;
		background: rgb(44, 49, 60);
	}
	QCheckBox::indicator:hover {
		border: 3px solid rgb(58, 66, 81);
	}
	QCheckBox::indicator:checked {
		background: 3px solid rgb(52, 59, 72);
		border: 3px solid rgb(52, 59, 72);	
		background-image: url(:/16x16/icons/16x16/cil-check-alt.png);
	}

	/* RADIO BUTTON */
	QRadioButton::indicator {
		border: 3px solid rgb(52, 59, 72);
		width: 15px;
		height: 15px;
		border-radius"
							": 10px;
		background: rgb(44, 49, 60);
	}
	QRadioButton::indicator:hover {
		border: 3px solid rgb(58, 66, 81);
	}
	QRadioButton::indicator:checked {
		background: 3px solid rgb(94, 106, 130);
		border: 3px solid rgb(52, 59, 72);	
	}

	/* COMBOBOX */
	QComboBox{
		background-color: rgb(27, 29, 35);
		border-radius: 5px;
		border: 2px solid rgb(27, 29, 35);
		padding: 5px;
		padding-left: 10px;
	}
	QComboBox:hover{
		border: 2px solid rgb(64, 71, 88);
	}
	QComboBox::drop-down {
		subcontrol-origin: padding;
		subcontrol-position: top right;
		width: 25px; 
		border-left-width: 3px;
		border-left-color: rgba(39, 44, 54, 150);
		border-left-style: solid;
		border-top-right-radius: 3px;
		border-bottom-right-radius: 3px;	
		background-image: url(:/16x16/icons/16x16/cil-arrow-bottom.png);
		background-position: center;
		background-repeat: no-reperat;
	}
	QComboBox QAbstractItemView {
		color: rgb(85, 170, 255);	
		background-color: rgb(27, 29, 35);
		padding: 10px;
		selection-background-color: rgb(39, 44, 54);
	}

	/* SLIDERS */
	QSlider::groove:horizontal {
		border-radius: 9px;
		height: 18px;
		margin: 0px;
		background-color: rgb(52, 59, 72);
	}
	QSlider::groove:horizontal:hover {
		background-color: rgb(55, 62, 76);
	}
	QSlider::handle:horizontal {
		background-color: rgb(85, 170, 255);
		border: none;
		height: 18px;
		width: 18px;
		margin: 0px;
		border-radius: 9px;
	}
	QSlider::handle:horizontal:hover {
		background-color: rgb(105, 180, 255);
	}
	QSlider::handle:horizontal:pressed {
		background-color: rgb(65, 130, 195);
	}

	QSlider::groove:vertical {
		border-radius: 9px;
		width: 18px;
		margin: 0px;
		background-color: rgb(52, 59, 72);
	}
	QSlider::groove:vertical:hover {
		background-color: rgb(55, 62, 76);
	}
	QSlider::handle:vertical {
		background-color: rgb(85, 170, 255);
		border: none;
		height: 18px;
		width: 18px;
		margin: 0px;
		border-radius: 9px;
	}
	QSlider::handle:vertical:hover {
		background-color: rgb(105, 180, 255);
	}
	QSlider::handle:vertical:pressed {
		background-color: rgb(65, 130, 195);
	}
	"""
    serverPageOpenFolderButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {	
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageSelectAllButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {	
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageSendButton = """
		QPushButton {
			border: 2px solid rgb(52, 59, 72);
			border-radius: 5px;	
			background-color: rgb(52, 59, 72);
		}
		QPushButton:hover {
			background-color: rgb(57, 65, 80);
			border: 2px solid rgb(61, 70, 86);
		}
		QPushButton:pressed {	
			background-color: rgb(35, 40, 49);
			border: 2px solid rgb(43, 50, 61);
		}
	"""
    serverPageSendListWidget = """
		QListWidget{
			border: 2px solid rgb(39, 44, 54);
			border-radius: 10px;
		}
		QListWidget::item{
			padding: 10px;
			margin: 3px;
		}
		QListWidget::item::hover{
			background-color: rgb(52, 59, 72);
			border-radius: 10px;
		}
		QListWidget::item::selected{
			background-color:  rgb(85, 170, 255);
			border-radius: 10px;
			padding: 10px;
		}
	"""
    loadPageProgressBar = """
	QProgressBar{
		border-radius: 10px;
		background-color:  rgb(52, 59, 72);
		color: black;
	}
	QProgressBar::chunk {
		background-color: rgb(85, 170, 255);
		border-radius: 10px;
	}
	"""