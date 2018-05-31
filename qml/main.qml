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
        url: cURL.text
        dir: directory.text
        file: file.text
    }

    Column {
        anchors.centerIn: parent
        id: grid
        padding: 5
        spacing: 15

        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            font.pointSize: 16
            width: 300
            text: "<b>Banana Downloader</b>"
            color: Qt.lighter("yellow")
            horizontalAlignment: TextInput.AlignHCenter
        }
        Rectangle {
            width: 300
            height: 2
            color: "#0FFFFFFF"
        }

        Column {
            Label {
                font.pointSize: 12
                text: "Source path to download :"
                color: Qt.lighter("yellow")
            }
            TextField {
                id: cURL
                text: downloader.defaultUrl()
                enabled: !downloader.loading
                font.pointSize: 12
                implicitWidth: 300
                placeholderText: qsTr("Enter source URL")
            }
        }

        Column {
            Label {
                font.pointSize: 12
                text: "Target path to download :"
                color: Qt.lighter("yellow")
            }
            TextField {
                id: directory
                text: downloader.defaultDir()
                enabled: !downloader.loading
                font.pointSize: 12
                implicitWidth: 300
                placeholderText: qsTr("Enter target URL")
            }
        }

        Column {
            Label {
                font.pointSize: 12
                text: "File name:"
                color: Qt.lighter("yellow")
            }
            TextField {
                id: file
                text: downloader.defaultFile()
                enabled: !downloader.loading
                font.pointSize: 12
                implicitWidth: 300
                placeholderText: qsTr("Enter file name")
            }
        }

        Item {
            width: 300
            height: overwrite.height
            Label {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                font.pointSize: 12
                text: "Overwrite existing file"
                color: Qt.lighter("yellow")
            }

            Switch {
                id: overwrite
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onCheckedChanged: downloader.setOverwrite(checked)
            }
        }


        Column {
            visible: downloader.loading
            Label {
                font.pointSize: 12
                text: qsTr("%1\% Copied").arg(downloader.progress*100);
                color: Qt.lighter("yellow")
            }
            ProgressBar {
                implicitWidth: 300
                id: downloadProgress
                value: downloader.progress
            }
        }

        Row {
            width: 300
            spacing: 10
            layoutDirection: Qt.RightToLeft
            Button {
                visible: !downloader.loading
                enabled: cURL.length && directory.length && file.length
                text: "Start"
                onClicked: downloader.downloadFile()
            }
            Button {
                visible: downloader.loading
                text: "Cancel"
                onClicked: downloader.cancelDownload()
            }
            Button {
                visible: !downloader.loading
                text: "View"
            }
        }
    }
}
