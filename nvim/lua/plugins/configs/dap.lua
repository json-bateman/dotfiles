local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
   print("dap not found!")
   return
end

local dap_ui_ok, dap_ui = pcall(require, "dapui")
if not (dap_ui_ok) then
   print("dap-ui not found!")
   return
end

local dap_go_ok, dap_go = pcall(require, "dap-go")
if not (dap_go_ok) then
   print("dap-go not found!")
   return
end

local dap_vs_ok, dap_vs = pcall(require, "dap-vscode-js")
if not (dap_vs_ok) then
   print("dap-vs not found!")
   return
end

dap_ui.setup()

--- DAP Golang setup ---
dap_go.setup()

--- DAP Javascript and Typescript setup ---
dap_vs.setup({
   node_path = "node",                                                                          -- Path of node executable. Defaults to $NODE_PATH, and then "node"
   debugger_path = vim.fn.stdpath('data') .. "/lazy/vscode-js-debug",                           -- Path to vscode-js-debug installation.
   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
})

-- custom adapter for running tasks before starting debug
for _, language in ipairs({ 'typescript', 'javascript' }) do
   dap.configurations[language] = {
      {
         name = 'Launch',
         type = 'pwa-node',
         request = 'launch',
         program = '${file}',
         rootPath = '${workspaceFolder}',
         cwd = '${workspaceFolder}',
         sourceMaps = true,
         skipFiles = { '<node_internals>/**' },
         protocol = 'inspector',
         console = 'integratedTerminal',
      },
      {
         name = 'Attach to node process',
         type = 'pwa-node',
         request = 'attach',
         rootPath = '${workspaceFolder}',
         processId = require('dap.utils').pick_process,
      },
      {
         name = 'Chrome',
         type = 'pwa-chrome',
         request = "launch",
         url = "http://localhost:3000",
         webRoot = "${workspaceFolder}",
         runtimeExecutable = "/usr/bin/chrome",
         -- runtimeArgs = { "-user-data-dir=/home/djan/Desktop/chrome" },
         -- userDataDir = "~/Desktop/chrome",
      },
   }
end

dap.adapters.node2 = {
   type = 'executable',
   command = 'node',
   args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

--- Debugging Keymaps ---
local keymap = vim.keymap.set
--- Start Debugging Session ---
keymap("n", "<F5>", function()
   dap.continue()
   dap_ui.toggle()
end)
keymap("n", "<F6>", function() dap_ui.toggle() end)
keymap("n", "<F10>", function() dap.step_over() end)
keymap("n", "<F11>", function() dap.step_into() end)
keymap("n", "<F12>", function() dap.step_out() end)
keymap("n", "<leader>B", function() dap.toggle_breakpoint() end)
keymap("n", "<leader>C", function() dap.clear_breakpoints() end)
--- End Debugging Session ---
keymap("n", "<F1>", function()
   dap.clear_breakpoints()
   dap_ui.toggle()
   dap.terminate()
   print("Debugger session ended")
end)
