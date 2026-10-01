-- Swap LazyVim's picker keymaps so lowercase = cwd, uppercase = root dir.
-- Default LazyVim convention is lowercase = root, uppercase = cwd; this inverts that.
return {
  {
    "folke/snacks.nvim",
    keys = {
      -- Files: swap ff/fF
      { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files (cwd)" },
      { "<leader>fF", function() Snacks.picker.files({ root = true, hidden = true }) end, desc = "Find Files (Root Dir)" },
      -- Space space: files in cwd instead of root
      { "<leader><space>", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files (cwd)" },
      -- Grep: swap sg/sG
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep (cwd)" },
      { "<leader>sG", function() Snacks.picker.grep({ root = true }) end, desc = "Grep (Root Dir)" },
      -- Word grep: swap sw/sW
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word (cwd)", mode = { "n", "x" } },
      { "<leader>sW", function() Snacks.picker.grep_word({ root = true }) end, desc = "Word (Root Dir)", mode = { "n", "x" } },
    },
  },
}
