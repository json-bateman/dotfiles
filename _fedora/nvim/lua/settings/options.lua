local g = vim.g
local opt = vim.opt

g.netrw_banner = 0
-- opt.hidden = false -- when false buffers are abandoned when unloaded
opt.autowrite = true -- writes the file when moving buffers
-- Colors
opt.termguicolors = true -- enables 24-bit RGB color for terminal
opt.hlsearch = false --turns off highlighting on search
---------------
-- Indenting
---------------
opt.expandtab = true -- insert mode puts in spaces when tabbing
opt.tabstop = 2 -- number of spaces a tab counts for
opt.softtabstop = 2 -- editing operations (like <BS>) are deleting 2 spaces
opt.shiftwidth = 2 -- number of spaces to use for each autoindent
opt.smartindent = true -- start autoindenting when starting a new line
opt.wrap = false -- makes it so text runs off the screen instead of wrapping
-----------------
-- Line Numbers
-----------------
opt.number = true -- sets number on side column
opt.relativenumber = true -- makes line number relative to cursor position
opt.numberwidth = 2 -- number column char width
opt.ruler = false -- show line and cursor position, redundant with lualine
opt.scrolloff = 10 -- scroll (x) lines from top and bottom
opt.signcolumn = "no" -- don't expand column on errors
---------------
-- Searching
---------------
opt.ignorecase = true -- can sEarch case ignoring caps
opt.incsearch = true -- jumps to what you're searching
opt.cursorline = true -- highlights current line
-- Mouse
opt.mouse = 'a'
-- living dangerously
vim.api.nvim_command("set noswapfile")

-- Don't automatically make more comments lines on enter
vim.api.nvim_create_autocmd("BufEnter",
  {
    callback = function() vim.opt.formatoptions =
      vim.opt.formatoptions - { "c", "r", "o" }
    end
  }
)

-- Force syntax on when entering every buffer
-- vim.api.nvim_create_autocmd("BufEnter",
--   {
--     callback = function()
--       vim.cmd [[syntax enable]]
--       vim.cmd [[syntax on]]
--     end
--   }
-- )
-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost",
  {
    callback = function() vim.highlight.on_yank { higroup = 'Question', timeout = 400 }
    end
  }
)
