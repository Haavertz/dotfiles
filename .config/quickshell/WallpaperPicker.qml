import Quickshell
import Qt.labs.folderlistmodel
import QtQuick

PanelWindow {
    id: root

    required property var theme
    signal closeRequested()

    readonly property string homeDirectory: Quickshell.env("HOME")
    readonly property url wallpaperDirectory: "file://" + homeDirectory + "/wallpapers"

    function previewUrl(fileName: string): url {
        return wallpaperDirectory + "/preview-" + fileName;
    }

    function refreshWallpapers(): void {
        wallpaperModel.folder = "";
        reloadTimer.restart();
    }

    anchors {
        top: true
        bottom: true
        left: true
    }

    margins {
        top: 10
        bottom: 10
        left: 52
    }

    implicitWidth: 310
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: false
    color: "transparent"

    onVisibleChanged: {
        if (visible)
            refreshWallpapers();
    }

    FolderListModel {
        id: wallpaperModel

        folder: root.wallpaperDirectory
        nameFilters: ["*.jpg", "*.JPG", "*.jpeg", "*.JPEG", "*.png", "*.PNG", "*.webp", "*.WEBP"]
        showDirs: false
        showDotAndDotDot: false
        showHidden: false
        sortField: FolderListModel.Name
    }

    Timer {
        id: reloadTimer

        interval: 1
        onTriggered: wallpaperModel.folder = root.wallpaperDirectory
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: root.refreshWallpapers()
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: root.theme.background

        ListView {
            id: wallpaperList

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                topMargin: 8
                bottomMargin: 8
                leftMargin: 8
                rightMargin: 8
            }

            model: wallpaperModel
            spacing: 4
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Item {
                id: wallpaperDelegate

                required property string fileName
                required property url fileUrl

                property bool previewFailed: false

                width: ListView.view.width
                height: fileName.startsWith("preview-") ? 0 : 190
                visible: height > 0

                Rectangle {
                    anchors {
                        fill: parent
                        margins: 4
                    }

                    radius: 6
                    color: root.theme.mix(root.theme.color0, root.theme.foreground, 0.95)
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: wallpaperDelegate.fileName.startsWith("preview-")
                            ? ""
                            : wallpaperDelegate.previewFailed
                                ? wallpaperDelegate.fileUrl
                                : root.previewUrl(wallpaperDelegate.fileName)
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: true

                        onStatusChanged: {
                            if (status === Image.Error && !wallpaperDelegate.previewFailed)
                                wallpaperDelegate.previewFailed = true;
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached([
                                Quickshell.shellPath("scripts/change-wallpaper.sh"),
                                wallpaperDelegate.fileName
                            ]);
                            root.closeRequested();
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                visible: wallpaperModel.status === FolderListModel.Ready && wallpaperModel.count === 0
                text: "Nenhum wallpaper encontrado"
                color: root.theme.foreground
                font.family: "Iosevka"
                font.pixelSize: 13
            }
        }
    }
}
