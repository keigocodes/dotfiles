require("config.remote_clipboard").setup()
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.winbar = "%=%m %f"
vim.opt.updatetime = 300 -- hover popup delay (ms)
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20"

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
  },
})

-- cpp: real tabs, width 4, matching .clang-format (UseTab: ForIndentation, TabWidth: 4)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
