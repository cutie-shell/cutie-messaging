import Cutie
import QtQuick

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
		model: (messageStore.data.threads.filter(t => t.Sender == threadId).length > 0) 
			? messageStore.data.threads.filter(t => t.Sender == threadId)[0].Messages
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
						let data = messageStore.data
						let threadIndex = data.threads.findIndex(t => t.Sender == threadId);
						let thread = data.threads[threadIndex];
						let msgs = thread.Messages;
						msgs.splice(index, 1);
						thread.Messages = msgs;
						data.threads[threadIndex] = thread;
						messageStore.data = data;
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

				let data = messageStore.data
				let threadIndex = data.threads.findIndex(t => t.Sender == threadId);
				let thread = data.threads[threadIndex];
				if (threadIndex < 0) {
					thread = {
						Sender: threadId,
						Messages: []
					};
				} else {
					data.threads.splice(threadIndex, 1);
				}
				let msgs = thread.Messages;
				msgs.push({
					Sender: "You",
					LocalSentTime: Date.now(),
					Message: text
				});
				thread.Messages = msgs;
				data.threads.unshift(thread);
				messageStore.data = data;

				text = "";
			}
		}
	}	
}
