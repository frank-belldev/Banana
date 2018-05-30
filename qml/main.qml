import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import Qt.labs.controls 1.0
import Qt.labs.controls.material 1.0
import banana.components 1.0

ApplicationWindow {
    Material.accent: Material.Yellow
    Material.theme: Material.Dark

    visible: true
    width: 360
    height: 480
    minimumWidth: 360
    minimumHeight: 480
    title: qsTr("Banana Downloader")

    DownloadManager {
        id: downloader
        name: userName.text
        password: userPassword.text
        url: cURL.text
    }

    Column {
        anchors.centerIn: parent
        id: grid
        padding: 5
        spacing: 10

        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            font.pointSize: 16
            width: 300
            text: "<b>Banana Downloader</b>"
            horizontalAlignment: TextInput.AlignHCenter
        }
        Rectangle {
            width: 300
            height: 2
            color: "#07FFFFFF"
        }

        Label {
            font.pointSize: 12
            text: "Your Name :"
        }
        TextField {
            id: userName
            font.pointSize: 12
            implicitWidth: 300
            placeholderText: qsTr("Enter name")
        }
        Label {
            font.pointSize: 12
            text: "Your Password :"
        }
        TextField {
            id: userPassword
            font.pointSize: 12
            implicitWidth: 300
            placeholderText: qsTr("Enter your password")
        }
        Label {
            font.pointSize: 12
            text: "Url to download :"
        }
        TextField {
            id: cURL
            font.pointSize: 12
            implicitWidth: 300
            placeholderText: qsTr("Enter client URL")
        }
        Label {
            visible: downloader.loading
            text: qsTr("%1\% Copied").arg(downloader.progress*100);
        }
        ProgressBar {
            visible: downloader.loading
            implicitWidth: 300
            id: downloadProgress
            value: downloader.progress + 0.2
        }
        Row {
            width: 300
            layoutDirection: Qt.RightToLeft
            Button {
                visible: !downloader.loading
                text: "Start"
            }
            Button {
                visible: downloader.loading
                text: "Cancel"
            }
        }
    }
}
