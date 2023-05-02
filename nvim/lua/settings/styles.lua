-- local colorscheme = 'gruvbox'

local ok, onedark = pcall(require, 'onedark')
if not ok then return end

onedark.setup {
   style = 'darker'
}

onedark.load()

-- local ok, _ = pcall(vim.api.nvim_command, "colorscheme " .. colorscheme)
-- if not ok then return end

local present, colorbuddy = pcall(require, 'colorbuddy')
if not present then return end

-- Folds and fold column matches gruvbox background
-- vim.cmd[[highlight FoldColumn guibg=#282828]]
vim.cmd [[highlight Folded guibg=#282828]]
vim.cmd [[highlight CursorLine guibg=#282828]]

-- Fugitive
vim.cmd [[hi DiffAdd gui=NONE guifg=orange guibg=NONE]]
vim.cmd [[hi DiffChange gui=NONE guifg=orange guibg=NONE]]
vim.cmd [[hi DiffDelete gui=NONE guifg=red guibg=NONE]]
vim.cmd [[hi DiffText gui=NONE guifg=green guibg=NONE]]

local Color, colors, Group, _, styles = colorbuddy.setup()

-- Use Color.new(<name>, <#rrggbb>) to create new colors
-- They can be accessed through colors.<name>
Color.new('dark_blue', '#225577')
Color.new('purple', '#7788dd')
Color.new('background', '#282c34')
Color.new('dark_gray', '#666677')
Color.new('gruv_green', '#b8bb26')
Color.new('red', '#cc6666')
Color.new('light_green', '#99ec99')
Color.new('yellow', '#cc9966')

Group.new('Function', colors.gruv_green, nil, styles.bold)
-- Group.new('luaFunctionCall', groups.Function, groups.Function, groups.Function)
Group.new('Comment', colors.dark_gray, nil, styles.italic)
Group.new('String', colors.gruv_green, nil, styles.none)
