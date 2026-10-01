-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Paste in visual mode without yanking the replaced text
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Send changes/x-deletes to the black-hole register so they don't touch the clipboard.
-- `d`/`D` yank normally (default vim behavior); use `<leader>c` when you want a "cut" with `c`/`C`.
for _, key in ipairs({ "c", "C", "x", "X" }) do
  vim.keymap.set({ "n", "x" }, key, '"_' .. key, { desc = key .. " without yanking" })
end
vim.keymap.set({ "n", "x" }, "<leader>c", "c", { desc = "Change (yank to register)" })

-- In insert mode, Ctrl+Right stops at end of line first; press again to cross to next line.
vim.keymap.set("i", "<C-Right>", function()
  if vim.fn.col(".") < vim.fn.col("$") then
    return "<End>"
  else
    return "<Right>"
  end
end, { expr = true, desc = "Ctrl-Right: end of line, then next line" })

-- Remap `w` to move backward by word (same as `b`); `e` keeps its default (forward to end of word).
-- Only mapped in normal/visual modes so operator-pending motions (dw, cw, yw) still behave normally.
vim.keymap.set({ "n", "x" }, "w", "b", { desc = "Move back a word (remapped from forward)" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf, desc = "LSP rename symbol" })
  end,
})

-- Stack symbol-usage ("N usages, N impls" virtual text) onto LazyVim's inlay hints
-- toggle, so <leader>uh turns both kinds of LSP virtual text on/off together.
vim.keymap.set("n", "<leader>uh", function()
  local hints = Snacks.toggle.inlay_hints()
  hints:toggle()
  local want = hints:get()
  local ok, symbol_usage = pcall(require, "symbol-usage")
  if ok and symbol_usage.toggle_globally() ~= want then
    symbol_usage.toggle_globally()
  end
end, { desc = "Toggle Inlay Hints + Symbol Usage" })

vim.keymap.set("n", "<leader>mp", function()
  vim.system({ "mpv", vim.fn.expand("%:p") }, { detach = true })
end, { desc = "Open file in mpv" })

