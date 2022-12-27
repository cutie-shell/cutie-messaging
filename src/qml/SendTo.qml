import Cutie 1.0
import QtQuick 2.14
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.14

CutiePage {
	id: root
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
	}
	CutieButton {
		id: connectbutton
		buttonText: qsTr("Open")
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 20
		onClicked: {
			pageStack.replaceTop("qrc:/Thread.qml", {threadId: recipentText.text});
		}
	}
}