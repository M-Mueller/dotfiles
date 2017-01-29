call plug#begin()
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'
"Plug 'scrooloose/syntastic'
"Plug 'nvie/vim-flake8'
"Plug 'tpope/vim-fugitive'
"Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'peterhoeg/vim-qml'
call plug#end()

"navigations with ctrl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Set PEP8 indentation
au BufNewFile,BufRead *.py set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix

" Color bad whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" YouCompleteMe configuration
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" NERDTree config
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

set encoding=utf-8
set nu  "show line numbers

" ignore case if search is only lowercase 
set ignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4

set inccommand=split " preview :substitude command

let python_highlight_all=1
syntax on

" Execute current file with F5
autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype qml nnoremap <F5> :w <bar> exec '!qml '.shellescape('%')<CR>
" Execute main with F6
autocmd filetype python nnoremap <F6> :w <bar> exec '!python main.py'<CR>
autocmd filetype qml nnoremap <F6> :w <bar> exec '!qml main.qml'<CR>
