local g = vim.g
local opt = vim.opt

g.netrw_banner = 0
g.netrw_liststyle = 3
-- Colors
opt.termguicolors = true -- enables 24-bit RGB color in TUI
opt.hlsearch = false -- turns off highlighting all words on search
-- Indenting
opt.expandtab = true -- insert mode puts in spaces when tabbing
opt.tabstop = 2 -- number of spaces a tab counts for
opt.softtabstop = 2 -- editing operations (like <BS>) are deleting 2 spaces
opt.shiftwidth = 2 -- number of spaces when you tab or indent
opt.smartindent = true -- indent correctly inside code blocks
opt.wrap = false -- don't wrap text when offscreen
-- Line Numbers & Side Column
opt.relativenumber = true -- line number relative to cursor
opt.number = true -- number on side column
opt.numberwidth = 2 -- number column width
opt.ruler = false -- show line and cursor position, redundant with lualine
opt.scrolloff = 10 -- scroll (x) lines from top and bottom
opt.signcolumn = "no" -- don't expand column on errors
-- Searching
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

-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost",
  {
    callback = function() vim.highlight.on_yank { higroup = 'Question', timeout = 400 }
    end
  }
)
