import Cutie 1.0
import QtQuick 2.14

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	visible: false
	title: qsTr("Messaging")

	ListModel {
		id: threads
	}

	onClosing: {
		visible = false;
		close.accepted = false;
	}

	function view() {
		visible = true;
	}

	function incomingMessage(sender, message) {
		threads.append({
			"Sender": sender,
			"Messages": [message,]
		});
	}

	initialPage: CutiePage {
		width: mainWindow.width
		height: mainWindow.height
		ListView {
			anchors.fill: parent
			model: threads
			header: CutiePageHeader {
				id: header
				title: mainWindow.title
			}
			delegate: CutieListItem {
				width: parent ? parent.width : 0
				id: litem
				text: model.Sender
				subText: model.Messages.get(0).Message
			}
		}	
	}

}
