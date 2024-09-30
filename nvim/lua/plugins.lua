return {
  "tpope/vim-commentary",          -- gc to comment out "tpope/vim-surround"
  "nanotee/luv-vimdocs",           -- puts lua docs into vim docs
  "tpope/vim-fugitive",            -- In the words of Tpope "a git wrapper so awesome it should be illegal"
  "ellisonleao/gruvbox.nvim",      -- To get groovy
  "rebelot/kanagawa.nvim",         -- The colors of a famous painting Katsushika Hokusai
  "EdenEast/nightfox.nvim",        -- Foxy
  "navarasu/onedark.nvim",         -- The darkest one
  "nvim-tree/nvim-web-devicons",   -- icons for files, etc.
  "nvim-telescope/telescope.nvim", -- TJ's fuzzy finder
  "folke/neodev.nvim",             -- Configures Lua_ls to include neovim stuff!
  "nvim-lua/plenary.nvim",         -- Useful helper functions written by TJ
  -----------------------------
  -- plugins with extra options
  -----------------------------
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
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
      vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
    end
  },
  {
    "ThePrimeagen/harpoon", -- Poke the files you want
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      -- Harpoon Keymaps
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
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
          "ts_ls",
          "denols",
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
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

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
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      vim.lsp.set_log_level("debug")

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

      -- Set up some servers with custom settings --
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

      lspconfig.denols.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      })

      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = false,
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

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
              disable = { "missing-parameters", "missing-fields" },
            },
          },
        },
      })

      -- Set up the rest of the servers with default settings --
      local all_servers = {
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
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP" },
    },
    dependencies = {
      -- might have to do this build command manually, go to '<path to>/.local/share/nvim/lazy/vscode-js-debug`
      -- and run the commands from the instructions in "mxsdev/nvim-dap-vscode-js"
      {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
      },
      "mxsdev/nvim-dap-vscode-js",
      {
        "theHamsta/nvim-dap-virtual-text",
        commit = "9578276",
      },
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("configs.dap")
    end
  },
}
