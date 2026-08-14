//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: shell

    property bool wallpaperVisible: false

    WalTheme {
        id: shellTheme
    }

    IpcHandler {
        target: "wallpaper"

        function show(): void {
            shell.wallpaperVisible = true;
        }

        function hide(): void {
            shell.wallpaperVisible = false;
        }

        function toggle(): void {
            shell.wallpaperVisible = !shell.wallpaperVisible;
        }

        function status(): bool {
            return shell.wallpaperVisible;
        }
    }

    Variants {
        model: Quickshell.screens.length > 0 ? [Quickshell.screens[0]] : []

        delegate: Component {
            SideBar {
                required property var modelData

                screen: modelData
                theme: shellTheme
            }
        }
    }

    Variants {
        model: Quickshell.screens.length > 0 ? [Quickshell.screens[0]] : []

        delegate: Component {
            WallpaperPicker {
                required property var modelData

                screen: modelData
                theme: shellTheme
                visible: shell.wallpaperVisible
                onCloseRequested: shell.wallpaperVisible = false
            }
        }
    }
}
