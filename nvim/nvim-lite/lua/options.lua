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

g.netrw_banner = 0
-- opt.hidden = false -- when false buffers are abandoned when unloaded
-- opt.autowrite = true -- writes the file when moving buffers, hidden has to be true
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
opt.mouse = "a"
-----------------
-- Line Numbers
-----------------
opt.number = true      -- sets numbers on side column
opt.numberwidth = 2    -- number column char width
opt.rnu = true         -- relative line number
opt.nu = true          -- shows current line number
opt.ruler = true       -- show line and cursor position
opt.scrolloff = 10     -- scroll (x) lines from top and bottom
opt.cursorline = true  -- show a cursorline
---------------
-- Searching
---------------
opt.ignorecase = true  -- can sEarch case ignoring caps
opt.smartcase = true   -- if you use caps in search, assumes you meant it
opt.incsearch = true   -- jumps to what you're searching
