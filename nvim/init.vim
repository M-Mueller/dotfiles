" load vim-plug plugins
call plug#begin()
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim'}
"Plug 'scrooloose/syntastic'
"Plug 'nvie/vim-flake8'
"Plug 'tpope/vim-fugitive'
"Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'peterhoeg/vim-qml'
call plug#end()

" -----------
" Plugin config
" -----------
colorscheme Tomorrow-Night

" YouCompleteMe configuration
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" NERDTree config
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" airline config
" mode is already displayed by airline
set noshowmode
let g:airline_powerline_fonts = 1

" -----------
" Misc config
" -----------
set encoding=utf-8

"show line numbers
set nu  

" enable mouse support everywhere
set mouse=a

" ignore case if search is only lowercase 
set ignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4

" Enable folding
set foldmethod=indent
set foldlevel=99

" preview :substitude command
set inccommand=split 

" show whitespace characters
set list
set list listchars=tab:→\ ,space:·

let python_highlight_all=1
syntax on

" Set PEP8 indentation
au BufNewFile,BufRead *.py set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix

" Set TOML indentation with spaces
au BufNewFile,BufRead *.toml set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ expandtab

" Color bad whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" -----------
" Key mapping
" -----------

" Navigations with ctrl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Save with C-S
nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>a

" Paste from clipboard with C-V in insert mode
inoremap <C-V> <ESC>"+pa

" Enable folding with the spacebar
nnoremap <space> za

" Navigate by soft line wraps
nnoremap <silent> j gj
nnoremap <silent> k gk

" Execute current file with F5
autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype qml nnoremap <F5> :w <bar> exec '!qml '.shellescape('%')<CR>
" Execute main with F6
autocmd filetype python nnoremap <F6> :w <bar> exec '!python main.py'<CR>
autocmd filetype qml nnoremap <F6> :w <bar> exec '!qml main.qml'<CR>
