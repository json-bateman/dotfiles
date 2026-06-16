return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = {
		{ "<leader>/", "<CMD>Neotree toggle<CR>", desc = "Neotree Toggle" },
		{ "<leader>,", "<CMD>Neotree toggle buffers<CR>", desc = "Neotree Buffers" },
		{ "<leader>.", "<CMD>Neotree toggle reveal_force_cwd<CR>", desc = "Neotree Toggle" },
	},
	opts = {
		default_component_configs = {
			git_status = {
				symbols = {
					added = "✚",
					modified = "",
					deleted = "✖",
					renamed = "󰁕",
					untracked = "",
					ignored = "",
					unstaged = "",
					staged = "",
					conflict = "",
				},
			},
		},
		window = {
			width = 40,
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
}
