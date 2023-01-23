local opt = vim.opt

opt.cursorcolumn = true

-- YAML suggests using 2 spaces for indentation, but 4 will work
opt.tabstop = 2 -- number of spaces a tab counts for
opt.softtabstop = 2 -- editing operations (like <BS>) are deleting 2 spaces
opt.shiftwidth = 2

-- local colorscheme = "monokai"
-- local ok, _ = pcall(vim.api.nvim_command, "colorscheme " .. colorscheme)
-- if not ok then
--   print("error setting colorscheme")
-- end
