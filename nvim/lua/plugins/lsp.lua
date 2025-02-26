return {
	{
		"williamboman/mason.nvim", -- UI for fetching/downloading LSPs
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim", -- Bridges mason and lspconfig
		dependencies = { "williamboman/mason.nvim" }, -- mason-lspconfig must load after mason
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"jdtls",
					"denols",
					"jsonls",
					"html",
					"cssls",
					"yamlls",
					"lua_ls",
					"rust_analyzer",
					"tailwindcss",
					"eslint",
					"clangd",
					"pyright",
					"gopls",
					"dockerls",
					"solidity_ls_nomicfoundation",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig", -- neovims configuation for the built in client
		dependencies = {
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
			{
				"stevearc/conform.nvim",
				config = function()
					require("conform").setup({
						format_on_save = {
							-- Fallback to LSP autoformatting if conform formatting doesn't have the appropriate formatter
							lsp_format = "fallback",
						},
						formatters_by_ft = {
							lua = { "stylua" },
							-- You can customize some of the format options for the filetype (:help conform.format)
							rust = { "rustfmt", lsp_format = "fallback" },
							-- Conform will run the first available formatter
							javascript = { "prettierd", "prettier", stop_after_first = true },
							typescript = { "prettierd", "prettier", stop_after_first = true },
						},
					})
				end,
			},
		},
		config = function()
			local ok, lspconfig = pcall(require, "lspconfig")
			if not ok then
				print("require lspconfig failed")
				return
			end

			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, opts)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				client.server_capabilities.semanticTokensProvider = nil

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, bufopts)
			end

			-- Autoformatting
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
				desc = "TS_add_missing_imports",
				pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
				callback = function()
					vim.cmd([[TSToolsAddMissingImports]])
					vim.cmd([[TSToolsOrganizeImports]])
					vim.cmd("write")
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Change to log level "debug" to see all lsp info
			-- Note: If you keep debug on it creates a massive file
			vim.lsp.set_log_level("off");

			--IIFE to setup diagnostics... Need semicolon on the line above to deliminate IIFE's in lua, without it trys to curry the function above
			--https://stackoverflow.com/questions/53656742/defining-and-calling-function-at-the-same-time-in-lua
			(function()
				vim.lsp.handlers["textDocument/publishDiagnostics"] =
					vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
						virtual_text = false,
						signs = true,
						update_in_insert = false,
						underline = true,
					})
			end)()

			-- Set up some servers with custom settings --
			lspconfig.yamlls.setup({
				on_attach = on_attach,
				capabilities = capabilities,

				settings = {
					yaml = {
						schemaStore = {
							url = "https://www.schemastore.org/api/json/catalog.json",
							enable = true,
						},
					},
				},
			})

			lspconfig["solidity"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
				filetypes = { "solidity" },
				root_dir = lspconfig.util.root_pattern("foundry.toml"),
				single_file_support = true,
			})

			lspconfig.denols.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
			})

			lspconfig.eslint.setup({
				on_attach = function(_, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
				settings = {
					workingDirectory = { mode = "location" },
				},
				root_dir = vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1]),
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							disable = { "missing-parameters", "missing-fields", "undefined-global" },
						},
					},
				},
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
				settings = {
					css = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			-- Set up the rest of the servers with default settings --
			local all_servers = {
				"sqlls",
				-- Typescript Tools provides the language server for ts and js
				"jdtls",
				"jsonls",
				"html",
				"rust_analyzer",
				"tailwindcss",
				"clangd",
				"pyright",
				"gopls",
				"templ",
				"dockerls",
			}

			for _, server in ipairs(all_servers) do
				lspconfig[server].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
		end,
	},
}
