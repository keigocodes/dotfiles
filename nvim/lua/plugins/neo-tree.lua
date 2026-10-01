return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    use_popups_for_input = false,
    window = {
      width = 30,
      mappings = {
        ["<cr>"] = "open",
        ["mp"] = "open_in_mpv",
      },
    },
    commands = {
      open_in_mpv = function(state)
        local node = state.tree:get_node()
        if node.type == "file" then
          vim.system({ "mpv", node.path }, { detach = true })
        end
      end,
    },
  },
  -- Swap so lowercase = cwd, uppercase = root dir (inverse of LazyVim default)
  keys = {
    { "<leader>fe", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer NeoTree (cwd)" },
    { "<leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() }) end, desc = "Explorer NeoTree (Root Dir)" },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (Root Dir)", remap = true },
  },
}
