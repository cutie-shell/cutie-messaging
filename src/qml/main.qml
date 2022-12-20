import Cutie 1.0
import QtQuick 2.14

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	visible: false
	title: qsTr("Messaging")

	property var threadPage: Qt.createComponent("Thread.qml")

	onClosing: {
		visible = false;
		close.accepted = false;
	}

	function view() {
		visible = true;
	}

	function incomingMessage(sender, message) {
		let threads = Store.threads;
		let thread = threads.filter(t => t.Sender == sender)[0];
		if (thread) thread.Messages.push(message);
		else threads.push({
			"Sender": sender,
			"Messages": [message,]
		});
		Store.threads = threads;
	}

	initialPage: CutiePage {
		width: mainWindow.width
		height: mainWindow.height
		ListView {
			anchors.fill: parent
			model: Store.threads
			header: CutiePageHeader {
				id: header
				title: mainWindow.title
			}
			delegate: CutieListItem {
				width: parent ? parent.width : 0
				id: litem
				text: modelData.Sender
				subText: "Messages" in modelData 
					? modelData.Messages[modelData.Messages.length - 1].Message 
					: "-"
				onClicked: {
					mainWindow.pageStack.push(threadPage, {thread: modelData})
				}
			}
		}	
	}

}
