return {
	-- Lazily updates workspace libraries
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- ----------------------
	-- Main LSP Configuration
	-- ----------------------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},

		config = function()
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "Diagnostic float" })
			vim.keymap.set(
				"n",
				"<leader>q",
				vim.diagnostic.setloclist,
				{ silent = true, desc = "Diagnostics to loclist" }
			)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					local tb = require("telescope.builtin")

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", tb.lsp_references, "[G]oto [R]eferences")
					map("gri", tb.lsp_implementations, "[G]oto [I]mplementation")
					map("grd", tb.lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gro", tb.lsp_document_symbols, "Open Document Symbols")
					map("grw", tb.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", tb.lsp_type_definitions, "[G]oto [T]ype Definition")
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = false,
				jump = {
					on_jump = function(diagnostic, bufnr)
						if not diagnostic then
							return
						end
						vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
					end,
				},
			})

			local servers = {
				pyright = {},
				html = { filetypes = { "html", "templ" } },
				cssls = {},
				css_variables = {},
				jsonls = {},
				templ = {},
				gopls = {},
				lua_ls = {},
			}

			-- css-variables-language-server not in nixos-25.11, managed by Mason via npm
			require("mason-tool-installer").setup({ ensure_installed = { "css-variables-language-server" } })
			require("mason-lspconfig").setup({ automatic_enable = false })

			for name, cfg in pairs(servers) do
				vim.lsp.config(name, cfg)
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
