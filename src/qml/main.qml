import Cutie 1.0
import QtQuick 2.14

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	visible: false
	title: qsTr("Messaging")

	onClosing: {
		visible = false;
		close.accepted = false;
	}

	Component.onCompleted: {
		CutieModemSettings.modems.forEach((m) => {
			m.incomingMessage.connect(incomingMessage);
		});
	}

	function view() {
		visible = true;
	}

	function incomingMessage(message, props) {
		props.Message = message;
		let threads = Store.threads;
		let thread = threads.filter(t => t.Sender == props.Sender)[0];
		threads = threads.filter(t => t.Sender != props.Sender);
		if (thread) {
			thread.Messages.push(props);
		} else {
			thread = {
				"Sender": props.Sender,
				"Messages": [props,]
			};
		}
		threads.unshift(thread);
		Store.threads = threads;
		CutieNotifications.notify("Messaging", 0, "", props.Sender, message, [], {}, 0);
	}

	initialPage: CutiePage {
		width: mainWindow.width
		height: mainWindow.height
		CutieListView {
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
					mainWindow.pageStack.push("qrc:/Thread.qml", {threadId: modelData.Sender});
				}
			}
		}	
	}

}
