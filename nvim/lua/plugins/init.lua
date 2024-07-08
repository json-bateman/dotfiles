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
   "nvim-lua/plenary.nvim",  -- Avoids callbacks, used by other plugins
   "nvim-lua/popup.nvim",    -- Popup for other plugins
   "tpope/vim-commentary",   -- gc to comment out
   "tpope/vim-surround",     -- easy text surrounding shortcuts
   "onsails/lspkind.nvim",   -- pictograms for completion
   "L3MON4D3/LuaSnip",       -- More snippets
   "nanotee/luv-vimdocs",    -- puts lua docs into vim docs
   "milisims/nvim-luaref",   -- puts nvim-lua reference docs into vim docs
   "tpope/vim-fugitive",     -- In the words of Tpope "a git wrapper so awesome it should be illegal"
   "ThePrimeagen/harpoon",   -- Blazingly Fast(tm) file switching
   "navarasu/onedark.nvim",  -- The darkest one
   "catppuccin/nvim",        -- Pretty Cat theme for nvim
   "andweeb/presence.nvim",  -- Shows Neovim on discord for weird flexing purposes
   "nvim-pack/nvim-spectre", -- Find and replace project-wide.
   "folke/neodev.nvim",      -- For Neovim API lua completion
   ---------------------------
   -- plugins with extra options
   ---------------------------
   {
      "rcarriga/nvim-dap-ui",  -- Provides a UI for debugging
      dependencies = {
         "leoluz/nvim-dap-go", -- Pluging to attach to go debugger Delve
         "theHamsta/nvim-dap-virtual-text",
         "mfussenegger/nvim-dap",
      },
      config = function()
         local dap_ok, dap = pcall(require, "dap")
         if not dap_ok then
            print("dap not found!")
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


         local dap_ui_ok, dap_ui = pcall(require, "dapui")
         if not dap_ui_ok then
            print("nvim-dap-ui not found!")
            return
         end

         local dap_vars_ok, dap_vars = pcall(require, "dap.ui.variables")
         if not dap_vars_ok then
            print("dap.ui.variables not found!")
            return
         end

         dap_text.setup()
         dap_go.setup()
         dap_ui.setup()

         dap.configurations.go = {
            {
               type = 'go',
               name = 'Debug',
               request = 'launch',
               program = "${fileDirname}",
            },
         }

         --- Debugging Keymaps ---
         local keymap = vim.keymap.set
         --- Start Debugging Session ---
         keymap("n", "<F1>", function() dap.continue() end)
         keymap("n", "<F2>", function() dap.step_over() end)
         keymap("n", "<F3>", function() dap.step_into() end)
         keymap("n", "<F4>", function() dap.step_out() end)
         keymap("n", "<space>B", function() dap.toggle_breakpoint() end)
         keymap("n", "<space>C", function() dap.clear_breakpoints() end)
         keymap("n", "<space>di", function() dap_vars.hover() end)
         --- End Debugging Session ---
         keymap("n", "<F5>", function()
            dap.clear_breakpoints()
            dap.terminate()
            print("Debugger session ended")
         end)
      end
   },
   {
      "nvim-treesitter/nvim-treesitter", -- Language parsing completion engine
      config = function()
         require("plugins.configs.treesitter")
      end,
   },
   {
      "nvim-telescope/telescope.nvim", -- Grep and fuzzy find with UI
      config = function()
         require("plugins.configs.telescope")
      end,
   },
   {
      "lewis6991/gitsigns.nvim",
      config = function()
         require("gitsigns").setup()
      end,
   },
   {
      'ibhagwan/fzf-lua',
      requires = { 'nvim-tree/nvim-web-devicons' }
   },
   {
      "norcalli/nvim-colorizer.lua",
      config = function()
         require("plugins.configs.colorizer")
      end,
   },
   {
      "iamcco/markdown-preview.nvim",
      build = "cd app && npx --yes yarn install",
      init = function() vim.g.mkdp_filetypes = { "markdown" } end,
      ft = { "markdown" },
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
               "solidity",
            }
         })
      end,
   },
   {
      "neovim/nvim-lspconfig", -- neovims configuation for the built in client
      config = function()
         require("plugins.configs.lspconfig")
      end
   },
   {
      'kevinhwang91/nvim-ufo',
      dependencies = 'kevinhwang91/promise-async',
      config = function()
         require("plugins.configs.ufo")
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
         "saadparwaiz1/cmp_luasnip", -- luasnip completion
      },
      config = function()
         require("plugins.configs.cmp")
      end,
   },
   {
      "nvim-lualine/lualine.nvim",
      event = "BufReadPost",
      config = function()
         require("plugins.configs.lualine")
      end
   },
   {
      "nvim-neo-tree/neo-tree.nvim", -- Directory tree
      dependencies = {
         "kyazdani42/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
      },
      config = function()
         require("plugins.configs.neotree")
      end,
   },
})
