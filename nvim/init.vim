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
Plug 'nvie/vim-flake8'
call plug#end()

" -----------
" Plugin config
" -----------
colorscheme Tomorrow-Night

" YouCompleteMe configuration
let g:ycm_autoclose_preview_window_after_completion=1

" NERDTree config
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__']

" airline config
" mode is already displayed by airline
set noshowmode
let g:airline_powerline_fonts = 1
" show bufferline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '

" flake8 config
" Run checks when saving py files
autocmd BufWritePost *.py call Flake8()

" -----------
" Misc config
" -----------
set encoding=utf-8

"show line numbers
set nu  

" Allow hiding modified buffers
set hidden

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
if has('nvim')
    set inccommand=split 
endif

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

" Wrap words in text files
au BufNewFile,BufRead *.md,*.txt set
    \ wrap
    \ linebreak
    \ spell

" Color bad whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" -----------
" Key mapping
" -----------

" Set leader to ,
let mapleader = ","

" Navigations with ctrl
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Save with C-S
nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>a

" Paste from clipboard in insert mode
inoremap <C-V> <ESC>"+pa
" Copy to clipboard in visual mode
vnoremap <C-C> "+y

" Enable folding with the spacebar
nnoremap <space> za

" Navigate by soft line wraps
nnoremap <silent> j gj
nnoremap <silent> k gk

" Show buffer list and select buffer
nnoremap <leader>b :buffers<CR>:buffer<Space>
" Switch between recent buffers
nnoremap <C-Space> :b#<CR>
" Move to buffer to left/right
nnoremap <A-h> :bp<CR>
nnoremap <A-l> :bn<CR>

" NERDTree shortcut
nnoremap <leader>n :NERDTree<CR>

" Execute current file with F5
autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype qml nnoremap <F5> :w <bar> exec '!qml '.shellescape('%')<CR>
" Execute main with F6
autocmd filetype python nnoremap <F6> :w <bar> exec '!python main.py'<CR>
autocmd filetype qml nnoremap <F6> :w <bar> exec '!qml main.qml'<CR>

" Start flask server with :FlaskRun
command! FlaskRun :!FLASK_APP=% flask-3 run --host=0.0.0.0
" Run the current file through pythons unittest
command! -nargs=* PythonTest :!python3 -m unittest <f-args> %
" Run all tests in the tests directory of the working directory
command! -nargs=* PythonTestAll :!python3 -m unittest <f-args> tests/test_*.py
" Show documentation for object under cursor
command! GetDoc :YcmCompleter GetDoc
