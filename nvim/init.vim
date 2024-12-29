call plug#begin('~/.config/nvim/plugged')
  Plug 'chaoren/vim-wordmotion'
  Plug 'farmergreg/vim-lastplace'
  Plug 'github/copilot.vim'
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
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'scrooloose/nerdtree'
  Plug 'sonph/onehalf', { 'rtp': 'vim' }
  Plug 'tomtom/tcomment_vim'
  " Automatically end certain structures (ruby blocks, etc)
  Plug 'tpope/vim-endwise'
  Plug 'vim-airline/vim-airline'
call plug#end()

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
set clipboard=unnamed

" Load .profile (-l) and .bashrc (-i)
set shell=bash\ -l

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
  return 'clear;'.a:cmd
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
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!target/*" --glob "!node_modules/" --glob "!tmp/" --glob "!__pycache__"'

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
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#install-extensions
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-flow',
  \ 'coc-pyright',
  \ 'coc-rls',
  \ 'coc-rust-analyzer',
\ ]

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Manually autoformat on save for pyton files
" https://github.com/fannheyward/coc-pyright/issues/229#issuecomment-754231643
aug python
  au!
  au BufWrite *.py call CocAction('format')
  au BufWritePre *.py silent! :call CocAction('runCommand', 'python.sortImports')
aug END

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
