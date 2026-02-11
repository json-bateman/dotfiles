return {
	-- The language server for typescript that gives more capabilities (like automatic import)
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- Load on TS/JS files
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	opts = function()
		local util = require("lspconfig.util")

		return {
			settings = {
				expose_as_code_action = "all",
			},
			root_dir = function(fname)
				local deno_root = util.root_pattern("deno.json", "deno.jsonc")(fname)
				if deno_root then
					-- Deno project detected, don't attach typescript-tools
					return nil
				end

				-- Not a Deno project, find Node.js root
				local node_root = util.root_pattern("package.json", "tsconfig.json")(fname)
				return node_root
			end,
			single_file_support = false,
		}
	end,
}
