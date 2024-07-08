local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
   print("dap not found!")
   return
end

local dap_go_ok, dap_go = pcall(require, "dap-go")
if not dap_go_ok then
   print("dap-go not found!")
   return
end

local dap_text_ok, dap_text = pcall(require, "nvim-dap-virtual-text")
if not dap_text_ok then
   print("nvim-dap-virtual-text not found!")
   return
end


-- local dap_ui_ok, dap_ui = pcall(require, "dapui")
-- if not dap_ui_ok then
--    print("nvim-dap-ui not found!")
--    return
-- end

-- local dap_vars_ok, dap_vars = pcall(require, "dap.ui.variables")
-- if not dap_vars_ok then
--    print("dap.ui.variables not found!")
--    return
-- end

dap_text.setup()
dap_go.setup()
-- dap_ui.setup()

dap.configurations.go = {
   {
      type = 'go',
      name = 'Debug',
      request = 'launch',
      program = "${fileDirname}",
   },
}

--- Debugging Keymaps ---
local keymap = vim.keymap.set
--- Start Debugging Session ---
keymap("n", "<F1>", function() dap.continue() end)
keymap("n", "<F2>", function() dap.step_over() end)
keymap("n", "<F3>", function() dap.step_into() end)
keymap("n", "<F4>", function() dap.step_out() end)
keymap("n", "<space>B", function() dap.toggle_breakpoint() end)
keymap("n", "<space>C", function() dap.clear_breakpoints() end)
-- keymap("n", "<space>di", function() dap_vars.hover() end)
--- End Debugging Session ---
keymap("n", "<F5>", function()
   dap.clear_breakpoints()
   dap.terminate()
   print("Debugger session ended")
end)
