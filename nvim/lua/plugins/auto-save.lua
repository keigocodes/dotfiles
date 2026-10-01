return {
  {
    "okuuva/auto-save.nvim",
    version = "*",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      debounce_delay = 2000,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      -- Skip unnamed / special buffers so we don't error on [No Name].
      condition = function(buf)
        if vim.bo[buf].buftype ~= "" then
          return false
        end
        if vim.api.nvim_buf_get_name(buf) == "" then
          return false
        end
        return true
      end,
      write_all_buffers = false,
      noautocmd = false,
    },
  },
}
