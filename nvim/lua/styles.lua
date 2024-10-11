--[[
 ________
| |____| |
| styles |
|  (__)  |
|________|

]]

-- require('onedark').setup {
--   -- Dark, Darker, Cool, Deep, Warm, Warmer
--   style = "darker",
-- }
-- require('onedark').load()

-- Default options:
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,    -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

-- -- Default options
-- require('nightfox').setup({
--   options = {
--     -- Compiled file's destination location
--     compile_path = vim.fn.stdpath("cache") .. "/nightfox",
--     compile_file_suffix = "_compiled", -- Compiled file suffix
--     transparent = false,               -- Disable setting background
--     terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
--     dim_inactive = false,              -- Non focused panes set to alternative background
--     module_default = true,             -- Default enable value for modules
--     colorblind = {
--       enable = false,                  -- Enable colorblind support
--       simulate_only = false,           -- Only show simulated colorblind colors and not diff shifted
--       severity = {
--         protan = 0,                    -- Severity [0,1] for protan (red)
--         deutan = 0,                    -- Severity [0,1] for deutan (green)
--         tritan = 0,                    -- Severity [0,1] for tritan (blue)
--       },
--     },
--     styles = {           -- Style to be applied to different syntax groups
--       comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
--       conditionals = "NONE",
--       constants = "NONE",
--       functions = "NONE",
--       keywords = "NONE",
--       numbers = "NONE",
--       operators = "NONE",
--       strings = "NONE",
--       types = "NONE",
--       variables = "NONE",
--     },
--     inverse = { -- Inverse highlight for different types
--       match_paren = false,
--       visual = false,
--       search = false,
--     },
--     modules = { -- List of various plugins and additional options
--       -- ...
--     },
--   },
--   palettes = {},
--   specs = {},
--   groups = {},
-- })

-- setup must be called before loading
vim.cmd("colorscheme gruvbox")



-- built in highlight groups
vim.cmd [[
  highlight CursorLineNR guifg=orange gui=NONE
  highlight LineNr guifg=#1e3f2a guibg=NONE
  highlight clear SignColumn
]]

-- Define highlight groups for custom elements
vim.cmd [[
  highlight MyJSXElement guifg=#f5d784
  highlight MyReactComponent guifg=#f5d784
]]

-- Link JSX tags to the highlight group
vim.api.nvim_set_hl(0, '@tag', { link = 'MyJSXElement' })
