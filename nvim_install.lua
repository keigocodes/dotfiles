-- Run inside a headless nvim (after the user config loads) to pre-install everything
-- LazyVim would otherwise fetch on first launch: plugins, Mason tools/LSP servers, treesitter parsers.
--   nvim --headless "+luafile nvim_install.lua"

local TIMEOUT = 30 * 60 * 1000
local failed = {}

local function log(msg)
  io.stdout:write(msg .. "\n")
end

-- 1. Plugins, pinned to lazy-lock.json
log("nvim: restoring plugins from lazy-lock.json")
require("lazy").restore({ wait = true, show = false })
require("lazy").load({
  plugins = { "mason.nvim", "mason-lspconfig.nvim", "nvim-lspconfig", "nvim-treesitter" },
  wait = true,
})

-- 2. Treesitter parsers
local parsers = LazyVim.opts("nvim-treesitter").ensure_installed or {}
log(("nvim: installing %d treesitter parsers"):format(#parsers))
local ok, err = require("nvim-treesitter").install(parsers):pwait(TIMEOUT)
if not ok then
  table.insert(failed, "treesitter: " .. tostring(err))
end

-- 3. Mason packages: LazyVim's tools plus the LSP servers it hands to mason-lspconfig.
-- mason-lspconfig skips ensure_installed in headless mode, so install them ourselves.
local mr = require("mason-registry")
local refreshed = false
mr.refresh(function()
  refreshed = true
end)
vim.wait(TIMEOUT, function()
  return refreshed
end, 200)

local to_package = require("mason-lspconfig").get_mappings().lspconfig_to_package
local wanted = vim.deepcopy(LazyVim.opts("mason.nvim").ensure_installed or {})
for _, server in ipairs(require("mason-lspconfig.settings").current.ensure_installed) do
  table.insert(wanted, to_package[server] or server)
end

-- LazyVim's mason config may already be installing some of these, so wait on all of them.
mr:on("package:install:failed", function(pkg)
  table.insert(failed, "mason: " .. pkg.name)
end)
local missing = {}
for _, name in ipairs(vim.fn.uniq(vim.fn.sort(wanted))) do
  local found, pkg = pcall(mr.get_package, name)
  if not found then
    table.insert(failed, "mason: unknown package " .. name)
  elseif not pkg:is_installed() then
    table.insert(missing, pkg)
  end
end

log(("nvim: installing %d Mason packages"):format(#missing))
for _, pkg in ipairs(missing) do
  if not pkg:is_installing() then
    pkg:install()
  end
end
vim.wait(TIMEOUT, function()
  for _, pkg in ipairs(missing) do
    if pkg:is_installing() then
      return false
    end
  end
  return true
end, 500)

if #failed > 0 then
  log("nvim: failed:\n  " .. table.concat(failed, "\n  "))
  vim.cmd("cquit 1")
end
log("nvim: done")
vim.cmd("qa!")
