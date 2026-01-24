local autocmd = vim.api.nvim_create_autocmd

-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#vim-plug
require("nvim-treesitter.configs").setup {
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Custom foldtext to show first line and number of lines in fold
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/5643#issuecomment-2396525214
function _G.MyFoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  local count = vim.v.foldend - vim.v.foldstart + 1
  local sub = line:gsub("/%*|%*/|{{{%d=", "")
  return vim.v.folddashes .. sub .. " (" .. count .. " Lines)"
end

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "v:lua.MyFoldText()"

autocmd({ "BufReadPost", "FileReadPost" }, {
  pattern = "*",
  command = "normal zR",
})
