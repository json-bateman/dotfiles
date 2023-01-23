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

require("lazy").setup({
  "nvim-lua/plenary.nvim", -- Avoids callbacks, used by other plugins
  "nvim-lua/popup.nvim", -- Popup for other plugins
  "nvim-treesitter/nvim-treesitter", -- Language parsing completion engine
  "tpope/vim-commentary", -- gc to comment out
  "tpope/vim-surround", -- easy text surrounding shortcuts
  "ellisonleao/gruvbox.nvim", -- The groooviest box
  "tjdevries/colorbuddy.nvim", -- Changing colors easily
  {
    "williamboman/mason.nvim", -- UI for fetching/downloading LSPs
    config = function()
      require("mason").setup()
     end,
  },
  {
    "williamboman/mason-lspconfig.nvim", -- Bridges mason and lspconfig
    config = function()
      require("mason-lspconfig").setup ({
        ensure_installed = { "sumneko_lua", "rust_analyzer" }
      })
    end,
  },
  "neovim/nvim-lspconfig", -- neovims configuation for the built in client
  "hrsh7th/nvim-cmp", -- nvim completion
  "hrsh7th/cmp-nvim-lsp", -- lsp completion
  "hrsh7th/cmp-buffer", -- completion from words inside your buffer
  "L3MON4D3/LuaSnip", -- More snippets
  "saadparwaiz1/cmp_luasnip", -- luasnip completion
  "onsails/lspkind.nvim", -- pictograms for completion
  {
    "nvim-lualine/lualine.nvim",
    config = function()
    end,
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
      require('neo-tree').setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        window = {
          position = "left",
          width = 35,
        },
      })
    end,
  },
})
