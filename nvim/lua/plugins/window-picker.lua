return {
  "s1n7ax/nvim-window-picker",
  version = "*",
  opts = {
    hint = "floating-big-letter",
    filter_rules = {
      autoselect_one = true,
      include_current_win = false,
      bo = {
        filetype = { "neo-tree", "neo-tree-popup", "notify" },
        buftype = { "terminal", "quickfix" },
      },
    },
  },
}
