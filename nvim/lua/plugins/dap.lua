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

		-- JS/TS debugging
		{
			"mxsdev/nvim-dap-vscode-js",
			opts = {
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			},
		},
		{
			"microsoft/vscode-js-debug",
			build = "npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
		},

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
		local widgets = require("dap.ui.widgets")

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
		--- Javascript / TS ----
		require("dap-vscode-js").setup({
			adapters = {
				"pwa-node",
				"pwa-chrome",
				"pwa-msedge",
				"node-terminal",
				"pwa-extensionHost",
			}, -- which adapters to register in nvim-dap
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
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end

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
		require("dap-go").setup({
			dap_configurations = {
				{
					type = "delve",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug Project",
					request = "launch",
					program = "${workspaceFolder}",
				},
				{
					type = "delve",
					name = "Attach to Process",
					request = "attach",
					processId = function()
						local pid = vim.fn.input("Enter PID of process: ")
						return tonumber(pid)
					end,
				},
			},
		})

		dap.set_log_level("DEBUG")

		--- Debugging Keymaps ---
		local keymap = vim.keymap.set
		--- Start Debugging Session ---
		keymap("n", "<m-1>", function()
			dap.continue()
		end)
		keymap("n", "<m-2>", function()
			dap.step_into()
		end)
		keymap("n", "<m-3>", function()
			dap.step_over()
		end)
		keymap("n", "<m-4>", function()
			dap.step_out()
		end)
		keymap("n", "<m-5>", function()
			dap.terminate()
		end)
		keymap("n", "<space>b", function()
			dap.toggle_breakpoint()
		end)
		keymap("n", "<space>C", function()
			dap.clear_breakpoints()
		end)

		--- Debugging Widgets ---
		vim.keymap.set("n", "<space>dr", function()
			require("dap_config").repl.open()
		end)
		vim.keymap.set({ "n", "v" }, "<space>dh", function()
			require("dap.ui.widgets").hover()
		end)
		vim.keymap.set({ "n", "v" }, "<space>dp", function()
			require("dap.ui.widgets").preview()
		end)
		vim.keymap.set("n", "<space>df", function()
			widgets.centered_float(widgets.frames)
		end)
		vim.keymap.set("n", "<space>ds", function()
			widgets.centered_float(widgets.scopes)
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
