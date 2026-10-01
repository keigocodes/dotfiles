return {
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    -- Toggled together with inlay hints via <leader>uh (see lua/config/keymaps.lua)
    opts = {
      vt_position = "above",
      references = { enabled = true, include_declaration = false },
      definition = { enabled = false },
      implementation = { enabled = true },
    },
  },
}
