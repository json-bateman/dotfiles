return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.git").setup()
		require("mini.tabline").setup()

		local ms = require("mini.statusline")
		-- Override section_filename *before* setup!
		ms.section_filename = function()
			local filename = vim.fn.pathshorten(vim.fn.expand("%:~:."))
			local maxlen = 50
			if #filename > maxlen then
				return "…" .. filename:sub(-maxlen + 1)
			else
				return filename
			end
		end
		ms.setup({})
	end,
	version = false,
}
