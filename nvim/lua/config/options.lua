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

-- c/cpp: 2-space indent, matching ~/.clang-format (BasedOnStyle: LLVM -> IndentWidth: 2, UseTab: Never)
-- so indentation while typing matches what clang-format produces on save.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
