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
        spacing: 20

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
            color: "#0FFFFFFF"
        }

        Column {
            Label {
                font.pointSize: 12
                text: "Source path to download :"
            }
            TextField {
                id: cURL
                font.pointSize: 12
                implicitWidth: 300
                placeholderText: qsTr("Enter source URL")
            }
        }

        Column {
            Label {
                font.pointSize: 12
                text: "Target path to download :"
            }
            TextField {
                id: directory
                font.pointSize: 12
                implicitWidth: 300
                placeholderText: qsTr("Enter target URL")
            }
        }

        Column {
            Label {
                font.pointSize: 12
                text: "File name..."
            }
            TextField {
                id: file
                font.pointSize: 12
                implicitWidth: 300
                placeholderText: qsTr("Enter file name")
            }
        }


        Column {
            visible: downloader.loading
            Label {
                text: qsTr("%1\% Copied").arg(downloader.progress*100);
            }
            ProgressBar {
                implicitWidth: 300
                id: downloadProgress
                value: downloader.progress + 0.2
            }
        }
        Row {
            width: 300
            spacing: 10
            layoutDirection: Qt.RightToLeft
            Button {
                visible: !downloader.loading
                enabled: cURL.length
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
