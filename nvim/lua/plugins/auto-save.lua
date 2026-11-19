return {
  {
    "okuuva/auto-save.nvim",
    enabled = false,
    version = "*",
    event = { "InsertLeave", "TextChanged" },
    -- Don't let auto-saves trigger LazyVim's format-on-save; manual :w still formats.
    init = function()
      local group = vim.api.nvim_create_augroup("autosave_no_format", { clear = true })
      local prev = {}
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "AutoSaveWritePre",
        callback = function(args)
          local buf = args.data.saved_buffer
          prev[buf] = vim.b[buf].autoformat
          vim.b[buf].autoformat = false
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "AutoSaveWritePost",
        callback = function(args)
          local buf = args.data.saved_buffer
          if vim.api.nvim_buf_is_valid(buf) then
            vim.b[buf].autoformat = prev[buf]
          end
          prev[buf] = nil
        end,
      })
    end,
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
