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

keymap("n", "<leader>E", "<CMD>edit $MYVIMRC<CR>", opts)
keymap("n", "<leader>W", "<CMD>w<CR><CMD>so%<CR>", opts)
-- Window Movement
keymap("n", "<leader>cc", "<CMD>cclose<CR>", opts)
keymap("n", "<leader>co", "<CMD>copen<CR>", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<leader>v", "<CMD>vsplit<CR>", opts)
keymap("n", "<leader>s", "<CMD>split<CR>", opts)
keymap("n", "<leader>/", "<CMD>Neotree toggle<CR>", opts)
keymap("n", "<leader>q", "<CMD>Neotree <CR>", opts)
keymap("n", "<leader>Q", "<CMD>Neotree dir=%:p:h reveal_file=%:p<CR><CR>", opts)
keymap("n", "<leader>br", "<CMD>Neotree toggle buffers right<CR>", opts)
keymap("n", "<leader>git", "<CMD>Neotree float git_status<CR>", opts)
keymap("n", "<leader>bo", "<CMD>%bd|e#|bd#<CR>", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { noremap = true })
keymap('n', '<leader>fh', "<CMD>Telescope help_tags<CR>", { noremap = true })
keymap("n", "<leader>fg", "<CMD>Telescope git_files<CR>", { noremap = true })
keymap("n", "<leader>rg", "<CMD>Telescope live_grep<CR>", { noremap = true })
keymap("n", "<leader>fd", "<CMD>Telescope diagnostics<CR>", { noremap = true })
keymap("n", "<leader><leader>t", "<Plug>PlenaryTestFile", opts)
keymap("n", "<leader>t", "<CMD>botright vsplit | term <CR>a", opts)
-- Ufo
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- Spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>')
-- Git
keymap("n", "ga", "<CMD>diffget //2<cr>", {})
keymap("n", "g;", "<CMD>diffget //3<cr>", {})
keymap("n", "<leader>gb", "<CMD>Gitsigns toggle_current_line_blame<CR>", {})
-- Harpoon
keymap("n", "<leader>a", "<CMD>lua require('harpoon.mark').add_file()<CR>", {})
keymap("n", "<leader>0", "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>", {})
keymap("n", "<leader>1", "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", {})
keymap("n", "<leader>2", "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", {})
keymap("n", "<leader>3", "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", {})
keymap("n", "<leader>4", "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", {})
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
   if ls.jumpable(-1) then
      ls.jump(-1)
   end
end, { silent = true })

vim.keymap.set("i", "<c-l>", function()
   if ls.choice_active() then
      ls.change_choice(1)
   end
end)

vim.keymap.set("n", "<leader><leader>s", "<CMD>source ~/.config/nvim/lua/plugins/configs/snippets.lua<CR>")
