return {
	"stevearc/conform.nvim",

	config = function()
		local function formatter_for_project()
			return { "prettierd", "prettier", stop_after_first = true }
		end
		require("conform").setup({
			log_level = vim.log.levels.DEBUG,
			format_on_save = { lsp_format = "fallback", timeout_ms = 4000 },
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				json = formatter_for_project,
				jsonc = formatter_for_project,
				javascript = formatter_for_project,
				typescript = formatter_for_project,
				typescriptreact = formatter_for_project,
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf
				-- Disable sqls formatting
				if client and client.name == "sqls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				-- Templ and Html-lsp fight when saving a file. This disables html-lsp in templ files only
				if vim.bo[bufnr].filetype == "templ" and client and client.name == "html" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
			end,
		})
	end,
}
