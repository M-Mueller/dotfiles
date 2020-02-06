" load vim-plug plugins
call plug#begin()
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline', {'branch': 'v0.10'}
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'machakann/vim-sandwich'
Plug 'easymotion/vim-easymotion'
Plug 'FooSoft/vim-argwrap'
if isdirectory($HOME . '/.fzf')
    Plug '~/.fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'sheerun/vim-polyglot'
Plug 'mg979/vim-visual-multi'
Plug 'wellle/targets.vim'
Plug 'majutsushi/tagbar'
Plug 'RRethy/vim-illuminate'
Plug 'psliwka/vim-smoothie'
Plug 'dyng/ctrlsf.vim'
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

        let height = &lines/2
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

" sandwich
" remap keybindings from s to S
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1
silent! nmap <unique> Sa <Plug>(operator-sandwich-add)
silent! xmap <unique> Sa <Plug>(operator-sandwich-add)
silent! omap <unique> Sa <Plug>(operator-sandwich-g@)

silent! nmap <unique><silent> Sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> Sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> Sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
silent! nmap <unique><silent> Srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

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
colorscheme nord
set termguicolors
Plug 'arcticicestudio/nord-vim'
let g:nord_cursor_line_number_background = 1

" blend virtual text with background
autocmd ColorScheme * highlight VirtualError guifg=#754852
autocmd ColorScheme * highlight VirtualTodo guifg=#786E5B

highlight link CocErrorVirtualText VirtualError
highlight link CocWarningVirtualText VirtualTodo
highlight link CocInfoVirtualText VirtualTodo
highlight link CocHintVirtualText VirtualTodo

" the default error highlight looks bad with the error sign
highlight link CocErrorSign SignifySignDelete
highlight link CocWarningSign SignifySignWarning

" -----------
" Misc config
" -----------
set encoding=utf-8

"show relative line numbers
set number
set relativenumber

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

autocmd FileType javascript,javascriptreact setlocal
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

autocmd FileType cpp setlocal
    \ noexpandtab

" Enable completion and linting for vue files
autocmd BufRead,BufNewFile *.vue setlocal
    \ filetype=vue.html.javascript.css

autocmd BufRead,BufNewFile *.js setlocal
    \ filetype=javascript.jsx


" -------------
" Abbreviations
" -------------

abbr esle else
abbr retrun return

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

" Save file
nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>a
nnoremap <leader>w :w<CR>

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
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" NERDTree shortcut
nnoremap <leader>n :NERDTreeToggle<CR>

" tagbar shortcut
nnoremap <leader>t :TagbarOpenAutoClose<CR>

" Fuzzy finder
nnoremap <C-p> :Files<CR>
nnoremap <leader>p :Files<CR>
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
nnoremap gh :GotoHeader<CR>
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

command! GotoDefinition :call CocAction('jumpDefinition')
command! FindReferences :call CocAction('jumpReferences')
command! GotoHeader execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand("%:p")})
command! -nargs=0 Format :call CocAction('format')
command! EditConfig :e ~/.config/nvim/init.vim

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
