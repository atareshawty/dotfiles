-- =========================================================
-- Bootstrap lazy.nvim if not installed
-- =========================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================================================
-- Plugin Setup with lazy.nvim
-- =========================================================
require("lazy").setup({
  -- Core utilities
  { "chaoren/vim-wordmotion" },
  { "farmergreg/vim-lastplace" },
  { "github/copilot.vim" },
  { "hashivim/vim-terraform" },
  { "janko-m/vim-test" },
  { "jlanzarotta/bufexplorer" },
  { "jtratner/vim-flavored-markdown" },

  -- FZF
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
  { "junegunn/fzf.vim" },

  { "kassio/neoterm" },

  -- Colorschemes
  { "navarasu/onedark.nvim" },
  { "sonph/onehalf", rtp = "vim" },

  { "nathangrigg/vim-beancount" },
  { "neoclide/coc.nvim", branch = "release" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- UI & Editing
  { "preservim/nerdtree" },
  { "tomtom/tcomment_vim" },
  { "tpope/vim-endwise" },
  { "vim-airline/vim-airline" },
})

-- =========================================================
-- General Settings
-- =========================================================
local opt = vim.opt

opt.dir = '/tmp//'
opt.hidden = true
opt.ignorecase = true
opt.mouse = ''
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
opt.clipboard = 'unnamed'
opt.shell = 'bash -l'
opt.cursorline = true
opt.termguicolors = true
vim.cmd('syntax on')

-- =========================================================
-- Autocommands
-- =========================================================
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.md', '*.markdown'},
  command = 'setlocal filetype=ghmarkdown'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '*.txt',
  command = 'setlocal spell spelllang=en_us'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = 'COMMIT_EDITMSG',
  command = 'setlocal spell'
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '*grep*',
  command = 'cwindow'
})

-- Highlight trailing whitespace
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  command = 'match ExtraWhitespace /\\s\\+\\%#\\@<!$/'
})
vim.api.nvim_create_autocmd({'BufRead', 'InsertLeave'}, {
  pattern = '*',
  command = 'match ExtraWhitespace /\\s\\+$/'
})
vim.cmd [[
  highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
]]

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'javascript', 'ruby'},
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = 0,
      command = [[:%s/\s\+$//e]]
    })
  end
})

-- =========================================================
-- Helper Functions
-- =========================================================
function _G.ClearTerminalTransform(cmd)
  return 'clear;' .. cmd
end

function _G.SourceIfExists(file)
  local expanded = vim.fn.expand(file)
  if vim.fn.filereadable(expanded) == 1 then
    vim.cmd('source ' .. expanded)
  end
end

-- =========================================================
-- Keymaps
-- =========================================================
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

map('n', '<C-P>', ':Files<CR>', opts)
map('n', '<LocalLeader>t', ':Ttoggle<CR>', opts)
map('n', '<LocalLeader>nt', ':NERDTreeToggle<CR>', opts)
map('n', '<LocalLeader>rb', ':wa | :TestFile<CR>', opts)
map('n', '<LocalLeader>rf', ':wa | :TestNearest<CR>', opts)
map('n', '<LocalLeader>rl', ':wa | :TestLast<CR>', opts)
map('n', '<LocalLeader>p', ':Files<CR>', opts)
map('n', '<LocalLeader>*', ':keepjumps normal! #*<CR>', opts)
map('n', '<LocalLeader>#', ':keepjumps normal! *#<CR>', opts)

-- =========================================================
-- Plugin Config
-- =========================================================
vim.g.neoterm_size = 20
vim.g["test#custom_transformations"] = { clear = 'v:lua.ClearTerminalTransform' }
vim.g["test#transformation"] = 'clear'
vim.g["test#strategy"] = 'neoterm'
vim.g.neoterm_default_mod = 'rightbelow'

vim.g.wordmotion_prefix = '<LocalLeader>'
vim.g.wordmotion_mappings = { b = '<LocalLeader>bb' }
vim.g.tagbar_sort = 0
vim.g.airline_theme = 'onehalfdark'
vim.g.onedark_config = { style = 'light' }
vim.cmd('colorscheme onedark')

-- =========================================================
-- NerdTree auto-quit
-- =========================================================
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.b.NERDTreeType == 'primary' then
      vim.cmd('q')
    end
  end
})

-- =========================================================
-- FZF
-- =========================================================
vim.env.FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!target/*" --glob "!node_modules/" --glob "!tmp/" --glob "!__pycache__"'

-- =========================================================
-- COC Config
-- =========================================================
function _G.CheckBackspace()
  local col = vim.fn.col('.') - 1
  return col <= 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

map('i', '<Tab>',
  [[coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? "\<Tab>" : coc#refresh()]],
  {expr = true, silent = true}
)

function _G.ShowDocumentation()
  if vim.tbl_contains({'vim', 'help'}, vim.bo.filetype) then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  else
    vim.fn.CocAction('doHover')
  end
end
map('n', 'K', ':lua ShowDocumentation()<CR>', opts)

vim.g.coc_global_extensions = {
  'coc-tsserver',
  'coc-flow',
  'coc-pyright',
  'coc-rls',
  'coc-rust-analyzer',
}

map('n', 'gd', '<Plug>(coc-definition)', opts)
map('n', 'gy', '<Plug>(coc-type-definition)', opts)
map('n', 'gi', '<Plug>(coc-implementation)', opts)
map('n', 'gr', '<Plug>(coc-references)', opts)

-- Format & sort imports on save (Python)
local py_group = vim.api.nvim_create_augroup('python', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = py_group,
  pattern = '*.py',
  callback = function()
    vim.fn.CocAction('runCommand', 'python.sortImports')
  end
})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = py_group,
  pattern = '*.py',
  callback = function()
    vim.fn.CocAction('format')
  end
})

-- =========================================================
-- Treesitter
-- =========================================================
require('nvim-treesitter.configs').setup {
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
}

-- =========================================================
-- Folding
-- =========================================================
function _G.MyFoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  local numLines = 1 + vim.v.foldend - vim.v.foldstart
  local sub = line:gsub('/%*', ''):gsub('%*/', ''):gsub('{{{%d*', '')
  return string.rep('-', vim.v.foldlevel) .. sub .. ' (' .. numLines .. ' Lines)'
end

vim.cmd [[
  filetype plugin indent on
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  set foldtext=v:lua.MyFoldText()
  autocmd BufReadPost,FileReadPost * normal! zR
]]

function _G.OnSpace()
  if vim.fn.foldlevel('.') > 0 then
    if vim.fn.foldclosed('.') ~= -1 then
      return 'zO'
    else
      return 'za'
    end
  else
    return ' '
  end
end

map('n', '<Space>', '@=(v:lua.OnSpace())<CR>', { expr = true, silent = true })
