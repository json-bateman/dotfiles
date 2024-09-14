--[[
 ________
| |____| |
| plugin |
|  (__)  |
|________|
]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
-- Need this for colorizer
vim.opt.termguicolors = true -- enables 24-bit RGB color for terminal

require("lazy").setup({
  "tpope/vim-commentary",          -- gc to comment out "tpope/vim-surround"
  "nanotee/luv-vimdocs",           -- puts lua docs into vim docs
  "tpope/vim-fugitive",            -- In the words of Tpope "a git wrapper so awesome it should be illegal"
  "ellisonleao/gruvbox.nvim",      -- To get groovy
  "navarasu/onedark.nvim",         -- The darkest one
  "nvim-tree/nvim-web-devicons",   -- icons for files, etc.
  "nvim-telescope/telescope.nvim", -- TJ's fuzzy finder
  "folke/neodev.nvim",             -- Configures Lua_ls to include neovim stuff!
  "nvim-lua/plenary.nvim",         -- Useful helper functions written by TJ
  -----------------------------
  -- plugins with extra options
  -----------------------------
  {
    "stevearc/oil.nvim", -- File system access easier
    config = function()
      require("oil").setup {
        cleanup_delay_ms = 100,
        columns = { "icon" },
        view_options = {
          show_hidden = true
        },
      }
      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- Open parent directory in floating window
      vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end
  },
  {
    "ThePrimeagen/harpoon", -- Poke the files you want
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end
  },
  {
    "williamboman/mason.nvim", -- UI for fetching/downloading LSPs
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim", -- Bridges mason and lspconfig
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "jdtls",
          "tsserver",
          "jsonls",
          "html",
          "cssls",
          "yamlls",
          "lua_ls",
          "rust_analyzer",
          "tailwindcss",
          "eslint",
          "clangd",
          "pyright",
          "gopls",
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig", -- neovims configuation for the built in client
    config = function()
      local ok, lspconfig = pcall(require, 'lspconfig')
      if (not ok) then
        print("require lspconfig failed")
        return
      end
      require("neodev").setup({
        override = function(_, library)
          library.enabled = true
          library.plugins = true
        end,
      })
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

      local function setup_diags()
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics,
          {
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            underline = true,
          }
        )
      end

      setup_diags()

      capabilities.textDocument.completion.completionItem.snippetSupport = true

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

      lspconfig["solidity"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
        filetypes = { "solidity" },
        root_dir = lspconfig.util.root_pattern("foundry.toml"),
        single_file_support = true,
      })

      lspconfig.eslint.setup({
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
      })


      local all_servers = {
        "lua_ls",
        "tsserver",
        "sqlls",
        "jdtls",
        "jsonls",
        "html",
        "cssls",
        "rust_analyzer",
        "tailwindcss",
        "clangd",
        "pyright",
        "gopls",
      }

      for _, server in ipairs(all_servers) do
        lspconfig[server].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      local patterns = { '*.lua', '*.tsx', '*.jsx', '*.ts', '*.js', '*.css', '*.html', '*.yaml', '*.java', '*.rs',
        '*.json', '*.sql' }

      vim.api.nvim_create_augroup('AutoFormatting', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = patterns,
        group = 'AutoFormatting',
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Up>"] = cmp.mapping.scroll_docs(-4),
          ["<Down>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<c-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<c-p>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "s" }),
        },
        sources = {
          -- the order you call these in determines the way they show up in completion window
          { name = "nvim_lua",               max_item_count = 20 },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "path" },
          { name = "nvim_lsp" },
          { name = "buffer",                 keyword_length = 5 },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if (not ok) then return end

      treesitter.setup({
        ensure_installed = {
          "bash",
          "markdown_inline",
          "markdown",
          "rust",
          "java",
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "python",
          "ruby",
          "go",
          "c",
          "vimdoc",
          "luadoc",
        },
        sync_install = true,
        auto_install = true,
        ignore_install = { "help" },
        highlight = {
          -- `false` will disable the whole extension
          enable = true,
          disable = {},
        },
        modules = {},
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap_ok, dap = pcall(require, "dap")
      if not dap_ok then
        print("dap not found!")
        return
      end
      local widgets_ok, widgets = pcall(require, "dap.ui.widgets")
      if not widgets_ok then
        print("widgets not found!")
        return
      end

      local dap_go_ok, dap_go = pcall(require, "dap-go")
      if not dap_go_ok then
        print("dap-go not found!")
        return
      end

      local dap_text_ok, dap_text = pcall(require, "nvim-dap-virtual-text")
      if not dap_text_ok then
        print("nvim-dap-virtual-text not found!")
        return
      end

      local dapui_ok, dapui = pcall(require, "dapui")
      if not dapui_ok then
        print("nvim-dap-ui not found!")
        return
      end

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "/Applications/iTerm.app/Contents/MacOS/Iterm2",
          args = { "dlv", "dap", "-l", "127.0.0.1:${port}" },
          -- args = { "dlv" },
        },
      }

      dap.configurations.go = {
        {
          type = 'go',
          name = 'Debug',
          request = 'launch',
          program = '${file}',
          showLog = true,
        },
      }

      dap_text.setup({})
      dap_go.setup()
      dapui.setup()


      dap.set_log_level("DEBUG")

      --- Debugging Keymaps ---
      local keymap = vim.keymap.set
      --- Start Debugging Session ---
      keymap("n", "<F1>", function() dap.continue() end)
      keymap("n", "<F2>", function() dap.step_over() end)
      keymap("n", "<F3>", function() dap.step_into() end)
      keymap("n", "<F4>", function() dap.step_out() end)
      keymap("n", "<F9>", function() dap.repl.open() end)
      keymap("n", "<F10>", function()
        widgets.preview()
      end)
      keymap("n", "<space>K", function() widgets.hover() end)
      keymap("n", "<space>b", function() dap.toggle_breakpoint() end)
      keymap("n", "<space>C", function() dap.clear_breakpoints() end)
      --- End Debugging Session ---
      keymap("n", "<F5>", function()
        dap.clear_breakpoints()
        dap.terminate()
        print("Debugger session ended")
      end)
    end
  },
})
