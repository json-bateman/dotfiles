--[[
 ________
| |____| |
| plugin |
|  (__)  |
|________|

]]

return {
  -- "EdenEast/nightfox.nvim",                      -- Foxy
  -- "navarasu/onedark.nvim",                       -- The darkest one
  "ellisonleao/gruvbox.nvim",    -- To get groovy
  "rebelot/kanagawa.nvim",       -- The colors of a famous painting Katsushika Hokusai
  "nanotee/luv-vimdocs",         -- puts lua docs into vim docs
  "nvim-tree/nvim-web-devicons", -- icons for files, etc.
  "folke/neodev.nvim",           -- Configures Lua_ls to include neovim stuff!
  "nvim-lua/plenary.nvim",       -- Useful helper functions written by TJ
  -----------------------------
  -- plugins with extra options
  -----------------------------
  -- Trying to make a custom plugin
  { dir = "/Users/jack/Coding/plugins/dockerino" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      vim.keymap.set('n', '<leader>/', '<CMD>Neotree toggle<CR>', { desc = '[N]eo [T]ree' })
    end
  },
  {
    "nvim-telescope/telescope.nvim", -- TJ's fuzzy finder
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sG',
        "<CMD>lua require('telescope.builtin').live_grep({search_dirs={vim.fn.expand('%.h')}})<CR>",
        { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    end
  },
  {
    "NeogitOrg/neogit",         -- Git wrapper to stay in vim
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
    keys = {
      { "<leader>ng", "<CMD>:Neogit<CR>", desc = "Neogit" },
    },
    config = true
  },

  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
  {
    "alexghergh/nvim-tmux-navigation", -- Move in Neovim and Tmux
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup {
        disable_when_zoomed = true -- defaults to false
      }

      vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "gb", function() require("snipe").open_buffer_menu() end, desc = "Open snipe buffer menu" }
    },
    opts = {},
  },
  {
    "nvim-pack/nvim-spectre", -- Find and Replace
    event = "VeryLazy",
    config = function()
      -- https://github.com/nvim-pack/nvim-spectre/issues/118
      -- Sed after replacing makes a backup file, an empty arg fixes the issue
      require("spectre").setup({
        replace_engine = {
          ["sed"] = {
            cmd = "sed",
            args = {
              "-i",
              "",
              "-E",
            },
          },
        },
      })
      -- Spectre
      vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
    end
  },
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
    event = "VeryLazy",
    config = function()
      require("oil").setup {
        cleanup_delay_ms = 100,
        columns = { "icon" },
        view_options = {
          show_hidden = true
        },
        keymaps = {
          ["<C-h>"] = false, -- Off to move between splits
          ["<C-l>"] = false, -- Off to move between splits
        },
      }
      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- Open parent directory in floating window
      vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
    end
  },
  {
    "williamboman/mason.nvim", -- UI for fetching/downloading LSPs
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",          -- Bridges mason and lspconfig
    dependencies = { "williamboman/mason.nvim" }, -- mason-lspconfig must load after mason
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
          "dockerls",
          "solidity_ls_nomicfoundation",
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
        -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
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

      -- Change to log level "debug" to see all lsp info
      -- Note: If you keep debug on it creates a massive file
      vim.lsp.set_log_level("off");

      --IIFE to setup diagnostics... Need semicolon on the line above to deliminate IIFE's in lua, without it trys to curry the function above
      --https://stackoverflow.com/questions/53656742/defining-and-calling-function-at-the-same-time-in-lua
      (function()
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics,
          {
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            underline = true,
          }
        )
      end)();

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

      lspconfig.cssls.setup({
        settings = {
          css = {
            lint = {
              unknownAtRules = 'ignore',
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
        "rust_analyzer",
        "tailwindcss",
        "clangd",
        "pyright",
        "gopls",
        "templ",
        "dockerls",
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
    event = "VeryLazy",
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
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = 'path' }
      --   }, {
      --     { name = 'cmdline' }
      --   }),
      --   matching = { disallow_symbol_nonprefix_matching = false }
      -- })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Better AST selection
      "nvim-treesitter/nvim-treesitter-context",     -- See the context of the function you're in
    },
    config = function()
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if (not ok) then return end

      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true })

      treesitter.setup({
        ensure_installed = {
          "bash",
          "markdown_inline",
          "markdown",
          "rust",
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "python",
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
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["bi"] = "@block.inner",
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              -- ['@class.outer'] = '<c-v>', -- blockwise
              ['@class.outer'] = 'v',     -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },
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
  -- {
  --   "Exafunction/codeium.nvim", -- Copilot alternative for Neovim
  --   config = function()
  --     require("codeium").setup({
  --       -- Optionally disable cmp source if using virtual text only
  --       enable_cmp_source = false,
  --       virtual_text = {
  --         enabled = true,
  --
  --         -- These are the defaults
  --
  --         -- Set to true if you never want completions to be shown automatically.
  --         manual = false,
  --         -- A mapping of filetype to true or false, to enable virtual text.
  --         filetypes = {},
  --         -- Whether to enable virtual text of not for filetypes not specifically listed above.
  --         default_filetype_enabled = true,
  --         -- How long to wait (in ms) before requesting completions after typing stops.
  --         idle_delay = 75,
  --         -- Priority of the virtual text. This usually ensures that the completions appear on top of
  --         -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
  --         -- desired.
  --         virtual_text_priority = 65535,
  --         -- Set to false to disable all key bindings for managing completions.
  --         map_keys = true,
  --         -- The key to press when hitting the accept keybinding but no completion is showing.
  --         -- Defaults to \t normally or <c-n> when a popup is showing.
  --         accept_fallback = nil,
  --         -- Key bindings for managing completions in virtual text mode.
  --         key_bindings = {
  --           -- Accept the current completion.
  --           accept = "<Tab>",
  --           -- Accept the next word.
  --           accept_word = false,
  --           -- Accept the next line.
  --           accept_line = false,
  --           -- Clear the virtual text.
  --           clear = false,
  --           -- Cycle to the next completion.
  --           next = "<M-]>",
  --           -- Cycle to the previous completion.
  --           prev = "<M-[>",
  --         }
  --       }
  --     })
  --   end
  -- },
}
