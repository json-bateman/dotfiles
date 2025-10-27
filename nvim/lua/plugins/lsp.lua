return {
	-- The language server for typescript that gives more capabilities (like automatic import)
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			settings = {
				expose_as_code_action = "all",
			},
		},
		cond = function()
			return not (vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1)
		end,
	},

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
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},

		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local opts = { noremap = true, silent = true }
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, opts)
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

					-- For LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the definition of the word under your cursor.
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("gro", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("grw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- Autocommand for adding missing imports
					-- vim.api.nvim_create_autocmd("BufWritePre", {
					-- 	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
					-- 	callback = function()
					-- 		vim.cmd("TSToolsAddMissingImports")
					-- 		vim.cmd("TSToolsOrganizeImports")
					-- 	end,
					-- })

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					-- ---@return boolean
					-- local function client_supports_method(client, method, bufnr)
					-- 	if vim.fn.has("nvim-0.11") == 1 then
					-- 		return client:supports_method(method, bufnr)
					-- 	else
					-- 		return client.supports_method(method, { bufnr = bufnr })
					-- 	end
					-- end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					-- if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					--     map('<leader>th', function()
					--         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
					--     end, '[T]oggle Inlay [H]ints')
					-- end
				end,
			})

			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				-- underline = { severity = vim.diagnostic.severity.INFO },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = false,
				-- virtual_text = {
				-- 	source = "if_many",
				-- 	spacing = 2,
				-- 	format = function(diagnostic)
				-- 		local diagnostic_message = {
				-- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
				-- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
				-- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
				-- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
				-- 		}
				-- 		return diagnostic_message[diagnostic.severity]
				-- 	end,
				-- },
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- rust_analyzer = {},
				-- ts_ls = {},

				pyright = {},
				html = {},
				cssls = {},
				css_variables = {
					settings = {
						cssVariables = {
							blacklistFolders = {
								"**/.cache",
								"**/.DS_Store",
								"**/.git",
								"**/.hg",
								"**/.next",
								"**/.svn",
								"**/bower_components",
								"**/CVS",
								"**/dist",
								"**/node_modules",
								"**/tests",
								"**/tmp",
							},
							lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
						},
					},
				},
				jsonls = {},
				sqls = {},
				tailwindcss = {
					filetypes = {
						"templ",
						"html",
						"css",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
					},
					settings = {
						tailwindCSS = {
							includeLanguages = {
								templ = "html",
							},
						},
					},
				},

				templ = {},
				gopls = {},

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							-- diagnostics = {
							-- 	disable = { "missing-parameters", "missing-fields", "undefined-global" },
							-- },
							workspace = {
								library = {
									vim.env.VIMRUNTIME,
									-- "/Users/jacktrusler/coding/vscode-wow-api/Annotations/Core",
								},
							},
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				automatic_enable = vim.tbl_keys(servers or {}),
			})

			-- Installed LSPs are configured and enabled automatically with mason-lspconfig
			-- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
			for server_name, config in pairs(servers) do
				-- This is to auto-implement capabilities from blink.cmp, and merge them with any custom capabilities we've defined
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end

			-- NOTE: Some servers may require an old setup until they are updated. For the full list refer here: https://github.com/neovim/nvim-lspconfig/issues/3705
			-- These servers will have to be manually set up with require("lspconfig").server_name.setup{}
		end,
	},
}
