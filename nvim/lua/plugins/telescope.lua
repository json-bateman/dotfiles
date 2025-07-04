return {
	"nvim-telescope/telescope.nvim", -- TJ's fuzzy finder

	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").setup({
			defaults = {
				layout_config = { height = 0.5, width = 0.95 },
			},
		})

		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")

		local function ivyPicker(picker)
			return function()
				builtin[picker](themes.get_ivy({
					layout_config = {
						height = 0.5,
					},
				}))
			end
		end

		local function dropdownPicker(picker, opts)
			return function()
				builtin[picker](themes.get_dropdown(vim.tbl_deep_extend("force", {
					layout_config = {
						height = 0.5,
						width = 0.95,
					},
				}, opts or {})))
			end
		end

		vim.keymap.set("n", "<leader>sd", ivyPicker("diagnostics"), { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sc", ivyPicker("git_status"), { desc = "[S]earch [C]hanges" })
		vim.keymap.set("n", "<leader>sh", ivyPicker("help_tags"), { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", ivyPicker("keymaps"), { desc = "[S]earch [K]eymaps" })

		vim.keymap.set("n", "<leader>sf", ivyPicker("find_files"), { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", ivyPicker("builtin"), { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", ivyPicker("live_grep"), { desc = "[S]earch by [G]rep" })
		vim.keymap.set(
			"n",
			"<leader>sG",
			"<CMD>lua require('telescope.builtin').live_grep({search_dirs={vim.fn.expand('%:p:h')}})<CR>",
			{ desc = "[S]earch by [G]rep" }
		)
		vim.keymap.set("n", "<leader>sr", ivyPicker("resume"), { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", ivyPicker("oldfiles"), { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", ivyPicker("buffers"), { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		vim.keymap.set(
			"n",
			"<leader>sn",
			dropdownPicker("find_files", {
				cwd = vim.fn.stdpath("config"),
			}),
			{ desc = "[S]earch [N]eovim files" }
		)
	end,
}
