" load vim-plug plugins
call plug#begin()
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'neomake/neomake'
endif

" Python
Plug 'vim-scripts/indentpython.vim'
if has('nvim')
	Plug 'zchee/deoplete-jedi'
endif

" Rust
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'
call plug#end()

" -----------
" Plugin config
" -----------
colorscheme Tomorrow-Night

" deoplete config
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
" close preview after completion
autocmd CompleteDone * silent! pclose!

" neomake config
call neomake#configure#automake('w')

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

" File types with space indentation
au BufNewFile,BufRead *.toml,*.yaml,Dockerfile set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ expandtab

" Wrap words in text files
au BufNewFile,BufRead *.md,*.txt set
    \ wrap
    \ linebreak
    \ spell

" CMakeLists are no regular txt files
au BufNewFile,BufRead CMakeLists.txt set
    \ nowrap
    \ nospell

" Color bad whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" -----------
" Key mapping
" -----------

" Set leader to ,
let mapleader = " "

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
nnoremap <leader>f za

" Navigate by soft line wraps
nnoremap <silent> j gj
nnoremap <silent> k gk

" Show buffer list and select buffer
nnoremap <leader>b :buffers<CR>:buffer<Space>
" Switch between recent buffers
nnoremap <leader><Tab> :b#<CR>
" Move to buffer to left/right
nnoremap <A-h> :bp<CR>
nnoremap <A-l> :bn<CR>
" Close buffer without closing split
nnoremap <C-X> :b#<bar>bd#<CR>

" Select next completion with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" NERDTree shortcut
nnoremap <leader>n :NERDTreeToggle<CR>

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

function CMakeBuildFolder(config)
	let folder = fnamemodify(getcwd(), ':t')
	return "../build-" . folder . "-" . a:config
endfunction

function CMakeSelectConfig(config)
	let folder = CMakeBuildFolder(a:config)
	let &makeprg = "cmake --build " . folder
endfunction

function CMakeInitConfig(config)
	let build_folder = CMakeBuildFolder(a:config)
	let src_folder = fnamemodify(getcwd(), ':t')
	silent execute "!mkdir -p " . build_folder
	execute ":edit term://cd " . build_folder . " && ccmake ../" . src_folder . " | :startinsert"
	call CMakeSelectConfig(a:config)
endfunction

command! -nargs=1 CMakeSelect :call CMakeSelectConfig(<f-args>)
command! -nargs=1 CMakeInit :call CMakeInitConfig(<f-args>)
