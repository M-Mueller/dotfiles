" load vim-plug plugins
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'FooSoft/vim-argwrap'
if isdirectory($HOME . '/.fzf')
    Plug '~/.fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'sheerun/vim-polyglot'
Plug 'mg979/vim-visual-multi'
Plug 'PeterRincker/vim-argumentative'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'mbbill/undotree'
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'
if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" eye candy
Plug 'arcticicestudio/nord-vim'
Plug 'RRethy/vim-illuminate'
Plug 'psliwka/vim-smoothie'

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

" lightline config
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'component_function': {
      \   'filename': 'FilenameForLightline'
      \ }
      \ }

" Show full path of filename
function! FilenameForLightline()
    return expand('%')
endfunction

" fzf
" Show preview in Ag
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, <bang>0)
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
        let width = float2nr(&columns - (&columns * 1 / 10))
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

" elm
let g:elm_setup_keybindings = 0
let g:elm_format_fail_silently = 0
let g:tagbar_type_elm = {
          \   'ctagstype':'elm'
          \ , 'kinds':['h:header', 'i:import', 't:type', 'f:function', 'e:exposing']
          \ , 'sro':'&&&'
          \ , 'kind2scope':{ 'h':'header', 'i':'import'}
          \ , 'sort':0
          \ }

" gutentags
if executable('fd')
    " Consider gitignore when generating tags
    let g:gutentags_file_list_command = 'fd'
endif
let g:gutentags_project_root = ['CMakeLists.txt', 'package.json', 'elm.json']
let g:gutentags_add_default_project_roots = v:false

" ------------
" Color Config
" ------------
colorscheme nord
set termguicolors
let g:nord_cursor_line_number_background = 1

" use nord7_gui to emphasize types (g:terminal_color_14 is s:nord7_gui)
exec "autocmd ColorScheme * highlight Type guifg=" . g:terminal_color_14
exec "autocmd ColorScheme * highlight Typedef guifg=" . g:terminal_color_14

" blend virtual text with background
autocmd ColorScheme * highlight VirtualError guifg=#754852
autocmd ColorScheme * highlight VirtualTodo guifg=#786E5B

highlight link CocErrorVirtualText VirtualError
highlight link CocWarningVirtualText VirtualTodo
highlight link CocInfoVirtualText VirtualTodo
highlight link CocHintVirtualText VirtualTodo

" -----------
" Misc config
" -----------
set encoding=utf-8
set fsync

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

" Keep persistent undotree
set undofile

if has('nvim')
    " preview :substitude command
    set inccommand=split

    " start terminal in insert mode
    autocmd TermOpen * startinsert
endif

" show whitespace characters
set list
set list listchars=tab:→\ ,space:·
set cursorline

let python_highlight_all=1
syntax on

" use rg as grep replacement if available
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

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

if executable("jq")
    " Reformat elm make errors to a single line
    autocmd FileType elm setlocal
        \ makeprg=vim_elm_make " defined in fish config because vimscript escaping is retarded
        \ errorformat=%f:%l:%c\ (%o)\ %m
endif
command! Elmtest :terminal elm-test
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

" Switch FZF to Files mode
function! SwitchFZFMode()
    " copy everything until the cursor position into register z
    normal v0"zy
    if matchstr(@z, 'Buf>') != ""
        " copy text after 'Buf>' and trim whitespace
        let query = substitute(@z, '\s*Buf>\s*\(.\{-}\)\s*$', '\1', 'g')
        " close current fzf window
        q
        " need to wait before launching :Files
        sleep 10m
        Files
        " enter the previously copied text as search
        call feedkeys(l:query, 't')
    else
        " ignore in non buffer modes and go back to insert
        normal A
    endif
endfunction
autocmd FileType fzf tnoremap <silent> <space><space> <C-\><C-N>:call SwitchFZFMode()<CR>

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
