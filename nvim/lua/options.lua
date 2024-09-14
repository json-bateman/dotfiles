--[[
 ________
| |____| |
| option |
|  (__)  |
|________|
]]
-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost",
  {
    callback = function()
      vim.highlight.on_yank { higroup = 'Question', timeout = 300 }
    end
  }
)

local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

g.netrw_banner = 0
-- g.netrw_liststyle = 3 -- changes the way netrw displays folders
-- opt.hidden = false    -- when false buffers are abandoned when unloaded
-- opt.autowrite = true  -- writes the file when moving buffers, hidden has to be true
opt.hlsearch = false -- turns off highlighting on search
---------------
-- Indenting
---------------
opt.expandtab = true   -- insert mode puts in spaces when tabbing
opt.tabstop = 2        -- number of spaces a tab counts for
opt.softtabstop = 2    -- editing operations (like <BS>) are deleting 2 spaces
opt.shiftwidth = 2     -- number of spaces to use for each autoindent
opt.smartindent = true -- start autoindenting when starting a new line
opt.wrap = false       -- makes it so text runs off the screen instead of wrapping
-- opt.mouse = ""         -- nice when SSHing, turns mouse off and allows copying directly from vim to clipboard
-----------------
-- Line Numbers
-----------------
opt.signcolumn = "yes"
opt.number = true     -- sets numbers on side column
opt.numberwidth = 2   -- number column char width
opt.ruler = false     -- show line and cursor position, redundant with lualine
opt.scrolloff = 10    -- scroll (x) lines from top and bottom
opt.cursorline = true -- show a cursorline
---------------
-- Searching
---------------
opt.ignorecase = true -- can sEarch case ignoring caps
opt.smartcase = true  -- if you use caps in search, assumes you meant it
opt.incsearch = true  -- jumps to what you're searching

-- Don't automatically make more comments lines on enter
vim.api.nvim_create_autocmd("BufEnter",
  {
    callback = function()
      vim.opt.formatoptions =
          vim.opt.formatoptions - { "c", "r", "o" }
    end
  }
)
