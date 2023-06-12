local ok, lspconfig = pcall(require, 'lspconfig')
if (not ok) then return end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
   -- Enable completion triggered by <c-x><c-o>
   client.server_capabilities.semanticTokensProvider = nil

   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
   if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
         group = augroup,
         buffer = bufnr,
         callback = function()
            vim.lsp.buf.format()
         end,
      })
   end

   -- Mappings.
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   local bufopts = { noremap = true, silent = true, buffer = bufnr }
   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
   vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, bufopts)
   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
   vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, bufopts)
   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
   vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
   vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
   vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Cmp stuff
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Ufo stuff
-- capabilities.textDocument.foldingRange = {
--    dynamicRegistration = false,
--    lineFoldingOnly = true
-- }

lspconfig.lua_ls.setup {
   on_attach = on_attach,
   capabilities = capabilities,

   settings = {
      Lua = {
         diagnostics = {
            globals = { "vim", "P", "it", "describe", "before_each" },
         },
      },
   },
}

lspconfig.yamlls.setup {
   on_attach = on_attach,
   capabilities = capabilities,

   settings = {
      yaml = {
         schemaStore = {
            url = "https://www.schemastore.org/api/json/catalog.json",
            enable = true,
         }
      }
   },
}

lspconfig.eslint.setup {
   on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
         buffer = bufnr,
         command = "EslintFixAll",
      })
   end,
   settings = {
      workingDirectory = { mode = 'location' },
   },
   root_dir = lspconfig.util.find_git_ancestor,
}

local all_servers = {
   "sqlls",
   "jdtls",
   "tsserver",
   "jsonls",
   "html",
   "cssls",
   "solargraph",
   "rust_analyzer",
   "tailwindcss",
   "clangd",
}
for _, server in ipairs(all_servers) do
   lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = capabilities,
   }
end

local patterns = { '*.lua', '*.tsx', '*.jsx', '*.ts', '*.js', '*.css', '*.html', '*.yaml', '*.rb', '*.java', '*.rs',
   '*.json', '*.sql' }

vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
   pattern = patterns,
   group = 'AutoFormatting',
   callback = function()
      vim.lsp.buf.format({ async = false })
   end,
})
