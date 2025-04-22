return {
	"nvim-telescope/telescope.nvim", -- TJ's fuzzy finder
	config = function()
		local function dropdownTheme(abilityStr)
			return "<cmd>lua require('telescope.builtin')."
				.. abilityStr
				.. "(require('telescope.themes').get_dropdown({}))<cr>"
		end

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sd", dropdownTheme("diagnostics"), { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sc", dropdownTheme("git_status"), { desc = "[S]earch [C]hanges" })
		vim.keymap.set("n", "<leader>sh", dropdownTheme("help_tags"), { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", dropdownTheme("keymaps"), { desc = "[S]earch [K]eymaps" })

		vim.keymap.set("n", "<leader>sf", dropdownTheme("find_files"), { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", dropdownTheme("builtin"), { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", dropdownTheme("live_grep"), { desc = "[S]earch by [G]rep" })
		vim.keymap.set(
			"n",
			"<leader>sG",
			"<CMD>lua require('telescope.builtin').live_grep({search_dirs={vim.fn.expand('%:p:h')}})<CR>",
			{ desc = "[S]earch by [G]rep" }
		)
		vim.keymap.set("n", "<leader>sr", dropdownTheme("resume"), { desc = "[S]earch [R]esume" })
		vim.keymap.set(
			"n",
			"<leader>s.",
			dropdownTheme("oldfiles"),
			{ desc = '[S]earch Recent Files ("." for repeat)' }
		)
		vim.keymap.set("n", "<leader><leader>", dropdownTheme("buffers"), { desc = "[ ] Find existing buffers" })
	end,
}
