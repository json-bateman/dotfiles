return {
	-- The language server for typescript that gives more capabilities (like automatic import)
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- Load on TS/JS files
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	opts = function()
		return {
			settings = {
				expose_as_code_action = "all",
			},
			root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json"),
			single_file_support = false,
		}
	end,
}
