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
  { "iamcco/markdown-preview.nvim", build = "cd app && npm install", init = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, },
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
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            with_text = false,
            maxwidth = 50,
            mode = "symbol_text",
            menu = {
              buffer = "BUF",
              rg = "RG",
              nvim_lsp = "LSP",
              path = "PATH",
              luasnip = "SNIP",
              calc = "CALC",
            },
          }),
        },
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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer", keyword_length = 5 },
          { name = "luasnip" },
          { name = "calc" },
          { name = "path" },
          { name = "rg", keyword_length = 5 },
        },
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  "onsails/lspkind.nvim", -- pictograms for completion
  "saadparwaiz1/cmp_luasnip", -- luasnip completion
  "L3MON4D3/LuaSnip", -- More snippets
  {
    "nvim-lualine/lualine.nvim",
    event = "BufEnter",
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
