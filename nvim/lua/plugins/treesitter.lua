-- nvim-treesitter migrated to the `main` branch (required for Neovim 0.12+).
-- See :h nvim-treesitter for the new API.
-- Prereqs (already installed on this machine): tree-sitter CLI >= 0.26.1

local ensure_installed = {
	-- config + docs
	"lua",
	"vim",
	"vimdoc",
	"luadoc",
	"markdown",
	"markdown_inline",
	-- -- backend
	-- "go",
	-- "gomod",
	-- "gosum",
	-- "gowork",
	-- "sql",
	-- -- web
	-- "javascript",
	-- "typescript",
	-- "tsx",
	-- "html",
	-- "css",
	-- -- data/tooling
	-- "json",
	-- "yaml",
	-- "toml",
	-- "bash",
	-- "dockerfile",
	-- "git_config",
	-- "gitcommit",
	-- "diff",
}

return {
	-----------------------------------------------------------------------
	-- Core parser management + highlighting
	-----------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			local nts = require("nvim-treesitter")

			-- Install the common set up front so they're ready immediately.
			nts.install(ensure_installed)

			-- Replacement for the old `auto_install = true`: when you open a
			-- filetype whose parser isn't installed yet, install it in the
			-- background and turn highlighting on for the buffer once it's ready.
			local installing = {} -- langs currently being fetched (dedupe)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ts_highlight", { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
					if not lang then
						return -- filetype has no treesitter language
					end

					-- Already installed → just start highlighting.
					if vim.tbl_contains(require("nvim-treesitter.config").get_installed("parsers"), lang) then
						pcall(vim.treesitter.start, ev.buf, lang)
						return
					end

					-- Not installed: only try if a parser actually exists for it,
					-- and only once per lang per session.
					if installing[lang] or not vim.tbl_contains(nts.get_available(), lang) then
						return
					end
					installing[lang] = true

					nts.install(lang):await(function(err)
						installing[lang] = nil
						if err then
							return
						end
						vim.schedule(function()
							if vim.api.nvim_buf_is_valid(ev.buf) then
								pcall(vim.treesitter.start, ev.buf, lang)
							end
						end)
					end)
				end,
			})
		end,
	},

	-----------------------------------------------------------------------
	-- Text objects (select / move) — also rewritten for the main branch
	-----------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "v",
					},
					include_surrounding_whitespace = true,
				},
				move = {
					set_jumps = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- select mappings (previously the `textobjects.select.keymaps` table)
			local selects = {
				["af"] = { "@function.outer", "textobjects" },
				["if"] = { "@function.inner", "textobjects" },
				["ai"] = { "@conditional.outer", "textobjects" },
				["ii"] = { "@conditional.inner", "textobjects" },
				["al"] = { "@loop.outer", "textobjects" },
				["il"] = { "@loop.inner", "textobjects" },
				["ac"] = { "@class.outer", "textobjects" },
				["ic"] = { "@class.inner", "textobjects" },
				["bi"] = { "@block.inner", "textobjects" },
				-- `@scope` from the master branch is `@local.scope` on main
				["as"] = { "@local.scope", "locals" },
			}
			for lhs, spec in pairs(selects) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(spec[1], spec[2])
				end, { desc = "Select " .. spec[1] })
			end

			-- move mappings (previously `textobjects.move.goto_*`)
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function start" })
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
		end,
	},

	-----------------------------------------------------------------------
	-- Context (sticky scope). No `main` branch exists; it rides on core
	-- treesitter APIs, so it stays on master and works fine on 0.12.
	-----------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			local ok, tsContext = pcall(require, "treesitter-context")
			if not ok then
				return
			end

			vim.keymap.set("n", "[c", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true, desc = "Go to context" })

			tsContext.setup({
				multiwindow = false,
				max_lines = 2,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "inner",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})
		end,
	},
}
