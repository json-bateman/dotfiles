-- Bootstrap Lazy, the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

vim.opt.termguicolors = true -- enables 24-bit RGB color for terminal
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })

require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false }, -- Checks if plugins are available for updating.
	change_detection = { enabled = false },
})

--[[
Other configurations
Found in: ~/.config/nvim/lua
nvim runtime path looks in /lua folder to load other files
]]

require("custom")
require("options")
require("keymaps")
require("styles")
