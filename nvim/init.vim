" load vim-plug plugins
call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'FooSoft/vim-argwrap'
if isdirectory($HOME . '/.fzf')
    Plug '~/.fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" Python
Plug 'vim-scripts/indentpython.vim'
Plug 'davidhalter/jedi-vim'

" Rust
Plug 'timonv/vim-cargo'

" Web
Plug 'othree/csscomplete.vim'
call plug#end()

" -----------
" Plugin config
" -----------

if has('nvim')
    " completion is provided by other plugin
    let g:jedi#completions_enabled = 0
    let g:jedi#max_doc_height = 15

    " unassign shortcuts
    let g:jedi#goto_command = ""
    let g:jedi#goto_assignments_command = ""
    let g:jedi#goto_definitions_command = ""
    let g:jedi#documentation_command = ""
    let g:jedi#usages_command = ""
    let g:jedi#completions_command = ""
    let g:jedi#rename_command = ""
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

" fzf
" Show preview in Files and Ag
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)


if exists('*nvim_open_win')
    " show in floating window if available
    let $FZF_DEFAULT_OPTS='--margin=1,2'
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }

    function! FloatingFZF()
        let buf = nvim_create_buf(v:false, v:true)
        call setbufvar(buf, '&signcolumn', 'no')

        let height = &lines/3
        let width = float2nr(&columns - (&columns * 2 / 10))
        let col = float2nr((&columns - width) / 2)

        let opts = {
                    \ 'relative': 'editor',
                    \ 'row': 8,
                    \ 'col': col,
                    \ 'width': width,
                    \ 'height': height
                    \ }

        call nvim_open_win(buf, v:true, opts)
    endfunction
endif

" Multiple cursors
let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0

" elm
let g:ale_elm_ls_use_global = 1
let g:ale_elm_ls_elm_path = "elm"
let g:ale_elm_ls_elm_format_path = "elm-format"
let g:ale_elm_ls_elm_test_path = "elm-test"
let g:ale_elm_ls_executable = "elm-language-server"
let g:elm_setup_keybindings = 0
let g:elm_format_fail_silently = 0

" ------------
" Color Config
" ------------
colorscheme base16-ocean
let base16colorspace=256
set termguicolors

" blend virtual text with background
autocmd ColorScheme * highlight VirtualError guifg=#754852
autocmd ColorScheme * highlight VirtualTodo guifg=#786E5B

highlight link CocErrorVirtualText VirtualError
highlight link CocWarningVirtualText VirtualTodo
highlight link CocInfoVirtualText VirtualTodo
highlight link CocHintVirtualText VirtualTodo

" the default error highlight looks bad with the error sign
autocmd ColorScheme * call g:Base16hi('SignifySignWarning', g:base16_gui0A, g:base16_gui01, g:base16_cterm08, g:base16_cterm01, "", "")
highlight link CocErrorSign SignifySignDelete
highlight link CocWarningSign SignifySignWarning

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

" automatically reload changed files when gaining focus
set autoread
au FocusGained,BufEnter * :silent! !

" always show 5 lines before and after the cursor
set scrolloff=5

" open new splits on the right by default
set splitright

" ignore case if search is only lowercase
set ignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

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
set cursorline

let python_highlight_all=1
syntax on

" ---------------
" Filetype config
" ---------------

autocmd FileType javascript setlocal
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

autocmd FileType cpp setlocal
    \ noexpandtab

" Enable completion and linting for vue files
autocmd BufRead,BufNewFile *.vue setlocal
    \ filetype=vue.html.javascript.css

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
nnoremap <leader>x :bp<bar>bd#<CR>

" Select next completion with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" NERDTree shortcut
nnoremap <leader>n :NERDTreeToggle<CR>

" Open previous buffer
nnoremap <leader><Tab> :b#<CR>

" Fuzzy finder
nnoremap <C-p> :Files<CR>
nnoremap <leader><space> :Buffers<CR>

" Toggle comment (actually maps <C-/>)
nmap <C-_> gcc
vmap <C-_> gc

" EasyMotion
map , <Plug>(easymotion-prefix)
map ,, <Plug>(easymotion-bd-w)
map ,f <Plug>(easymotion-bd-f)

" LSP
nnoremap gd :GotoDefinition<CR>
nnoremap <silent> <F2> :call CocAction('rename')<CR>
nnoremap <silent> <F1> :call CocAction('doHover')<CR>

" Leave terminal insert mode
tnoremap <C-n><C-n> <C-\><C-n>

" Run the current file through pythons unittest
command! -nargs=* PythonTest :!python3 -m pytest <f-args> %
" Run all tests in the tests directory of the working directory
command! -nargs=* PythonTestAll :!python3 -m pytest
" Run doctest on the current file
command! -nargs=* PythonDocTest :!python3 -m doctest %

autocmd filetype python nnoremap <F5> :w <bar> :PythonTestAll<CR>

command GotoDefinition :call CocAction('jumpDefinition')
command FindReferences :call CocAction('jumpReferences')

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
