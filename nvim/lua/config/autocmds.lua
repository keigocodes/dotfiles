-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Restore :Lsp* user commands removed in nvim-lspconfig v2.
local cmd = vim.api.nvim_create_user_command

cmd("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "Show LSP client info" })

cmd("LspLog", function()
  vim.cmd.tabnew(vim.lsp.get_log_path())
end, { desc = "Open LSP log" })

cmd("LspStart", function(opts)
  if opts.args ~= "" then
    vim.lsp.enable(opts.args)
  else
    vim.cmd("edit")
  end
end, { nargs = "?", desc = "Start LSP client(s)" })

cmd("LspStop", function(opts)
  local clients
  if opts.args ~= "" then
    clients = vim.lsp.get_clients({ name = opts.args, bufnr = vim.api.nvim_get_current_buf() })
  else
    clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  end
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end
end, {
  nargs = "?",
  desc = "Stop LSP client(s) attached to current buffer",
  complete = function()
    return vim.tbl_map(function(c)
      return c.name
    end, vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
  end,
})

cmd("LspRestart", function(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = opts.args ~= "" and vim.lsp.get_clients({ name = opts.args, bufnr = bufnr })
    or vim.lsp.get_clients({ bufnr = bufnr })
  local names = {}
  for _, client in ipairs(clients) do
    names[client.name] = true
    vim.lsp.stop_client(client.id)
  end
  vim.defer_fn(function()
    for name in pairs(names) do
      vim.lsp.enable(name)
    end
    vim.cmd("edit")
  end, 200)
end, {
  nargs = "?",
  desc = "Restart LSP client(s) attached to current buffer",
  complete = function()
    return vim.tbl_map(function(c)
      return c.name
    end, vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
  end,
})

-- Disable diagnostics in markdown files (READMEs, etc.) — the squiggles get in the way of reading.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
