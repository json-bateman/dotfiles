--[[
 ________
| |____| |
| keymap |
|  (__)  |
|________|

]]

--[[
  Modes:
    Normal       = "n"
    Insert       = "i"
    Visual       = "v"
    Visual_Block = "x"
    Terminal     = "t"
    Command      = "c"
]]

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>E", "<CMD>edit $MYVIMRC<CR>", opts)
keymap("n", "<leader>W", "<CMD>w<CR><CMD>so%<CR>", opts)
-- Netrw is disabled when Oil.nvim plugin is intalled
-- keymap("n", "<leader>/", "<CMD>Ex<CR>", opts)
keymap("n", "s", "<c-w>", opts)
keymap("n", "<leader>cc", "<CMD>cclose<CR>", opts)
keymap("n", "<leader>co", "<CMD>copen<CR>", opts)
keymap("n", "<leader>cj", "<CMD>clearjumps<CR>", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<leader>cj", "<CMD>clearjumps<CR>", opts)
keymap("c", "%%", "<C-R>=expand('%:h')<CR>", opts)
keymap("t", "qq", "<C-\\><C-N>:q!<CR>", opts)
keymap("t", "<leader><Esc>", "<C-\\><C-N>", opts)
keymap("n", "<leader>tt", "<CMD>tabnew<CR>", opts)
keymap("n", "<leader>tn", "<CMD>tabnext<CR>", opts)
keymap("n", "<leader>tp", "<CMD>tabprevious<CR>", opts)
keymap("n", "<leader>tc", "<CMD>tabclose<CR>", opts)
keymap("n", "<leader>to", "<CMD>tabonly<CR>", opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>p", '"+p', opts)
keymap("v", "<leader>p", '"+p', opts)
-- Follow the change history of the current file
keymap("n", "<leader>gh", "<CMD>Git log -p %<CR>", opts)

-- Temporary manual fold creation with zF, need this when foldmethod is not manual
-- vim.keymap.set("v", "zF", function()
-- 	local old_foldmethod = vim.wo.foldmethod
-- 	vim.wo.foldmethod = "manual"
-- 	vim.cmd("normal! zF")
-- 	vim.wo.foldmethod = old_foldmethod -- Revert to the previous method
-- end, { silent = true, desc = "Temporary manual fold creation" })

keymap("n", "gs", ":%s~~", opts)
keymap("v", "gs", ":s~~", opts)
