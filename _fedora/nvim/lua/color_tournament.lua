local popup = require("plenary.popup")

local M = {}

local config = {
  window_width = math.ceil((vim.o.columns) * (6 / 16)),
  window_height = vim.o.lines - 8,
}

-- M._stack = {}

-- M.pop = function(name)
--   local state = M._stack[name]
--   M._stack[name] = nil
-- end

M.setup = function(opts)
  print('Options: ', opts)
end

local function create_window_1()
  local width = config.window_width
  local height = config.window_height
  local current_buf = vim.api.nvim_get_current_buf()
  -- local bufnr = vim.api.nvim_create_buf(false, false)

  local window_id, win = popup.create(current_buf, {
    title = "Color Tournament Window 1",
    highlight = "Highlight",
    line = 4,
    col = math.floor((vim.o.columns) * (1 / 16)),
    minwidth = width,
    maxheight = height,
    border = true,
  })
end

local function create_window_2()
  local width = config.window_width
  local height = config.window_height
  local current_buf = vim.api.nvim_get_current_buf()

  local window_id, win = popup.create(current_buf, {
    title = "Color Tournament Window 2",
    highlight = "Highlight",
    line = 4,
    col = math.floor((vim.o.columns) * (9 / 16)),
    minwidth = width,
    maxheight = height,
    border = true,
  })
end

create_window_2()
create_window_1()

return M
--[[
a 
long
string
of 
comments
]]
