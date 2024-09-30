--[[
 ________
| |____| |
| plugin |
|  (__)  |
|________|
]]

-- Bootstrap Lazy, the plugin manager
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
-- Space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false }, -- Checks if plugins are available for updating.
})

--[[
Other configurations
Found in: ~/config/nvim/lua
nvim runtime path looks in /lua folder to load other files
]]

require("options")
require("keymaps")
require("styles")
