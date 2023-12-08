import Cutie
import QtQuick

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	visible: true
	title: qsTr("Messaging")

	CutieStore {
		id: messageStore
		appName: "cutie-messaging"
		storeName: "messages"
	}

	initialPage: CutiePage {
		width: mainWindow.width
		height: mainWindow.height
		CutieListView {
			id: lView
			anchors.fill: parent
			model: messageStore.data.threads

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
							let data = messageStore.data;
							data.threads.splice(index, 1);
							messageStore.data = data;
						}
					}
				}
			}
		}	
	}
}
