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

	function view(threadId) {
		visible = true;
		if (threadId != "")
			pageStack.push("qrc:/Thread.qml", { threadId });
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

			menu: CutieMenu {
				CutieMenuItem {
					text: qsTr("New Message")
					onTriggered: {
						pageStack.push("qrc:/SendTo.qml", {})
					}
				}
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

				menu: CutieMenu {
					CutieMenuItem {
						text: qsTr("Delete")
						onTriggered: {
							let threads = Store.threads;
							threads.splice(index, 1);
							Store.threads = threads;
						}
					}
				}
			}
		}	
	}

}
