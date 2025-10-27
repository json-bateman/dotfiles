return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			log_level = vim.log.levels.DEBUG,
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			formatters = {
				sqlfluff = {
					args = { "format", "--dialect=sqlite", "-" }, -- or "mysql", "sqlite", etc.
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				sql = { "sqlfluff" },
				-- Conform will run the first available formatter
				typescript = {
					"deno_fmt",
					"prettierd",
					"prettier",
					lsp_format = "fallback",
					stop_after_first = true,
				},
				typescriptreact = {
					"deno_fmt",
					"prettierd",
					"prettier",
					lsp_format = "fallback",
					stop_after_first = true,
				},
			},
		})

		-- Templ and Html-lsp fight when saving a file. This disables html-lsp in templ files only
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf
				-- Only for templ buffers!
				if vim.bo[bufnr].filetype == "templ" and client and client.name == "html" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
			end,
		})
	end,
}
