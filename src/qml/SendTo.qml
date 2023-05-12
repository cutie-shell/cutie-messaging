import Cutie
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

CutiePage {
	id: root

	Component.onCompleted: {
		recipentText.forceActiveFocus();
	}
	
	CutiePageHeader {
		id: header
		title: qsTr("Send To")
	}
	CutieLabel {
		id: instLabel
		text: qsTr("Type a number below and tap \"Open\" to start writing.")
		wrapMode: Text.Wrap
		anchors.top: header.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
	}
	CutieTextField {
		id: recipentText
		text: ""
		anchors.top: instLabel.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
		onAccepted: connectbutton.clicked()
		inputMethodHints: Qt.ImhDialableCharactersOnly
	}
	CutieButton {
		id: connectbutton
		buttonText: qsTr("Open")
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 5
		padding: 10
		onClicked: {
			let data = messageStore.data;
			if (!data.threads) data.threads = [];
			messageStore.data = data;
			pageStack.replaceTop("qrc:/Thread.qml", {threadId: recipentText.text});
		}
	}
}