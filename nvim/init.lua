-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

pcall(vim.cmd, "colorscheme monokai-pro-classic")

-- Cursor blinking, added by Claude
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250"
vim.opt.wrap = true
