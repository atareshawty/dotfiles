local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.md", "*.markdown" },
  command = "setlocal filetype=ghmarkdown",
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.txt",
  command = "setlocal spell spelllang=en_us",
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "COMMIT_EDITMSG",
  command = "setlocal spell",
})

autocmd("QuickFixCmdPost", {
  pattern = "*grep*",
  command = "cwindow",
})

-- Highlight trailing whitespace
vim.cmd([[
  highlight ExtraWhitespace ctermbg=red guibg=red
]])

autocmd("InsertEnter", {
  pattern = "*",
  command = [[match ExtraWhitespace /\s\+\%#\@<!$/]],
})

autocmd({ "BufRead", "InsertLeave" }, {
  pattern = "*",
  command = [[match ExtraWhitespace /\s\+$/]],
})

autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight ExtraWhitespace ctermbg=red guibg=red",
})

-- Trim trailing whitespace on save
local trim_group = augroup("TrimTrailingWhitespace", { clear = true })

autocmd("BufWritePre", {
  group = trim_group,
  pattern = "*",
  callback = function()
    local skip = { markdown = true, gitcommit = true, [""] = true }
    if skip[vim.bo.filetype] then return end

    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})
