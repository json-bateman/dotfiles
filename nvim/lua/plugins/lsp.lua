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
					"denols",
					"jsonls",
					"html",
					"cssls",
					"yamlls",
					"lua_ls",
					"ts_ls",
					"rust_analyzer",
					"eslint",
					"tailwindcss",
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
						log_level = vim.log.levels.DEBUG,
						format_on_save = {
							-- Fallback to LSP autoformatting if conform formatting doesn't have the appropriate formatter
							lsp_format = "fallback",
						},
						formatters_by_ft = {
							lua = { "stylua" },
							-- You can customize some of the format options for the filetype (:help conform.format)
							rust = { "rustfmt", lsp_format = "fallback" },
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
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	pattern = "*",
			-- 	callback = function(args)
			-- 		require("conform").format({ bufnr = args.buf })
			-- 	end,
			-- })

			if vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1 then
			else
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
					desc = "TS_add_missing_imports",
					pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
					callback = function()
						vim.cmd([[TSToolsAddMissingImports]])
						-- vim.cmd([[TSToolsOrganizeImports]])
						-- vim.cmd("write")
					end,
				})
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			-- Change to log level "debug" to see all lsp info
			-- Note: If you keep debug on it creates a massive file
			vim.lsp.set_log_level("INFO");

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
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					css = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			local nvim_lsp = require("lspconfig")
			-- Must set this up before jdtls
			require("java").setup()

			nvim_lsp.denols.setup({
				on_attach = on_attach,
				root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
			})

			nvim_lsp.tailwindcss.setup({
				on_attach = on_attach,
			})

			-- Set up the rest of the servers with default settings --
			local all_servers = {
				"sqlls",
				"jdtls",
				"jsonls",
				"html",
				-- Replaced by typescript-tools
				-- "ts_ls",
				"rust_analyzer",
				"clangd",
				"tailwindcss",
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

			local function virtual_text_document(params)
				local bufnr = params.buf
				local actual_path = params.match:sub(1)

				local clients = vim.lsp.get_clients({ name = "denols" })
				if #clients == 0 then
					return
				end

				local client = clients[1]
				local method = "deno/virtualTextDocument"
				local req_params = { textDocument = { uri = actual_path } }
				local response = client:request_sync(method, req_params, 2000, 0)
				if not response or type(response.result) ~= "string" then
					return
				end

				local lines = vim.split(response.result, "\n")
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
				vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
				vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
				vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
				vim.api.nvim_buf_set_name(bufnr, actual_path)
				vim.lsp.buf_attach_client(bufnr, client.id)

				local filetype = "typescript"
				if actual_path:sub(-3) == ".md" then
					filetype = "markdown"
				end
				vim.api.nvim_set_option_value("filetype", filetype, { buf = bufnr })
			end

			vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
				pattern = { "deno:/*" },
				callback = virtual_text_document,
			})
		end,
	},
}
