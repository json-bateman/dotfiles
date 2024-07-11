local ok, oneDark = pcall(require, "onedark")
if not ok then return end

oneDark.setup({})
oneDark.load()

-- Folds and fold column matches gruvbox background
-- vim.cmd[[highlight FoldColumn guibg=#282828]]
vim.cmd [[highlight Folded guibg=#282828]]
vim.cmd [[highlight CursorLine guibg=#282828]]
-- vim.cmd [[highlight Normal guibg=#000]]

-- Fugitive
-- vim.cmd [[hi DiffAdd gui=NONE guifg=#FFe580 guibg=NONE]]
-- vim.cmd [[hi DiffChange gui=NONE guifg=NONE guibg=NONE]]
-- vim.cmd [[hi DiffDelete gui=NONE guifg=red guibg=NONE]]
-- vim.cmd [[hi DiffText gui=NONE guifg=green guibg=NONE]]
