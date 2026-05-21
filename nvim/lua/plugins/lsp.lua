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
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gro", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("grw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
				end,
			})

			-- See :help vim.diagnostic.Opts
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
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local util = require("lspconfig.util")

			local servers = {
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

				denols = {
					root_dir = function(bufnr, on_dir)
						local fname = vim.api.nvim_buf_get_name(bufnr)
						local root = util.root_pattern("deno.json", "deno.jsonc")(fname)
						if root then
							on_dir(root)
						end
					end,
					single_file_support = false,
					before_init = function(_, config)
						config.init_options = config.init_options or {}
						config.init_options.enable = true
						config.init_options.config = config.root_dir .. "/deno.json"
					end,
				},

				jsonls = {},
				-- sqls = {},

				-- tailwindcss = {
				-- 	filetypes = {
				-- 		"templ",
				-- 		"html",
				-- 		"css",
				-- 		"javascript",
				-- 		"typescript",
				-- 		"javascriptreact",
				-- 		"typescriptreact",
				-- 	},
				-- 	settings = {
				-- 		tailwindCSS = {
				-- 			includeLanguages = {
				-- 				templ = "html",
				-- 			},
				-- 		},
				-- 	},
				-- },

				templ = {},
				gopls = {},

				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								library = {
									vim.env.VIMRUNTIME,
								},
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				automatic_enable = vim.tbl_keys(servers or {}),
			})

			for server_name, config in pairs(servers) do
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end
		end,
	},
}
