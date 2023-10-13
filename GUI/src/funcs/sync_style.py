SYNC_LISTWIDGET_STYLE:str = """
QListWidget::item{
	font: 75 8pt;
	color: rgb(63, 81, 181);
	background-color: white;
}
QListWidget::item{
    background: rgb(255,255,255); 
}
QListWidget::item:selected{
    background: rgb(128,128,255);
}
QListWidget::item:hover{
	background: rgb(128,128,255);
	color: rgb(18,18,18);
}
"""