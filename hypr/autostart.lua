-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Notify on every clipboard change (restores the old pre-Quattro behavior).
-- Fires for any copy, from any app -- including the screenshot/OCR/QR tools,
-- which already show their own "Copied..." toast, so those briefly double up.
o.exec_on_start("wl-paste --watch omarchy-notification-send -g 󰅍 'Copied to clipboard'")
