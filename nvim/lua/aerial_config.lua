require("aerial").setup({
  backends = { "lsp", "treesitter" },

  layout = {
    max_width = { 40, 0.2 },
    min_width = 20,
  },

  -- Keymaps in the aerial window
  keymaps = {
    ["?"] = "actions.show_help",
    ["<CR>"] = "actions.jump",
    ["q"] = "actions.close",
  },
})

vim.keymap.set("n", "<LocalLeader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle aerial" })
vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "Previous aerial symbol" })
vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "Next aerial symbol" })
