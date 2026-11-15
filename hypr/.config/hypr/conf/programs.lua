local M = {}

M.terminal = "kitty"
M.browser = "firefox"
M.filemanager = "nautilus --new-window"
M.lock = "hyprlock"
M.quickshell_reload = "qs -p $HOME/.config/quickshell kill; sleep 1; qs -p $HOME/.config/quickshell -n -d"
M.wallpaper = "sh $HOME/scripts/select_wallpaper.sh"

return M
