call plug#begin('~/.config/nvim/plugged')
  " Changes the definition of a word for better navigation
  Plug 'chaoren/vim-wordmotion'
  Plug 'editorconfig/editorconfig-vim', {'commit': '0a3c1d8082e38a5ebadcba7bb3a608d88a9ff044'} " v1.1.1
  " Reopens file to last edit position
  Plug 'farmergreg/vim-lastplace', {'tag': 'v3.2.1'}
  Plug 'hashivim/vim-terraform', {'commit': '552daab4'}
  Plug 'HerringtonDarkholme/yats.vim' " Dep of vim-jsx-pretty
  Plug 'janko-m/vim-test', {'commit': '8300ee6'}
  Plug 'jlanzarotta/bufexplorer', {'tag': 'v7.4.6'}
  Plug 'jtratner/vim-flavored-markdown', {'commit': '4a70aa2'}
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'kassio/neoterm', {'commit': '5146f7e'}
  Plug 'ledger/vim-ledger', {'commit': '6eb3bb21aa979cc295d0480b2179938c12b33d0d'}
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'mxw/vim-jsx', {'tag': 'ffc0bfd'}
  Plug 'nathangrigg/vim-beancount', {'commit': '2f970a0c826275f7d07fa145ba9a35c15b15232d'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'pangloss/vim-javascript', {'commit': 'd6e137563c47fb59f26ed25d044c0c7532304f18'}
  Plug 'scrooloose/nerdtree', {'tag': '5.0.0'}
  Plug 'sonph/onehalf', { 'rtp': 'vim' }
  Plug 'tomtom/tcomment_vim', {'tag': '3.08'}
  " Automatically end certain structures (ruby blocks, etc)
  Plug 'tpope/vim-endwise', {'commit': '0067ced'}
  Plug 'vim-airline/vim-airline', {'tag': 'v0.8'}
  Plug 'w0rp/ale', {'commit': '4afbf2f25dc0ce86b118261b0cfb904c80ae6ba0'}
  Plug 'yuezk/vim-js' " Dep of vim-jsx-pretty
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
colorscheme onehalflight
let g:airline_theme='onehalfdark'

" ### NerdTree ###

" Exit vim when only nerd tree is in buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" ###### Beancount ######
let b:beancount_root = '~/src/atareshawty/ledger/main.bean'

" ###### ALE ######

" when to lint and save
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_fix_on_save = 1

" add sign column emoticons
let g:ale_sign_error = 'e'
let g:ale_sign_warning = 'w'

" message format
let g:ale_echo_msg_format = '[%linter%] %s [%severity%/%code%]'

" always show the sign column
let g:ale_sign_column_always = 1
let g:ale_set_higlights = 1

let g:ale_fixers = {}
let g:ale_fixers.javascript = ['prettier', 'eslint']
let g:ale_fixers.typescript = ['prettier', 'eslint']
let g:ale_fixers.typescriptreact = ['prettier', 'eslint']
let g:ale_fixers.terraform = ['terraform']
let g:ale_fixers.python = ['black']
let g:ale_fixers.terraform = ['terraform']

" reset sign column background colors
highlight link ALEError SignColumn
highlight link ALEWarning SignColumn
highlight link ALEErrorSign SignColumn
highlight link ALEWarningSign SignColumn

" faster fzf fuzzy find respecting gitignore
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!target/*" --glob "!node_modules/" --glob "!tmp/" --glob "!__pycache__"'

" ###### COC ######
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
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

" coc plugins (install with :CocInstall <foo>)
" python: https://github.com/fannheyward/coc-pyright
" rust: https://github.com/neoclide/coc-rls
" typescript: https://github.com/neoclide/coc-tsserver

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

call SourceIfExists("~/.config/nvim/private.vim")
