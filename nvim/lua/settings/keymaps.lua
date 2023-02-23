local opts = { noremap = true, silent = true }

-- Shorten keymap nvim call
local keymap = vim.api.nvim_set_keymap
local ls = require("luasnip")

-- Rekeymap space as leader key
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

keymap("n", "<leader>E", "<cmd>edit $MYVIMRC<CR>", opts)
keymap("n", "<leader>W", "<cmd>w<CR><cmd>so%<CR>", opts)
keymap("n", "<leader>B", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", opts)
keymap("n", "<leader><leader>t", "<Plug>PlenaryTestFile", opts)
keymap("n", "<leader>cc", "<cmd>cclose<CR>", opts)
keymap("n", "<leader>co", "<cmd>copen<CR>", opts)
-- Window Movement
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<leader>v", "<cmd>vsplit<CR>", opts)
keymap("n", "<leader>V", "<cmd>Vexplore<CR>", opts)
keymap("n", "<leader>s", "<cmd>split<CR>", opts)
keymap("n", "<leader>S", "<cmd>Sex<CR>", opts)
keymap("n", "<leader>/", "<cmd>Neotree toggle<CR>", opts)
keymap("n", "<leader>q", "<cmd>Neotree <CR>", opts)
keymap("n", "<leader>Q", "<cmd>Neotree dir=%:p:h:h reveal_file=%:p<CR><CR>", opts)
keymap("n", "<leader>br", "<cmd>Neotree toggle buffers right<CR>", opts)
keymap("n", "<leader>git", "<cmd>Neotree float git_status<CR>", opts)
keymap("n", "<leader>u", "<cmd>UndotreeToggle | UndotreeFocus<CR>", opts)
-- Buffers and buffer movement
keymap("n", "<TAB>", "<cmd>bn<CR>", opts)
keymap("n", "<S-TAB>", "<cmd>bp<CR>", opts)
keymap("n", "<leader>d", "<cmd>bp | sp | bn | bd<CR>", opts)
keymap("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true })
keymap('n', '<leader>fh', "<cmd>Telescope help_tags<CR>", { noremap = true })
keymap("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { noremap = true })
keymap("n", "<leader>rg", "<cmd>Telescope live_grep<CR>", { noremap = true })
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { noremap = true })
keymap("n", "<leader>t", "<Plug>PlenaryTestFile", opts)
keymap("n", "<leader>T", "<cmd>botright vsplit | term <CR>a", opts)
-- Ufo
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- pasting from and yanking to "+ register (clipboard)
keymap("n", "<leader>p", '"+p', opts)
keymap("x", "<leader>p", '"+p', opts)
keymap("v", "<leader>y", '"+y', opts)

keymap("c", "%%", "<C-R>=expand('%:h')<CR>", opts)

keymap("t", "qq", '<C-\\><C-N>:q!<CR>', opts)
keymap("t", "<Esc>", '<C-\\><C-N>', opts)

-- Wrapper to look at tables (objects) with vim.inspect
function P(table)
   print(vim.inspect(table))
   return table
end

-- Snippets
vim.keymap.set({ "i", "s" }, "<c-j>", function()
   if ls.expand_or_jumpable() then
      ls.expand_or_jump()
   end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
   if ls.jumpable( -1) then
      ls.jump( -1)
   end
end, { silent = true })

vim.keymap.set("i", "<c-l>", function()
   if ls.choice_active() then
      ls.change_choice(1)
   end
end)

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/plugins/configs/snippets.lua<CR>")
