local p = require("conf.programs")
local mod = "SUPER"

hl.bind(mod .. " + Q", hl.dsp.exec_cmd(p.terminal))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(p.filemanager))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(p.browser))
hl.bind(mod .. " + A", hl.dsp.exec_cmd(p.quickshell_reload))
hl.bind(mod .. " + L", hl.dsp.exec_cmd(p.lock))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd(p.wallpaper))

hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())

-- worskpace
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- master worskpace
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- modify window
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
