------------
-- LOCALS --
------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn
local map = vim.keymap.set
local opt = vim.opt
local opts = { silent = true }

------------------
-- DEPENDENCIES --
------------------
fn['plug#begin']('~/.config/nvim/plugged')

fn['plug#']('chaoren/vim-wordmotion')
fn['plug#']('farmergreg/vim-lastplace')
fn['plug#']('github/copilot.vim')
fn['plug#']('hashivim/vim-terraform')
fn['plug#']('janko-m/vim-test')
fn['plug#']('jlanzarotta/bufexplorer')
fn['plug#']('jtratner/vim-flavored-markdown')
fn['plug#']('junegunn/fzf', { ['do'] = fn['fzf#install'] })
fn['plug#']('junegunn/fzf.vim')
fn['plug#']('kassio/neoterm')

-- Colors
fn['plug#']('navarasu/onedark.nvim')

fn['plug#']('nathangrigg/vim-beancount')
fn['plug#']('neoclide/coc.nvim', { branch = 'release' })
fn['plug#']('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
fn['plug#']('scrooloose/nerdtree')
fn['plug#']('sonph/onehalf', { rtp = 'vim' })
fn['plug#']('tomtom/tcomment_vim')
-- Automatically end certain structures (ruby blocks, etc)
fn['plug#']('tpope/vim-endwise')
fn['plug#']('vim-airline/vim-airline')

fn['plug#end']()

----------------------
-- GENERAL SETTINGS --
----------------------
opt.dir = "/tmp//"
opt.hidden = true
opt.ignorecase = true
opt.mouse = ""
opt.number = true
opt.ruler = true
opt.showmatch = true
opt.smartcase = true

opt.textwidth = 0
opt.smartindent = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

opt.undofile = true
opt.clipboard = "unnamed"
opt.shell = "bash -l"

opt.cursorline = true
opt.termguicolors = true


------------------
-- AUTOCOMMANDS --
------------------
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

---------------
-- FUNCTIONS --
---------------
function _G.ClearTerminalTransform(cmd)
  return "clear;" .. cmd
end


------------------
-- KEY MAPPINGS --
------------------
map("n", "<C-P>", ":Files<CR>", opts)
map("n", "<LocalLeader>t", ":Ttoggle<CR>", opts)
map("n", "<LocalLeader>nt", ":NERDTreeToggle<CR>", opts)

map("n", "<LocalLeader>rb", ":wa | :TestFile<CR>", opts)
map("n", "<LocalLeader>rf", ":wa | :TestNearest<CR>", opts)
map("n", "<LocalLeader>rl", ":wa | :TestLast<CR>", opts)

map("n", "<LocalLeader>*", ":keepjumps normal! #*<CR>", opts)
map("n", "<LocalLeader>#", ":keepjumps normal! *#<CR>", opts)

---------------------
-- PLUGIN SETTINGS --
---------------------
vim.g.neoterm_size = 20
vim.g.test_custom_transformations = { clear = "ClearTerminalTransform" }
vim.g.test_transformation = "clear"
vim.g.test_strategy = "neoterm"
vim.g.neoterm_default_mod = "rightbelow"

vim.g.wordmotion_prefix = "<LocalLeader>"
vim.g.wordmotion_mappings = { b = "<LocalLeader>bb" }

vim.g.tagbar_sort = 0

------------------
-- COLOR SCHEME --
------------------
vim.cmd("syntax on")
vim.g.airline_theme = "onehalfdark"

vim.g.onedark_config = {
  style = "light",
}

vim.cmd("colorscheme onedark")

---------------
-- NERD TREE --
---------------

-- Exit Nvim if NERDTree is the only window remaining
autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.winnr("$") == 1
      and vim.b.NERDTreeType == "primary" then
      vim.cmd("q")
    end
  end,
})

---------
-- FZF --
---------
vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --follow"

---------
-- COC --
---------
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

------------
-- PYTHON --
------------
local py_group = augroup("python", { clear = true })

-- Manually autoformat on save for pyton files
autocmd("BufWrite", {
  group = py_group,
  pattern = "*.py",
  command = "call CocAction('format')",
})

autocmd("BufWritePre", {
  group = py_group,
  pattern = "*.py",
  command = "silent! call CocAction('runCommand', 'python.sortImports')",
})

----------------
-- TREESITTER --
----------------
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

-- Space toggles fold
function _G.OnSpace()
  if vim.fn.foldlevel('.') > 0 then
    if vim.fn.foldclosed('.') ~= -1 then
      return "zO"
    else
      return "za"
    end
  end
  return " "
end

map("n", "<Space>", "v:lua.OnSpace()", { silent = true, expr = true })
