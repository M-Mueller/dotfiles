set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'vim-scripts/indentpython.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'peterhoeg/vim-qml'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

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

" enable mouse support everywhere
set mouse=a

set tabstop=4
set softtabstop=4
set shiftwidth=4

let python_highlight_all=1
syntax on

" Execute current file with F5
autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype qml nnoremap <F5> :w <bar> exec '!qml '.shellescape('%')<CR>
" Execute main with F6
autocmd filetype python nnoremap <F6> :w <bar> exec '!python main.py'<CR>
autocmd filetype qml nnoremap <F6> :w <bar> exec '!qml main.qml'<CR>
