return {
	"echasnovski/mini.nvim",
	config = function()
		-- I only have this for the branch name on my statusline
		-- But it does have some other cool functionality
		require("mini.git").setup()

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
