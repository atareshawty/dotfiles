local opts = { silent = true }
local map = vim.keymap.set

vim.g.coc_global_extensions = {
  "coc-flow",
  "coc-pyright",
  "coc-rls",
  "coc-rust-analyzer",
  "coc-tsserver",
}

-- Use <tab> for trigger completion with characters ahead and navigate
function _G.CheckBackspace()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match("%s")
end

vim.keymap.set("i", "<Tab>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn
  elseif CheckBackspace() then
    return "<Tab>"
  else
    return vim.fn["coc#refresh"]()
  end
end, { silent = true, expr = true })

-- Hover and Shift-K to show documentation of current hover target
map("n", "K", function()
  if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  else
    vim.fn.CocAction("doHover")
  end
end, opts)

-- GoTo code navigation
map("n", "gd", "<Plug>(coc-definition)", opts)
map("n", "gy", "<Plug>(coc-type-definition)", opts)
map("n", "gi", "<Plug>(coc-implementation)", opts)
map("n", "gr", "<Plug>(coc-references)", opts)
