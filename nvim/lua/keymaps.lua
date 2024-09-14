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
-- Netrw is disabled when Oil.nvim plugin is intalled
-- keymap("n", "<leader>/", "<CMD>Ex<CR>", opts)
keymap("n", "<leader>q", "<CMD>q<CR>", opts)
keymap("n", "s", "<c-w>", opts)
keymap("n", "<leader>cc", "<CMD>cclose<CR>", opts)
keymap("n", "<leader>co", "<CMD>copen<CR>", opts)
keymap("n", "<leader>cj", "<CMD>clearjumps<CR>", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<leader>cj", "<CMD>clearjumps<CR>", opts)
keymap("c", "%%", "<C-R>=expand('%:h')<CR>", opts)
keymap("t", "qq", '<C-\\><C-N>:q!<CR>', opts)
keymap("t", "<Esc>", '<C-\\><C-N>', opts)
keymap("n", "<leader>tv", "<CMD>botright vsplit | term <CR>a", opts)
keymap("n", "<leader>term", "<CMD>tabnew | term<CR>a", opts)
keymap("n", "<leader>tt", "<CMD>tabnew<CR>", opts)
keymap("n", "<leader>tn", "<CMD>tabnext<CR>", opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>p", '"+p', opts)
keymap("n", "<c-k>", "5k", opts)
keymap("n", "<c-j>", "5j", opts)


-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Harpoon
local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)


-- Wrapper to look at tables (objects) with vim.inspect
function P(table)
  print(vim.inspect(table))
  return table
end
