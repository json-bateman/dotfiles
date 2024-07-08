--[[
 ________
| |____| |
| plugin |
|  (__)  |
|________|
]]

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
-- Need this for colorizer
vim.opt.termguicolors = true -- enables 24-bit RGB color for terminal

require("lazy").setup({
   "tpope/vim-commentary",   -- gc to comment out "tpope/vim-surround",     -- easy text surrounding shortcuts
   "nanotee/luv-vimdocs",    -- puts lua docs into vim docs
   "milisims/nvim-luaref",   -- puts nvim-lua reference docs into vim docs
   "tpope/vim-fugitive",     -- In the words of Tpope "a git wrapper so awesome it should be illegal"
   "nvim-pack/nvim-spectre", -- Find and replace project-wide.
   "folke/neodev.nvim",      -- For Neovim API lua completion
})

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
         vim.highlight.on_yank { higroup = 'Question', timeout = 400 }
      end
   }
)

local g = vim.g
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
-----------------
-- Line Numbers
-----------------
opt.number = true      -- sets number on side column
opt.numberwidth = 2    -- number column char width
opt.ruler = false      -- show line and cursor position, redundant with lualine
opt.scrolloff = 10     -- scroll (x) lines from top and bottom
opt.signcolumn = "yes" -- don't expand column on errors
opt.cursorline = true  -- show a cursorline
---------------
-- Searching
---------------
opt.ignorecase = true  -- can sEarch case ignoring caps
opt.smartcase = true   -- if you use caps in search, assumes you meant it
opt.incsearch = true   -- jumps to what you're searching
opt.cursorline = false -- highlights current line

--[[
    ________
   | |____| |
   | keymap |
   |  (__)  |
   |________|
]]

local opts = { noremap = true, silent = true }

-- Shorten keymap nvim call
local keymap = vim.api.nvim_set_keymap
local ls = require("luasnip")

-- Space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes:
--   Normal       = "n"
--   Insert       = "i"
--   Visual       = "v"
--   Visual_Block = "x"
--   Terminal     = "t"
--   Command      = "c"

keymap("n", "<leader>E", "<CMD>edit $MYVIMRC<CR>", opts)
keymap("n", "<leader>W", "<CMD>w<CR><CMD>so%<CR>", opts)
keymap("n", "s", "<c-w>", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("c", "%%", "<C-R>=expand('%:h')<CR>", opts)
keymap("t", "qq", '<C-\\><C-N>:q!<CR>', opts)
keymap("t", "<Esc>", '<C-\\><C-N>', opts)
keymap("n", "<leader>t", "<CMD>botright vsplit | term <CR>a", opts)

-- Wrapper to look at tables (objects) with vim.inspect
function P(table)
   print(vim.inspect(table))
   return table
end

--[[
    ________
   | |____| |
   | styles |
   |  (__)  |
   |________|
]]
vim.cmd [[highlight CursorLine guibg=#282828]]
