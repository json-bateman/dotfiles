-- -- Making a language server
-- vim.lsp.set_log_level("debug")
-- local client = vim.lsp.start_client {
--   cmd = { "/Users/jack/Coding/customlsp/customlsp" }
-- }
--
-- if not client then
--   vim.notify "hey you didn't do the client thing good"
--   return
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.lsp.buf_attach_client(0, client)
--   end,
-- })

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

vim.opt.termguicolors = true -- enables 24-bit RGB color for terminal
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })

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

require("option")
require("keymaps")
require("styles")
require("custom")

-- Trying to make a custom plugin
require("d")
