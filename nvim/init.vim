call plug#begin('~/.config/nvim/plugged')
  Plug 'chaoren/vim-wordmotion'
  Plug 'farmergreg/vim-lastplace'
  Plug 'github/copilot.vim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'CopilotC-Nvim/CoPilotChat.nvim'
  Plug 'hashivim/vim-terraform'
  Plug 'janko-m/vim-test'
  Plug 'jlanzarotta/bufexplorer'
  Plug 'jtratner/vim-flavored-markdown'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'kassio/neoterm'
  " ColorScheme
  Plug 'navarasu/onedark.nvim'
  Plug 'nathangrigg/vim-beancount'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neovim/nvim-lspconfig', {'tag': 'v2.5.0'}
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'MeanderingProgrammer/render-markdown.nvim'
  Plug 'scrooloose/nerdtree'
  Plug 'stevearc/aerial.nvim', {'branch': 'nvim-0.9'}
  Plug 'sonph/onehalf', { 'rtp': 'vim' }
  Plug 'tadachs/ros-nvim'
  Plug 'tomtom/tcomment_vim'
  " Automatically end certain structures (ruby blocks, etc)
  Plug 'tpope/vim-endwise'
  Plug 'vim-airline/vim-airline'
call plug#end()

set autoread
set dir=/tmp//
set hidden
set ignorecase
set mouse=
set number
set ruler
set showmatch
set smartcase
set textwidth=0 nosmartindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set undofile
set clipboard=unnamedplus

lua << EOF
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
EOF

" Load .profile (-l) and .bashrc (-i)
set shell=bash\ -l

autocmd FocusGained,BufEnter * checktime

autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal spell

autocmd QuickFixCmdPost *grep* cwindow

" trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd FileType javascript autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd FileType ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

function! ClearTerminalTransform(cmd) abort
  let l:match = matchlist(a:cmd, '\vapplications/([^/]+)/')
  if !empty(l:match) && a:cmd =~# 'pytest'
    let l:app_dir = 'applications/' . l:match[1]
    let l:new_cmd = substitute(a:cmd, '\V' . l:app_dir . '/', '', 'g')
    return 'clear;(cd ' . l:app_dir . ' && ' . l:new_cmd . ')'
  endif
  return 'clear;' . a:cmd
endfunction

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

nmap <silent> <C-P> :Files<CR>
nmap <silent> <LocalLeader>t :Ttoggle<CR>
nmap <silent> <LocalLeader>nt :NERDTreeToggle<CR>
nmap <silent> <LocalLeader>rb :wa <bar> :TestFile<CR>
nmap <silent> <LocalLeader>rf :wa <bar> :TestNearest<CR>
nmap <silent> <LocalLeader>rl :wa <bar> :TestLast<CR>
nmap <silent> <LocalLeader>p :Files<CR>
nnoremap <LocalLeader>* :keepjumps normal! #*<CR>
nnoremap <LocalLeader># :keepjumps normal! *#<CR>

let g:neoterm_size = '20'
let g:test#custom_transformations = {'clear': function('ClearTerminalTransform')}
let g:test#transformation = 'clear'
let g:test#strategy = 'neoterm'
let g:neoterm_default_mod = 'rightbelow'
let g:test#python#pytest#executable = 'source .venv/bin/activate && pytest'
let g:test#python#pytest#options = '--no-cov -p no:warnings'

let g:wordmotion_prefix = '<LocalLeader>'
let g:wordmotion_mappings = {
\ 'b' : '<LocalLeader>bb',
\ }

" Sort tags in order of appearance by default
let g:tagbar_sort = 0

" ### Syntax Highlighting ###
syntax on
set t_Co=256
set cursorline
let g:airline_theme='onehalfdark'
let g:onedark_config = {
    \ 'style': 'light',
\}
colorscheme onedark

" ### NerdTree ###

" Exit vim when only nerd tree is in buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" faster fzf fuzzy find respecting gitignore
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!target/*" --glob "!node_modules/" --glob "!tmp/" --glob "!__pycache__" --glob "!.venv/*" --glob "!**/.venv/**" --glob "!devel/**" --glob "!.cache/**" --glob "!build/**" --glob "!logs/**" --glob "!docs/_build/**" --glob "!docs/packages/**" --glob "!devel/"'

" ###### COC ######
" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Hover and Shift-K to show documentation of current hover target
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" function! s:show_documentation()
"   if (index(['vim', 'help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#install-extensions
let g:coc_global_extensions = [
  \ 'coc-tsserver',
\ ]

" Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>

" Manually autoformat on save for pyton files
" https://github.com/fannheyward/coc-pyright/issues/229#issuecomment-754231643
" aug python
"   au!
"   au BufWrite *.py call CocAction('runCommand', 'ruff.executeAutofix')
" "  au BufWritePre *.py silent! :call CocAction('runCommand', 'python.sortImports')
" aug END

augroup python
  autocmd!
  autocmd BufWritePre *.py lua vim.lsp.buf.code_action({
        \ context = { only = { "source.fixAll.ruff" } },
        \ apply = true,
        \ })
augroup END

augroup cpp
  autocmd!
  autocmd BufWritePre *.cpp,*.cc,*.cxx,*.c,*.h,*.hpp,*.hxx lua vim.lsp.buf.format({ async = false })
augroup END

" This makes the time before it updates your hover faster
" set updatetime=300
" This makes it so that you can click a variable and a float window pops up
" autocmd CursorHold * silent call CocActionAsync('doHover')

" Treesitter: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#vim-plug
lua << EOF
require'nvim-treesitter.configs'.setup {
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Make treesitter use the markdown parser for the ghmarkdown filetype
-- (set by the *.md autocmd above) so render-markdown.nvim can attach.
vim.treesitter.language.register('markdown', 'ghmarkdown')

require('render-markdown').setup({
  file_types = { 'markdown', 'ghmarkdown' },
})
EOF

" Custom foldtext to show first line and number of lines in fold
" https://github.com/nvim-treesitter/nvim-treesitter/issues/5643#issuecomment-2396525214
function! MyFoldText()
    let line = getline(v:foldstart)
    let numberOfLines = 1 + v:foldend - v:foldstart
    let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    return v:folddashes .. sub .. ' (' .. numberOfLines .. ' Lines)'
endfunction

filetype plugin indent on
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set foldtext=nvim_treesitter#foldtext()
set foldtext=MyFoldText()
autocmd BufReadPost,FileReadPost * normal zR

function! OnSpace()
    if foldlevel('.')
        if foldclosed('.') != -1
            return 'zO'
        else
            return 'za'
        endif
    else
        return "\<Space>"
    endif
endfunction

nnoremap <silent> <Space> @=(OnSpace())<CR>

"lua << EOF
"require("CopilotChat").setup()
"EOF

lua require('lsp.ty')
lua require('lsp.ruff')
lua require('lsp.clangd')
lua require('aerial_config')
