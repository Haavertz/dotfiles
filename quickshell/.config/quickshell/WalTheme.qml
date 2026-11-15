import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    readonly property var fallback: ({
        special: {
            background: "#0f0c1c",
            foreground: "#e1efef"
        },
        colors: {
            color0: "#0f0c1c",
            color2: "#5d61a0",
            color6: "#e0d7e2"
        }
    })

    readonly property var values: {
        if (!walFile.loaded)
            return fallback;

        try {
            const parsed = JSON.parse(walFile.text());
            if (!parsed.special || !parsed.colors)
                return fallback;
            return parsed;
        } catch (error) {
            return fallback;
        }
    }

    readonly property color background: values.special.background ?? fallback.special.background
    readonly property color foreground: values.special.foreground ?? fallback.special.foreground
    readonly property color color0: values.colors.color0 ?? fallback.colors.color0
    readonly property color color2: values.colors.color2 ?? fallback.colors.color2
    readonly property color color6: values.colors.color6 ?? fallback.colors.color6

    function mix(first: color, second: color, firstWeight: real): color {
        const weight = Math.max(0, Math.min(1, firstWeight));
        return Qt.rgba(
            first.r * weight + second.r * (1 - weight),
            first.g * weight + second.g * (1 - weight),
            first.b * weight + second.b * (1 - weight),
            first.a * weight + second.a * (1 - weight)
        );
    }

    property FileView walFile: FileView {
        path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
        preload: true
        watchChanges: true
        printErrors: false

        onFileChanged: reload()
    }
}
