import Quickshell
import Quickshell.Hyprland
import QtQuick

PanelWindow {
    id: root

    required property var theme
    property bool powerExpanded: powerHover.hovered

    anchors {
        top: true
        bottom: true
        left: true
    }

    margins {
        top: Math.max(6, Math.round(screen.height * 0.005))
        bottom: Math.max(6, Math.round(screen.height * 0.005))
        left: Math.max(6, Math.round(screen.width * 0.005))
    }

    implicitWidth: 34
    exclusionMode: ExclusionMode.Auto
    aboveWindows: true
    focusable: false
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: root.theme.background

        Item {
            id: topGroup

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 3
            }

            height: powerZone.height + workspaceList.height + 2

            Item {
                id: powerZone

                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                width: root.powerExpanded
                    ? Math.max(launcherButton.width, powerActions.implicitWidth)
                    : launcherButton.width
                height: launcherButton.height + (root.powerExpanded ? powerActions.implicitHeight : 0)
                clip: true

                Behavior on height {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                HoverHandler {
                    id: powerHover
                }

                ActionButton {
                    id: launcherButton

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }

                    glyph: "󰣇"
                    foreground: root.theme.foreground
                    hoverForeground: root.theme.mix(root.theme.background, root.theme.foreground, 0.05)
                    fontSize: 16
                    tightBounds: true
                    onActivated: Quickshell.execDetached(["rofi", "-show", "drun"])
                }

                Column {
                    id: powerActions

                    anchors {
                        top: launcherButton.bottom
                        horizontalCenter: parent.horizontalCenter
                    }

                    opacity: root.powerExpanded ? 1 : 0
                    enabled: root.powerExpanded
                    spacing: 0.5

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }

                    ActionButton {
                        glyph: ""
                        foreground: root.theme.foreground
                        hoverForeground: root.theme.mix(root.theme.background, root.theme.color6, 0.65)
                        onActivated: Quickshell.execDetached(["shutdown", "-h", "now"])
                    }

                    ActionButton {
                        glyph: ""
                        foreground: root.theme.foreground
                        hoverForeground: root.theme.mix(root.theme.background, root.theme.color6, 0.65)
                        onActivated: Quickshell.execDetached(["hyprlock"])
                    }

                    ActionButton {
                        glyph: ""
                        foreground: root.theme.foreground
                        hoverForeground: root.theme.mix(root.theme.background, root.theme.color6, 0.65)
                        onActivated: Quickshell.execDetached(["reboot"])
                    }

                    ActionButton {
                        glyph: ""
                        foreground: root.theme.foreground
                        hoverForeground: root.theme.mix(root.theme.background, root.theme.color6, 0.65)
                        onActivated: Quickshell.execDetached(["systemctl", "suspend"])
                    }

                    ActionButton {
                        glyph: ""
                        foreground: root.theme.foreground
                        hoverForeground: root.theme.mix(root.theme.background, root.theme.color6, 0.65)
                        onActivated: Hyprland.dispatch("exit")
                    }
                }
            }

            Column {
                id: workspaceList

                anchors {
                    top: powerZone.bottom
                    horizontalCenter: parent.horizontalCenter
                    topMargin: 2.5
                }

                spacing: 0

                Repeater {
                    model: ScriptModel {
                        values: [...Hyprland.workspaces.values]
                            .filter(workspace => workspace.id > 0)
                            .sort((first, second) => first.id - second.id)
                        objectProp: "id"
                    }

                    delegate: Item {
                        id: workspaceButton

                        required property var modelData

                        width: 28
                        height: 20

                        Text {
                            anchors.centerIn: parent
                            text: workspaceButton.modelData.focused ? "" : ""
                            color: workspacePointer.containsMouse
                                ? root.theme.mix(root.theme.foreground, root.theme.color2, 0.7)
                                : workspaceButton.modelData.focused
                                    ? root.theme.foreground
                                    : root.theme.mix(root.theme.foreground, root.theme.color0, 0.5)
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 14
                            font.bold: true

                            Behavior on color {
                                ColorAnimation { duration: 180 }
                            }
                        }

                        MouseArea {
                            id: workspacePointer

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: workspaceButton.modelData.activate()
                            onWheel: event => {
                                Hyprland.dispatch(event.angleDelta.y > 0 ? "workspace e-1" : "workspace e+1");
                                event.accepted = true;
                            }
                        }
                    }
                }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 0

            Repeater {
                model: ["˹", "ハ", "ー", "ヴ", "ェ", "ル", "ツ", "˼"]

                delegate: Text {
                    required property string modelData
                    required property int index

                    width: 24
                    horizontalAlignment: index === 0 ? Text.AlignLeft : index === 7 ? Text.AlignRight : Text.AlignHCenter
                    text: modelData
                    color: root.theme.foreground
                    font.family: "Iosevka"
                    font.pixelSize: 15
                    font.bold: true
                }
            }
        }

        Item {
            id: bottomGroup

            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                bottomMargin: 5
            }

            height: clockBackground.height

            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }

            Rectangle {
                id: clockBackground

                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                width: 28
                height: 48
                radius: 5
                color: root.theme.mix(root.theme.color0, root.theme.foreground, 0.95)

                Column {
                    anchors.centerIn: parent
                    spacing: -2

                    Text {
                        text: Qt.formatDateTime(clock.date, "HH")
                        color: root.theme.foreground
                        font.family: "Iosevka"
                        font.pixelSize: 15
                        font.bold: true
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "mm")
                        color: root.theme.foreground
                        font.family: "Iosevka"
                        font.pixelSize: 15
                        font.bold: true
                    }
                }
            }

        }
    }
}
