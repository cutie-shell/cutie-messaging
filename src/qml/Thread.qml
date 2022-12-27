import Cutie 1.0
import QtQuick 2.14

CutiePage {
	id: root
	width: mainWindow.width
	height: mainWindow.height
	property var threadId: ""
	property var thread: Store.threads.filter(t => t.Sender == threadId)[0]
	ListView {
		anchors.fill: parent
		model: Store.threads.filter(t => t.Sender == threadId)[0].Messages
		header: CutiePageHeader {
			id: header
			title: root.threadId
		}
		delegate: CutieListItem {
			width: parent ? parent.width : 0
			id: litem
			text: modelData.Message
			subText: modelData.LocalSentTime
		}
	}	
}
