-- Wrapper to look at tables (objects) with vim.inspect
function P(table)
  print(vim.inspect(table))
  return table
end

-- Move through the quickfix list
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set('n', '<C-n>', '<cmd>cn<CR>zz<cmd>wincmd p<CR>', opts)
    vim.keymap.set('n', '<C-p>', '<cmd>cN<CR>zz<cmd>wincmd p<CR>', opts)
  end,
})

-- Don't automatically make more comments lines on enter
vim.api.nvim_create_autocmd("BufEnter",
  {
    callback = function()
      vim.opt.formatoptions =
          vim.opt.formatoptions - { "c", "r", "o" }
    end
  }
)

-- -- Write file when moving between splits
-- vim.api.nvim_create_autocmd("BufLeave",
--   {
--     command = 'wall'
--   }
-- )

-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost",
  {
    callback = function()
      vim.highlight.on_yank { higroup = 'Question', timeout = 300 }
    end
  }
)

-- Write and quit typos
local typos = { 'W', 'Wq', 'WQ', 'Wqa', 'WQa', 'WQA', 'WqA', 'Q', 'Qa', 'QA' }
for _, cmd in ipairs(typos) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    vim.api.nvim_cmd({
      cmd = cmd:lower(),
      bang = opts.bang,
      mods = { noautocmd = true },
    }, {})
  end, { bang = true })
end
