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
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Need this for colorizer
vim.opt.termguicolors = true -- enables 24-bit RGB color for terminal

require("lazy").setup({
   "nvim-lua/plenary.nvim", -- Avoids callbacks, used by other plugins
   "nvim-lua/popup.nvim", -- Popup for other plugins
   "tpope/vim-commentary", -- gc to comment out
   "tpope/vim-surround", -- easy text surrounding shortcuts
   "ellisonleao/gruvbox.nvim", -- The groooviest box
   "tjdevries/colorbuddy.nvim", -- Changing colors easily
   "onsails/lspkind.nvim", -- pictograms for completion
   "L3MON4D3/LuaSnip", -- More snippets
   "nvim-telescope/telescope.nvim", -- Grep and fuzzy find with UI
   "rafamadriz/friendly-snippets", -- Big collection of snippets
   "kkharji/sqlite.lua",
   ---------------------------
   -- plugins with extra options
   ---------------------------
   {
      "kdheepak/lazygit.nvim", -- lazygit, a cool git interface
      cmd = "LazyGit",
   },
   {
      "mbbill/undotree",
      cmd = "UndotreeToggle",
   },
   {
      "norcalli/nvim-colorizer.lua",
      config = function()
         require("plugins.configs.colorizer")
      end,
   },
   {
      "nvim-treesitter/nvim-treesitter", -- Language parsing completion engine
      config = function()
         require("plugins.configs.treesitter")
      end,
   },
   { "iamcco/markdown-preview.nvim",
      build = "cd app && npm install",
      init = function() vim.g.mkdp_filetypes = { "markdown" } end,
      ft = { "markdown" }, },
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
            ensure_installed = { "jdtls", "tsserver", "jsonls", "html", "cssls", "solargraph", "yamlls", "sumneko_lua",
               "rust_analyzer" }
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
      "luukvbaal/statuscol.nvim",
      config = function()
         require("statuscol").setup(
            {
               foldfunc = "builtin",
               setopt = true
            }
         )
      end,
   },
   { 'kevinhwang91/nvim-ufo',
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
      event = "BufAdd",
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
      keys = {
         { "<leader>/", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      },
      config = function()
         require("plugins.configs.neotree")
      end,
   },
})
