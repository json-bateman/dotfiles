return {
	"mfussenegger/nvim-dap",
	commit = "7ff6936010b7222fea2caea0f67ed77f1b7c60dd",
	-- keys = {
	--     { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP" },
	-- },
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",

		-- Golang debugging
		"leoluz/nvim-dap-go",

		-- Lua Debugging
		{
			"jbyuki/one-small-step-for-vimkind",
			keys = {
				{
					"<leader>dl",
					function()
						require("osv").launch({ port = 8086 })
					end,
					desc = "Launch Lua adapter",
				},
			},
		},
	},
	config = function()
		local dap = require("dap")

		local ok, dapui = pcall(require, "dapui")
		if not ok then
			return
		end

		local text_ok, dap_text = pcall(require, "nvim-dap-virtual-text")
		if not text_ok then
			return
		end

		dapui.setup()
		dap_text.setup({})

		--- Configurations (see :h dap-configuration) ---
		--- Lua ---
		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
			},
		}

		dap.adapters.nlua = function(callback, config)
			callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
		end

		--- Golang ---
		require("dap-go").setup({})
		dap.configurations.go = {
			{
				type = "go",
				name = "Debug test",
				request = "launch",
				mode = "test",
				program = "${fileDirname}",
			},
			{
				type = "go",
				name = "Launch current package",
				request = "launch",
				program = "${fileDirname}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "go",
				name = "launch from Workspace Folder ./main.go",
				request = "launch",

				program = "${workspaceFolder}/main.go",
				cwd = "${workspaceFolder}",
			},
		}

		dap.set_log_level("TRACE")

		--- Debugging Keymaps ---
		local keymap = vim.keymap.set
		--- Start Debugging Session ---
		keymap("n", "<F1>", function()
			dap.continue()
		end)
		keymap("n", "<F2>", function()
			dap.step_into()
		end)
		keymap("n", "<F3>", function()
			dap.step_over()
		end)
		keymap("n", "<F4>", function()
			dap.step_out()
		end)
		keymap("n", "<F5>", function()
			dap.terminate()
		end)
		keymap("n", "<space>b", function()
			dap.toggle_breakpoint()
		end)
		keymap("n", "<space>C", function()
			dap.clear_breakpoints()
		end)

		--- End Debugging Session ---
		keymap("n", "<m-0>", function()
			dap.clear_breakpoints()
			dap.terminate()
			print("Debugger session ended")
		end)

		-- Open DapUI --
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
