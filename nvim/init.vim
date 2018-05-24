" load vim-plug plugins
call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'neomake/neomake'
endif

" Python
Plug 'vim-scripts/indentpython.vim'
Plug 'davidhalter/jedi-vim'
if has('nvim')
    Plug 'zchee/deoplete-jedi'
endif

" Rust
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'

" OpenGL
Plug 'tikhomirov/vim-glsl'
call plug#end()

" -----------
" Plugin config
" -----------
colorscheme base16-onedark
let base16colorspace=256
set termguicolors

if has('nvim')
    " deoplete config
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#jedi#show_docstring = 1
    " close preview after completion
    autocmd CompleteDone * silent! pclose!

    " denite config
    call denite#custom#option('default', {
        \ 'prompt': '❯',
        \ 'cursor_wrap': 'true',
        \ 'highlight_matched_range': 'None',
        \ 'highlight_matched_char': 'Underlined',
        \ 'highlight_mode_insert': 'PMenuSel',
        \ })
    " use ag for search files and grep
    call denite#custom#var('file_rec', 'command',
                \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " neomake config
    call neomake#configure#automake('w')
    let g:neomake_python_exe = 'python3'

    " completion is provided by deoplete
    let g:jedi#completions_enabled = 0
endif

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

" automatically reload changed files
set autoread

" always show one line before and after the cursor
set scrolloff=1

" open new splits on the right by default
set splitright

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

" Use tabs in C/C++ files
au BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ noexpandtab
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

" -----------
" Key mapping
" -----------

" Set leader to space
let mapleader = " "

" Window navigations with ctrl
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

" Navigate by soft line wraps
nnoremap <silent> j gj
nnoremap <silent> k gk

" switch to previous buffer
nnoremap <leader><Tab> :b#<CR>

" Close buffer without closing split
nnoremap <leader>x :b#<bar>bd#<CR>

" Select next completion with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" NERDTree shortcut
nnoremap <leader>n :NERDTreeToggle<CR>

if has('nvim')
    " denite shortcuts
    nnoremap <C-p> :Denite file_rec -auto-preview -vertical-preview<CR>
    nnoremap <leader><Tab> :b#<CR>
    nnoremap <leader><space> :Denite buffer -vertical-preview<CR>
    nnoremap <leader>s :Denite grep -auto-preview -vertical-preview<CR>
    call denite#custom#map('insert', '<Tab>', '<denite:move_to_next_line>', 'noremap')
    call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
    call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
    call denite#custom#map('insert', '<C-Space>', '<denite:choose_action>', 'noremap')
endif

" Execute current file with F5
autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype qml nnoremap <F5> :w <bar> exec '!qml '.shellescape('%')<CR>
" Execute main with F6
autocmd filetype python nnoremap <F6> :w <bar> exec '!python main.py'<CR>
autocmd filetype qml nnoremap <F6> :w <bar> exec '!qml main.qml'<CR>

" Start flask server with :FlaskRun
command! FlaskRun :!FLASK_APP=% flask-3 run --host=0.0.0.0
" Run the current file through pythons unittest
command! -nargs=* PythonTest :!python3 -m pytest <f-args> %
" Run all tests in the tests directory of the working directory
command! -nargs=* PythonTestAll :!python3 -m pytest
" Run doctest on the current file
command! -nargs=* PythonDocTest :!python3 -m doctest %

function! CMakeBuildFolder(config)
	let folder = fnamemodify(getcwd(), ':t')
	return "../build-" . folder . "-" . a:config
endfunction

function! CMakeSelectConfig(config)
	let folder = CMakeBuildFolder(a:config)
	let &makeprg = "cmake --build " . folder
endfunction

function! CMakeInitConfig(config)
	let build_folder = CMakeBuildFolder(a:config)
	let src_folder = fnamemodify(getcwd(), ':t')
	silent execute "!mkdir -p " . build_folder
	execute ":edit term://cd " . build_folder . " && ccmake ../" . src_folder . " | :startinsert"
	call CMakeSelectConfig(a:config)
endfunction

command! -nargs=1 CMakeSelect :call CMakeSelectConfig(<f-args>)
command! -nargs=1 CMakeInit :call CMakeInitConfig(<f-args>)
