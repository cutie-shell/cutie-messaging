import Cutie 1.0
import QtQuick 2.14

CutiePage {
	id: root
	width: mainWindow.width
	height: mainWindow.height
	property var threadId: ""
	property var thread: Store.threads.filter(t => t.Sender == threadId)[0]
	CutiePageHeader {
		id: header
		title: root.threadId
		anchors.top: parent.top
	}
	CutieListView {
		anchors.fill: parent
		anchors.topMargin: header.height
		clip: true
		model: Store.threads.filter(t => t.Sender == threadId)[0].Messages

		delegate: CutieListItem {
			width: parent ? parent.width : 0
			id: litem
			text: modelData.Message
			subText: modelData.LocalSentTime
		}

		onCountChanged: {
			currentIndex = count - 1;
		}

		Component.onCompleted: {
			positionViewAtEnd();
		}
	}	
}
