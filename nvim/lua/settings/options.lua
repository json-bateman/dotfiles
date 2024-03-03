local g = vim.g
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

g.netrw_banner = 0
-- opt.hidden = false -- when false buffers are abandoned when unloaded
-- opt.autowrite = true -- writes the file when moving buffers, hidden has to be true
opt.hlsearch = false          -- turns off highlighting on search
opt.guicursor = "n-v-c:block" -- sets cursor to block or line depending on mode
---------------
-- Indenting
---------------
opt.expandtab = true   -- insert mode puts in spaces when tabbing
opt.tabstop = 2        -- number of spaces a tab counts for
opt.softtabstop = 2    -- editing operations (like <BS>) are deleting 2 spaces
opt.shiftwidth = 2     -- number of spaces to use for each autoindent
opt.smartindent = true -- start autoindenting when starting a new line
opt.wrap = false       -- makes it so text runs off the screen instead of wrapping
-----------------
-- Line Numbers
-----------------
opt.number = true     -- sets number on side column
opt.numberwidth = 2   -- number column char width
opt.ruler = false     -- show line and cursor position, redundant with lualine
opt.scrolloff = 10    -- scroll (x) lines from top and bottom
opt.signcolumn = "no" -- don't expand column on errors
---------------
-- Searching
---------------
opt.ignorecase = true  -- can sEarch case ignoring caps
opt.smartcase = true   -- if you use caps in search, assumes you meant it
opt.incsearch = true   -- jumps to what you're searching
opt.cursorline = false -- highlights current line
---------------
-- Folding
---------------
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldcolumn = '0' -- fold column
opt.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
---------------
-- living dangerously
---------------
vim.api.nvim_command("set noswapfile")
opt.mouse = 'a'

-- Don't automatically make more comments lines on enter
vim.api.nvim_create_autocmd("BufEnter",
   {
      callback = function()
         vim.opt.formatoptions =
             vim.opt.formatoptions - { "c", "r", "o" }
      end
   }
)

-- Unfold everything on buffer enter
-- vim.api.nvim_create_autocmd("BufEnter",
--   {
--     callback = function()
--       vim.cmd [[execute "normal! \zR"]]
--     end
--   }
-- )

-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost",
   {
      callback = function()
         vim.highlight.on_yank { higroup = 'Question', timeout = 400 }
      end
   }
)

-- vim.cmd [[au FocusLost * :wa]]
-- Watches if files have changed and puts them back in the buffer
-- vim.cmd [[au WinEnter,TabEnter,FocusGained * checktime]]
