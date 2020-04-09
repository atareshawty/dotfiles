call plug#begin('~/.config/nvim/plugged')
  " Changes the definition of a word for better navigation
  Plug 'chaoren/vim-wordmotion'
  " Reopens file to last edit position
  Plug 'farmergreg/vim-lastplace', {'tag': 'v3.2.1'}
  Plug 'janko-m/vim-test', {'commit': '8300ee6'}
  Plug 'jlanzarotta/bufexplorer', {'tag': 'v7.4.6'}
  Plug 'jtratner/vim-flavored-markdown', {'commit': '4a70aa2'}
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'kassio/neoterm', {'commit': '5146f7e'}
  Plug 'ledger/vim-ledger', {'commit': '6eb3bb21aa979cc295d0480b2179938c12b33d0d'}
  Plug 'mxw/vim-jsx', {'tag': 'ffc0bfd'}
  Plug 'nathangrigg/vim-beancount', {'commit': '8054352c43168ece62094dfc8ec510e347e19e3c'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'pangloss/vim-javascript', {'commit': 'dd84369d'}
  Plug 'scrooloose/nerdtree', {'tag': '5.0.0'}
  Plug 'terryma/vim-multiple-cursors'
  Plug 'tomtom/tcomment_vim', {'tag': '3.08'}
  " Automatically end certain structures (ruby blocks, etc)
  Plug 'tpope/vim-endwise', {'commit': '0067ced'}
  Plug 'vim-airline/vim-airline', {'tag': 'v0.8'}
  Plug 'vim-airline/vim-airline-themes', {'commit': '13bad30'}
  Plug 'vim-erlang/vim-erlang-runtime', {'commit': 'bba638c6ff658201fd6cd3cacc96cd4c7f63258c'}
  Plug 'w0rp/ale', {'commit': '4afbf2f25dc0ce86b118261b0cfb904c80ae6ba0'}
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

autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal spell
au BufRead,BufNewFile *.io		set filetype=io

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

nmap <silent> <C-P> :Files<CR>
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

syntax on
colorscheme onedark

" ### NerdTree ###

" Exit vim when only nerd tree is in buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" ###### ALE ######

" when to lint
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1

" add sign column emoticons
let g:ale_sign_error = 'e'
let g:ale_sign_warning = 'w'

" message format
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" always show the sign column
let g:ale_sign_column_always = 1
let g:ale_set_higlights = 1

" reset sign column background colors
highlight link ALEError SignColumn
highlight link ALEWarning SignColumn
highlight link ALEErrorSign SignColumn
highlight link ALEWarningSign SignColumn

" faster fzf fuzzy find respecting gitignore
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

" coc config
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" coc plugins (install with :CocInstall <foo>)
" rust: https://github.com/neoclide/coc-rls
