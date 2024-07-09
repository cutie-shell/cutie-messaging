import Cutie
import Cutie.Modem
import Cutie.Phonenumber
import QtQuick

CutieWindow {
	id: mainWindow
	width: 400
	height: 800
	visible: true
	title: qsTr("Messaging")

	property string localISO: CutiePhonenumberHelper.MCCtoISO(
		CutieModemSettings.modems[0].networkCountryCode)

	function openThread(number) {
		mainWindow.pageStack.push("qrc:/Thread.qml", {
			threadId: number
		});
	}

	function nameForNumber(number) {
		let sender = CutiePhonenumberHelper.createPhonenumber(number, mainWindow.localISO);
		if ("contacts" in contactStore.data)
			for (let i = 0; i < contactStore.data.contacts.length; i++) {
				let contact = contactStore.data.contacts[i]
				let contactNumber = CutiePhonenumberHelper.createPhonenumber(
					contact.PhoneNumber, mainWindow.localISO);
				if (sender.locallyEqualTo(contactNumber, mainWindow.localISO)) {
					return contact.FirstName + " " + contact.LastName;
				}
			}
		return number;
	}

	CutieStore {
		id: messageStore
		appName: "cutie-messaging"
		storeName: "messages"
	}

	CutieStore {
		id: contactStore
		appName: "cutie-contacts"
		storeName: "contacts"
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
				text: nameForNumber(modelData.Sender)
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
