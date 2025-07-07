return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = {
		{ "<leader>/", "<CMD>Neotree toggle<CR>", desc = "Neotree Toggle" },
		{ "<leader>,", "<CMD>Neotree toggle buffers<CR>", desc = "Neotree Buffers" },
		{ "<leader>.", "<CMD>Neotree toggle reveal_force_cwd<CR>", desc = "Neotree Toggle" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
}
