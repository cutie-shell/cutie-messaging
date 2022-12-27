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
		anchors.bottomMargin: writeRow.height + 40
		clip: true
		model: (Store.threads.filter(t => t.Sender == threadId).length > 0) 
			? Store.threads.filter(t => t.Sender == threadId)[0].Messages
			: []

		delegate: CutieListItem {
			width: parent ? parent.width : 0
			id: litem
			text: modelData.Message
			subText: qsTr("%1 - %2").arg(modelData.Sender).arg((new Date(modelData.LocalSentTime)).toString())
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
	Row {
		id: writeRow
		x: 20
		width: parent.width - 40
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 20
		CutieTextField {
			width: parent.width
			onAccepted: {
				CutieModemSettings.modems[0].sendMessage(threadId, text);

				let threadIndex = Store.threads.findIndex(t => t.Sender == threadId);
				let threads = Store.threads;
				let thread = threads[threadIndex];
				if (threadIndex < 0) {
					thread = {
						Sender: threadId,
						Messages: []
					};
				} else {
					threads.splice(threadIndex, 1);
				}
				let msgs = thread.Messages;
				msgs.push({
					Sender: "You",
					LocalSentTime: Date.now(),
					Message: text
				});
				thread.Messages = msgs;
				threads.unshift(thread);
				Store.threads = threads;

				text = "";
			}
		}
	}	
}
