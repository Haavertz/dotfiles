import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string glyph: ""
    property string tooltipText: ""
    property color foreground: "white"
    property color hoverForeground: foreground
    property real fontSize: 14
    property bool tightBounds: false
    readonly property bool hovered: pointer.hovered

    signal activated()

    implicitWidth: tightBounds ? Math.ceil(glyphLabel.paintedWidth) : 28
    implicitHeight: tightBounds ? Math.ceil(glyphLabel.paintedHeight) : 20
    width: implicitWidth
    height: implicitHeight

    Text {
        id: glyphLabel

        anchors.centerIn: parent
        text: root.glyph
        color: pointer.hovered ? root.hoverForeground : root.foreground
        font.family: "JetBrainsMono Nerd Font Mono"
        font.pixelSize: root.fontSize
        font.bold: true

        Behavior on color {
            ColorAnimation { duration: 180 }
        }
    }

    HoverHandler {
        id: pointer

        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: root.activated()
    }

    ToolTip.visible: pointer.hovered && tooltipText.length > 0
    ToolTip.text: tooltipText
    ToolTip.delay: 500
}
