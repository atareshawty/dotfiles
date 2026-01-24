local map = vim.keymap.set
local opts = { silent = true }

map("n", "<C-P>", ":Files<CR>", opts)
map("n", "<LocalLeader>t", ":Ttoggle<CR>", opts)
map("n", "<LocalLeader>nt", ":NERDTreeToggle<CR>", opts)

map("n", "<LocalLeader>*", ":keepjumps normal! #*<CR>", opts)
map("n", "<LocalLeader>#", ":keepjumps normal! *#<CR>", opts)
