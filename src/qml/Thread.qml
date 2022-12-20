import Cutie 1.0
import QtQuick 2.14

CutiePage {
	id: root
	width: mainWindow.width
	height: mainWindow.height
	property var thread: null
	ListView {
		anchors.fill: parent
		model: root.thread.Messages
		header: CutiePageHeader {
			id: header
			title: root.thread.Sender
		}
		delegate: CutieListItem {
			width: parent ? parent.width : 0
			id: litem
			text: modelData.Message
			subText: modelData.LocalSentTime
		}
	}	
}
