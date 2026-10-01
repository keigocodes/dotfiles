-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Restored from the pre-Quattro input.conf. Note: "compse" was a typo for
-- "compose" in the old config, fixed here; altwin:swap_alt_win (Alt/Super
-- swapped) is kept exactly as configured.
hl.config({
  input = {
    kb_layout = "us",
    kb_options = "compose:ralt,altwin:swap_alt_win",

    -- Change speed of keyboard repeat.
    repeat_rate = 40,
    repeat_delay = 600,

    -- Start with numlock on by default.
    numlock_by_default = true,

    touchpad = {
      -- Control the speed of your scrolling.
      scroll_factor = 0.2,
    },
  },
})

-- App-specific touchpad scroll speeds.
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.5 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
