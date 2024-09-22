local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  print("dap not found!")
  return
end
local widgets_ok, widgets = pcall(require, "dap.ui.widgets")
if not widgets_ok then
  print("widgets not found!")
  return
end

local dap_text_ok, dap_text = pcall(require, "nvim-dap-virtual-text")
if not dap_text_ok then
  print("nvim-dap-virtual-text not found!")
  return
end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  print("nvim-dap-ui not found!")
  return
end

dapui.setup()
dap_text.setup({})

--- Adapters (see :h dap-adapter) ---
dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  },
}

--- Configurations (see :h dap-configuration) ---

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  }
}

require("dap-vscode-js").setup({
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    }
  }
end


dap.set_log_level("DEBUG")

--- Debugging Keymaps ---
local keymap = vim.keymap.set
--- Start Debugging Session ---
keymap("n", "<m-1>", function() dap.continue() end)
keymap("n", "<m-2>", function() dap.step_over() end)
keymap("n", "<m-3>", function() dap.step_into() end)
keymap("n", "<m-4>", function() dap.step_out() end)
keymap("n", "<space>b", function() dap.toggle_breakpoint() end)
keymap("n", "<space>C", function() dap.clear_breakpoints() end)
-- keymap("n", "<space>da", function()
--   if vim.fn.filereadable(".vscode/launch.json") then
--     local dap_vscode = require("dap.ext.vscode")
--     dap_vscode.load_launchjs(nil, {
--       ["node"] = js_languages,
--       ["node-terminal"] = js_languages,
--       ["pwa-node"] = js_languages,
--       ["chrome"] = js_languages,
--       ["pwa-chrome"] = js_languages,
--     })
--   end
--   dap.continue()
-- end)
--- Debugging Widgets ---
keymap("n", "dp", function()
  widgets.preview()
end)
vim.keymap.set('n', '<space>dr', function() require('dap_config').repl.open() end)
vim.keymap.set({ 'n', 'v' }, '<space>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<space>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<space>df', function()
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<space>ds', function()
  widgets.centered_float(widgets.scopes)
end)
--- End Debugging Session ---
keymap("n", "<m-5>", function()
  dap.clear_breakpoints()
  dap.terminate()
  print("Debugger session ended")
end)
