-- window
hl.config({
   general = {
       gaps_in = 4,
       gaps_out = 12,
       border_size = 1,
       col = {
            active_border   = "rgb(fafafa)",
            inactive_border = "rgba(595959aa)",
       },
       resize_on_border = false,
       allow_tearing = false,
       layout = "dwindle",
   },

   decoration = {
      rounding       = 0,
      rounding_power = 2,

      active_opacity     = 1.0,
      inactive_opacity   = 1.0,
      fullscreen_opacity = 1.0,

      dim_inactive = false,
      dim_strength = 0.5,

      blur = {
         enabled           = true,
         size              = 4,
         passes            = 1,
         vibrancy          = 0.1696,
         vibrancy_darkness = 0.0,
         contrast          = 0.8916,
         brightness        = 1.0,
         noise             = 0.0117,
         ignore_opacity    = true,
         new_optimizations = true,
         xray              = false,
         popups            = false,
         special           = false,
      },

      shadow = {
         enabled      = false,
         range        = 4,
         render_power = 3,
         sharp        = false,
         color        = 0xee1a1a1a,
         offset       = "0 0",
         scale        = 1.0,
      },
   },

   -- antigo (aesthetics.conf)
   -- decoration = {
   --    rounding = 14,
   --
   --    -- Change transparency of focused and unfocused windows
   --    active_opacity   = 1.0,
   --    inactive_opacity = 0.96,
   --
   --    blur = {
   --       enabled        = false,
   --       vibrancy       = 0.8,
   --       contrast       = 0.6,
   --       size           = 8,
   --       passes         = 2,
   --       ignore_opacity = false,
   --    },
   --
   --    shadow = {
   --       enabled = false,
   --       sharp   = false,
   --    },
   -- },

   animations = {
      enabled = true,
   },

   dwindle = {
      preserve_split = true, 
   },
})

-- animations
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.8}, {0.1, 1} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 6, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 90%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slidevert" })
