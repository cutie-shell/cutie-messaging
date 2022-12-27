import Cutie 1.0
import QtQuick 2.14

CutiePage {
	id: root
	width: mainWindow.width
	height: mainWindow.height
	property var threadId: ""
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
			menu: CutieMenu {
				CutieMenuItem {
					text: qsTr("Delete")
					onTriggered: {
						let threadIndex = Store.threads.findIndex(t => t.Sender == threadId);
						let threads = Store.threads;
						let thread = threads[threadIndex];
						let msgs = thread.Messages;
						msgs.splice(index, 1);
						thread.Messages = msgs;
						threads[threadIndex] = thread;
						Store.threads = threads;
					}
				}
			}
		}

		onCountChanged: {
			currentIndex = count - 1;
		}

		Component.onCompleted: {
			positionViewAtEnd();
		}
	}	
}
