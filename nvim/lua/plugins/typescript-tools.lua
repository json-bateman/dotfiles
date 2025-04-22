return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
	cond = function()
		return not (vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1)
	end,
}
