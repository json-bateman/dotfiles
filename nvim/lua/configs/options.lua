--[[
 ________
| |____| |
| option |
|  (__)  |
|________|
]]
local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

-- g.netrw_liststyle = 3 -- changes the way netrw displays folders
opt.swapfile = false -- turn off swapfile, make sure to save! :>
g.netrw_banner = 0   -- don't show info screen at top of netrw
opt.hidden = true    -- when false buffers are abandoned when unloaded
opt.autowrite = true -- writes the file when moving buffers, hidden has to be true
opt.hlsearch = false -- turns off highlighting on search
---------------
-- Indenting
---------------
opt.expandtab = true   -- insert mode puts in spaces when tabbing
opt.tabstop = 4        -- number of spaces a tab counts for
opt.softtabstop = 4    -- editing operations (like <BS>) are deleting 2 spaces
opt.shiftwidth = 4     -- number of spaces to use for each autoindent
opt.smartindent = true -- start autoindenting when starting a new line
opt.wrap = false       -- makes it so text runs off the screen instead of wrapping
-- opt.mouse = ""         -- nice when SSHing, turns mouse off and allows copying directly from vim to clipboard
-----------------
-- Line Numbers
-----------------
opt.signcolumn = "yes" -- always show signcolumn
opt.number = true      -- sets numbers on side column
opt.numberwidth = 2    -- number column char width
opt.rnu = true         -- relative line number
opt.nu = true          -- shows current line number
opt.ruler = true       -- show line and cursor position, redundant with lualine
opt.scrolloff = 10     -- scroll (x) lines from top and bottom
opt.cursorline = true  -- show a cursorline
---------------
-- Searching
---------------
opt.ignorecase = true -- can sEarch case ignoring caps
opt.smartcase = true  -- if you use caps in search, assumes you meant it
opt.incsearch = true  -- jumps to what you're searching
---------------
-- Misc
---------------
vim.opt.cedit = '<C-a>'                       -- Use in command line to edit queries in a normal mode window
vim.o.foldmethod = 'expr'                     -- When foldmethod is expr, foldexpr is run
vim.o.foldexpr = 'nvim_treesitter#foldexpr()' -- this function is executed for every line in the buffer
vim.o.foldlevelstart = 99                     -- No folds closed to start
