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
   "nvim-lua/plenary.nvim",         -- Avoids callbacks, used by other plugins
   "nvim-lua/popup.nvim",           -- Popup for other plugins
   "tpope/vim-commentary",          -- gc to comment out
   "tpope/vim-surround",            -- easy text surrounding shortcuts
   "onsails/lspkind.nvim",          -- pictograms for completion
   "L3MON4D3/LuaSnip",              -- More snippets
   "nvim-telescope/telescope.nvim", -- Grep and fuzzy find with UI
   "nanotee/luv-vimdocs",           -- puts lua docs into vim docs
   "milisims/nvim-luaref",          -- puts nvim-lua reference docs into vim docs
   "tpope/vim-fugitive",            -- In the words of Tpope "a git wrapper so awesome it should be illegal"
   "ThePrimeagen/harpoon",          -- Blazingly Fast(tm) file switching
   "tjdevries/colorbuddy.nvim",     -- Changing colors easily
   "ellisonleao/gruvbox.nvim",      -- The groooviest box
   "navarasu/onedark.nvim",         -- The darkest one
   "andweeb/presence.nvim",         -- Shows Neovim on discord for weird flexing purposes
   "nvim-pack/nvim-spectre",        -- Find and replace project-wide.
   ---------------------------
   -- plugins with extra options
   ---------------------------
   {
      "nvim-treesitter/nvim-treesitter", -- Language parsing completion engine
      config = function()
         require("plugins.configs.treesitter")
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
