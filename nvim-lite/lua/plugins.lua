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
   "tpope/vim-commentary",     -- gc to comment out "tpope/vim-surround"
   "nanotee/luv-vimdocs",      -- puts lua docs into vim docs
   "tpope/vim-fugitive",       -- In the words of Tpope "a git wrapper so awesome it should be illegal"
   "ellisonleao/gruvbox.nvim", -- To get groovy
   "ibhagwan/fzf-lua",         -- fzf-ing around
   "nvim-tree/nvim-web-devicons", -- icons for files, etc.
   "nvim-telescope/telescope.nvim" -- TJ's fuzzy finder
 })
