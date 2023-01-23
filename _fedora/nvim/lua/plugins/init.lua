local fn = vim.fn
-- Automatically install packer on initial startup
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_Bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
  print "---------------------------------------------------------"
  print "Press Enter to install packer and plugins."
  print "After install -- close and reopen Neovim to load configs!"
  print "---------------------------------------------------------"
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call
local present, packer = pcall(require, "packer")

if not present then
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
  use 'nvim-lua/plenary.nvim' -- Avoids callbacks, used by other plugins
  use 'nvim-lua/popup.nvim' -- Popup for other plugins
  use 'lewis6991/impatient.nvim' -- Compiles lua files to bytecode and caches them
  use 'nvim-treesitter/nvim-treesitter' -- Language parsing completion engine || commit = '4cccb6f494eb255b32a290d37c35ca12584c74d0'
  use "williamboman/mason.nvim" -- UI for fetching/downloading LSPs
  use "williamboman/mason-lspconfig.nvim" -- Bridges mason and lspconfig
  use "neovim/nvim-lspconfig" -- neovims configuation for the built in client
  use 'hrsh7th/nvim-cmp' -- Vim completion engine
  use 'L3MON4D3/LuaSnip' -- More snippets
  use 'saadparwaiz1/cmp_luasnip' -- Even more snippets
  use 'hrsh7th/cmp-nvim-lsp' -- Cmp's own LSP
  use 'hrsh7th/cmp-buffer' -- Cmp source for buffer words
  use 'hrsh7th/cmp-path' -- Cmp source for path words
  use "hrsh7th/cmp-cmdline" -- Cmp source for command line
  use "mfussenegger/nvim-dap" -- Debug Adapter Protocol
  use "rcarriga/nvim-dap-ui"
  use "theHamsta/nvim-dap-virtual-text"
  use "nvim-telescope/telescope-dap.nvim"
  use "mxsdev/nvim-dap-vscode-js"
  use {
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npm run compile",
  }
  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  -- use { 'glepnir/lspsaga.nvim', branch = "main" } -- stylized popup window
  use "rafamadriz/friendly-snippets"
  use {
    "nvim-telescope/telescope.nvim",
    after = "nvim-cmp",
  }
  use { "nvim-neo-tree/neo-tree.nvim", -- Directory listing tree
    branch = "v2.x",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }
  use "nvim-lualine/lualine.nvim" -- Tab line top and bottom
  use 'tpope/vim-commentary' -- gc to comment out
  use 'tpope/vim-surround' -- easy text surrounding shortcuts
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'ThePrimeagen/vim-be-good' -- Prime's fun plugin :>
  use 'tjdevries/colorbuddy.nvim' -- Adding colors fast
  use 'norcalli/nvim-colorizer.lua' -- Highlights color codes
  use 'gruvbox-community/gruvbox' -- Color schemes
  use { 'Everblush/everblush.nvim', as = 'everblush' }
  use 'tanvirtin/monokai.nvim'
  -- GPT-3 for code snippets
  use({
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
        -- optional configuration
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  })
  -- Rust
  use 'simrat39/rust-tools.nvim'

  if Packer_Bootstrap then
    require('packer').sync()
  end
end)
