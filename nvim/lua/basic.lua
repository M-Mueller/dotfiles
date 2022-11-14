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

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').fsautocomplete.setup {
    cmd = { "dotnet", "/home/markus/Applications/FsAutoComplete/fsautocomplete.dll", "--background-service-enabled" },
    capabilities = capabilities,
}
require('lspconfig').pylsp.setup{}
require('lspconfig').clangd.setup{}
require('lspconfig').gopls.setup{}
require('lspconfig').elmls.setup{}

require("trouble").setup{}
