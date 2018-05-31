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
            color: "moccasin"
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
                color: "moccasin"
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
                color: "moccasin"
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
                color: "moccasin"
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
                color: "moccasin"
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
            spacing: 5
            Label {
                width: 300
                font.pointSize: 12
                text: qsTr("%1\% Copied").arg(Math.floor(downloader.progress*100));
                color: "moccasin"
                horizontalAlignment: Text.AlignHCenter
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
        }
    }

    Popup {
        id: messageBox
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 320
        height: 240
        modal: true
        focus: true
        closePolicy: Popup.OnEscape | Popup.OnPressOutside
        padding: 20
        Item {
            anchors.fill: parent
            Column {
                anchors.fill: parent
                spacing: 10
                Label {
                    id: msgTitle
                    width: msgBoxSeparator.width
                    wrapMode: Text.WrapAnywhere
                    font.pointSize: 16
                    color: "tomato"
                    font.bold: true
                    horizontalAlignment: TextInput.AlignHCenter
                }
                Rectangle {
                    id: msgBoxSeparator
                    height: 2
                    width: messageBox.width - messageBox.leftPadding * 2
                    color: "#0FFFFFFF"
                }
                Label {
                    id: msgDetail
                    width: msgBoxSeparator.width
                    wrapMode: Text.WordWrap
                    font.pointSize: 12
                    color: "tomato"
                    font.bold: true
                }
            }
        }
    }

    function showMsg(title, detail)
    {
        console.log(title, detail);
        msgTitle.text = title;
        msgDetail.text = detail;
        messageBox.open();
    }

    function setDetail(detail)
    {
        console.log(detail);
    }

    Component.onCompleted: {
        downloader.sendMsg.connect(showMsg);
        downloader.sendDetail.connect(setDetail);
    }
}
