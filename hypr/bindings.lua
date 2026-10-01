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
o.bind("SUPER + SHIFT + P", "Auto-Password", "sleep 0.2 && wtype 'nf7mhycjK!&6Qu4Q'")

-- Prefer the auto-email macro here; Quattro's default now puts the Email webapp on this key.
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Auto-Email", "sleep 0.2 && wtype 'keigohealy2028@u.northwestern.edu'")

-- Everything else from the old bindings.conf (Terminal, Tmux, File manager,
-- File manager (cwd), Browser (private), Music, Music TUI, Docker, Obsidian)
-- already matches Omarchy's current defaults one-for-one, so it's left alone.
