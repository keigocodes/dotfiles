return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  opts = {
    bind = true,
    hint_enable = true, -- virtual hint at end of line
    hint_prefix = "⟩ ",
    floating_window = true, -- show signature in floating window
    floating_window_above_cur_line = true,
    handler_opts = {
      border = "rounded",
    },
    -- auto-trigger when typing ( or ,
    toggle_key = "<C-k>", -- manually toggle if it gets in the way
  },
}
