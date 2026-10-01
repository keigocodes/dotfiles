return {
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              paths = vim.fn.expand("%"),
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace (current file)",
      },
      {
        "<leader>sR",
        function()
          require("grug-far").open({ transient = true })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace (project)",
      },
    },
  },
}
