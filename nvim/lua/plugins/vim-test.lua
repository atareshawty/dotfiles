local map = vim.keymap.set
local opts = { silent = true }

function _G.ClearTerminalTransform(cmd)
  return "clear;" .. cmd
end

vim.g.test_custom_transformations = { clear = "ClearTerminalTransform" }
vim.g.test_transformation = "clear"
vim.g.test_strategy = "neoterm"

map("n", "<LocalLeader>rb", ":wa | :TestFile<CR>", opts)
map("n", "<LocalLeader>rf", ":wa | :TestNearest<CR>", opts)
map("n", "<LocalLeader>rl", ":wa | :TestLast<CR>", opts)
