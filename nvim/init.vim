" load vim-plug plugins
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'FooSoft/vim-argwrap'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'junegunn/gv.vim'
Plug 'mg979/vim-visual-multi'
Plug 'PeterRincker/vim-argumentative'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'mbbill/undotree'
Plug 'vim-test/vim-test'
Plug 'nvim-tree/nvim-tree.lua'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'simrat39/symbols-outline.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" eye candy
Plug 'gruvbox-community/gruvbox'
Plug 'RRethy/vim-illuminate'
Plug 'psliwka/vim-smoothie'

" Web
Plug 'othree/csscomplete.vim'

" F#
Plug 'ionide/Ionide-vim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" -----------
" Plugin config
" -----------

lua require("basic")

" LSP
set completeopt=menu,menuone,noselect

" Show diagnostics when moving over a line with errors
set updatetime=300
autocmd CursorHold * lua vim.diagnostic.open_float({ scope = 'cursor', focusable = false })

" lightline config
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'component_function': {
      \   'filename': 'FilenameForLightline'
      \ }
      \ }

" Show full path of filename
function! FilenameForLightline()
    return expand('%')
endfunction

" vim-test
let test#strategy = "make_bang"

" elm
let g:elm_setup_keybindings = 0
let g:elm_format_fail_silently = 0

" fsharp
let g:fsharp#backend = "disable"
let g:fsharp#fsi_keymap = "none"

" ------------
" Color Config
" ------------
set background=light
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
set termguicolors

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

" preview :substitude command
set inccommand=split

" start terminal in insert mode
autocmd TermOpen * startinsert

" show whitespace characters
set list
set list listchars=tab:→\ ,space:·
set cursorline

let python_highlight_all=1
syntax on

" use rg as grep replacement if available
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ --follow\ --smart-case
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" ---------------
" Filetype config
" ---------------

autocmd FileType html,javascript,javascriptreact setlocal
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

" Hot Module Replacement doesn't work reliable without this option
autocmd FileType elm,javascript,html,css setlocal
    \ backupcopy=yes

autocmd FileType fsharp setlocal
    \ makeprg=dotnet\ build
    \ errorformat=%f(%l\\,%c):\ error\ FS%n:\ %m
    \ commentstring=//\ %s

autocmd FileType elm setlocal
    \ makeprg=elm\ make\ --output=/dev/null\ src/Main.elm

autocmd FileType rust setlocal
    \ makeprg=cargo\ build

" Format on save
autocmd BufWritePre *.py lua vim.lsp.buf.format()
autocmd BufWritePre *.elm lua vim.lsp.buf.format()
autocmd BufWritePre *.fsx lua vim.lsp.buf.format()

" -------------
" Abbreviations
" -------------

abbr esle else
abbr retrun return
abbr maintance maintenance

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

" Copy to end of line
map <silent> Y y$

" switch to previous buffer
nnoremap <leader><Tab> :b#<CR>

" Close buffer without closing split
nnoremap <leader>x :bp<bar>bd#<CR>

" Select next completion with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" nvim-tree shortcut
nnoremap <silent> <leader>n :NvimTreeToggle<CR>

" tags shortcut
nnoremap <leader>t :Tags<CR>

" Fuzzy finder
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <leader>p :Telescope find_files<CR>
nnoremap <leader><space> :Telescope buffers<CR>

" Toggle comment (actually maps <C-/>)
nmap <C-_> gcc
vmap <C-_> gc

" EasyMotion
map , <Plug>(easymotion-prefix)
map ,, <Plug>(easymotion-bd-w)
map ,f <Plug>(easymotion-bd-f)
let g:EasyMotion_smartcase = 1

" LSP
nnoremap gd :GotoDefinition<CR>
nnoremap gh :GotoHeader<CR>
nnoremap <silent> <F1> :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <F2> :lua vim.lsp.buf.rename()<CR>
nmap <silent> <space>E :lua vim.diagnostic.goto_prev()<CR>
nmap <silent> <space>e :lua vim.diagnostic.goto_next()<CR>
nnoremap <A-CR> :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>f :lua vim.lsp.buf.format()<CR>
nnoremap <leader>s :LspDocumentSymbols<CR>

command! GotoDefinition :lua vim.lsp.buf.definition()<CR>
command! FindReferences :lua vim.lsp.buf.references()<CR>
command! -nargs=0 Format :lua vim.lsp.buf.format()<CR>
command! LspDocumentSymbols :lua vim.lsp.buf.document_symbol()<CR>

" Install all LSP packages required for Python
command! LspInstallPylsp :!pip install python-lsp-server pylsp-mypy python-lsp-black black<CR>

" Leave terminal insert mode
tnoremap <C-n><C-n> <C-\><C-n>

" Building and testing
nnoremap <F7> :make!<CR>
nnoremap <F8> :TestLast()<CR>

autocmd FileType fsharp noremap <leader>I :FsiEvalBuffer<CR>
autocmd FileType fsharp vnoremap <leader>i :call fsharp#sendSelectionToFsi()<cr><esc>
autocmd FileType fsharp nnoremap <leader>i :call fsharp#sendLineToFsi()<cr>

command! EditConfig :e ~/.config/nvim/init.vim
