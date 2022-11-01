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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
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
Plug 'ojroques/nvim-lspfuzzy'
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

" LSP
set completeopt=menu,menuone,noselect

lua << EOF
require("nvim-tree").setup({
    renderer = {
        icons = {
            show = {
                file = false,
                folder = false,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                folder = {
                    arrow_closed = ">",
                    arrow_open = "v",
                },
                git = {
                  unstaged = "✗",
                  staged = "✓",
                  unmerged = "⇄",
                  renamed = "➜",
                  untracked = "★",
                  deleted = "d",
                  ignored = ""
                }
            }
        },
        indent_markers = {
            enable = true,
        }
    }
})

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
cmp.setup({
    preselect = cmp.PreselectMode.None,
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = function(fallback)
          if not cmp.select_next_item() then
              fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if not cmp.select_prev_item() then
              fallback()
          end
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        {
            name = 'buffer',
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end,
            },
        },
        { name = 'path' },
    })
})
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').fsautocomplete.setup {
    cmd = { "dotnet", "/home/markus/Applications/FsAutoComplete/fsautocomplete.dll", "--background-service-enabled" },
    capabilities = capabilities,
}
require('lspconfig').pylsp.setup{}
require('lspconfig').clangd.setup{}
require('lspconfig').gopls.setup{}
require('lspconfig').elmls.setup{}

local lspfuzzy = require('lspfuzzy')
lspfuzzy.setup {
  methods = 'all',
  jump_one = true,
  save_last = false,
}

require("trouble").setup{}
EOF

" Show diagnostics when moving over a line with errors
set updatetime=300
autocmd CursorHold * lua vim.diagnostic.open_float({ scope = 'cursor', focusable = false })

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

" fzf
" Show preview in Ag
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)

" List buffers to delete
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bdelete' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --bind ctrl-a:select-all+accept'
\ }))

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

" exec "autocmd ColorScheme * highlight Type guifg=" . g:terminal_color_14
" exec "autocmd ColorScheme * highlight Typedef guifg=" . g:terminal_color_14

" blend virtual text with background
" autocmd ColorScheme * highlight VirtualError guifg=#754852
" autocmd ColorScheme * highlight VirtualTodo guifg=#786E5B

" highlight link LspDiagnosticsDefaultError VirtualError
" highlight link LspDiagnosticsDefaultWarning VirtualTodo
" highlight link LspDiagnosticsDefaultInfo VirtualTodo
" highlight link LspDiagnosticsDefaultHint VirtualTodo

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
autocmd BufWritePre *.py lua vim.lsp.buf.formatting()

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
autocmd FileType fzf tnoremap <silent> <C-P> <C-\><C-N>:call SwitchFZFMode()<CR>

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
nnoremap <leader>f :lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>s :LspDocumentSymbols<CR>

command! GotoDefinition :lua vim.lsp.buf.definition()<CR>
command! FindReferences :lua vim.lsp.buf.references()<CR>
command! -nargs=0 Format :lua vim.lsp.buf.formatting()<CR>
command! LspDocumentSymbols :lua vim.lsp.buf.document_symbol()<CR>

" Leave terminal insert mode
tnoremap <C-n><C-n> <C-\><C-n>

" Building and testing
nnoremap <F7> :make!<CR>
nnoremap <F8> :TestLast()<CR>

autocmd FileType fsharp noremap <leader>I :FsiEvalBuffer<CR>
autocmd FileType fsharp vnoremap <leader>i :call fsharp#sendSelectionToFsi()<cr><esc>
autocmd FileType fsharp nnoremap <leader>i :call fsharp#sendLineToFsi()<cr>

command! EditConfig :e ~/.config/nvim/init.vim
