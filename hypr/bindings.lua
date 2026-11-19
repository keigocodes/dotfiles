-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- ---- Restored from the pre-Quattro bindings.conf ----

-- Spare shortcut for the browser (also on SUPER+SHIFT+B and SUPER+SHIFT+RETURN).
o.bind("SUPER + B", "Browser", "omarchy-launch-browser")

-- Prefer Editor here; Quattro's default now puts Browser on this key
-- (Browser stays reachable on SUPER+B and SUPER+SHIFT+B).
hl.unbind("SUPER + SHIFT + RETURN")
o.bind("SUPER + SHIFT + RETURN", "Editor", "omarchy-launch-editor")

-- Prefer Brown Noise here; Quattro's default now puts Editor on this key
-- (Editor now lives on SUPER+SHIFT+RETURN, above).
hl.unbind("SUPER + SHIFT + N")
o.bind("SUPER + SHIFT + N", "Brown Noise", "uwsm-app -- xdg-open /home/keigo/media/videos/brown_noise.m4a")

-- Prefer region screenshot here; Quattro's default now puts Google Maps on this key.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot (region)", "omarchy-capture-screenshot")

-- Prefer Claude here; Quattro's default now puts ChatGPT on this key.
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Claude", { webapp = "https://claude.ai/new" })

-- Prefer the auto-password macro here; Quattro's default now puts Google Photos on this key.
hl.unbind("SUPER + SHIFT + P")

-- Prefer the auto-email macro here; Quattro's default now puts the Email webapp on this key.
hl.unbind("SUPER + SHIFT + E")

-- Everything else from the old bindings.conf (Terminal, Tmux, File manager,
-- File manager (cwd), Browser (private), Music, Music TUI, Docker, Obsidian)
-- already matches Omarchy's current defaults one-for-one, so it's left alone.

-- Only workspaces 1-5 and 0 (10) are used; drop the Super+6..9 workspace keys.
for workspace = 6, 9 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
end

-- Prefer a much stronger night light; the default toggle hardcodes 4000K.
hl.unbind("SUPER + CTRL + N")
o.bind("SUPER + CTRL + N", "Toggle nightlight", "nightlight-toggle")
