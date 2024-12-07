return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects", -- Better AST selection
        "nvim-treesitter/nvim-treesitter-context",     -- See the context of the function you're in
    },
    config = function()
        local ok, treesitter = pcall(require, "nvim-treesitter.configs")
        if (not ok) then return end

        vim.keymap.set("n", "[c", function()
            require("treesitter-context").go_to_context(vim.v.count1)
        end, { silent = true })

        treesitter.setup({
            ensure_installed = {
                "bash",
                "markdown_inline",
                "markdown",
                "rust",
                "lua",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "json",
                "python",
                "go",
                "c",
                "vimdoc",
                "luadoc",

            },
            sync_install = true,
            auto_install = true,
            ignore_install = { "help" },
            highlight = {
                -- `false` will disable the whole extension
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ai"] = "@conditional.outer",
                        ["ii"] = "@conditional.inner",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["bi"] = "@block.inner",
                        -- You can also use captures from other query groups like `locals.scm`
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        -- ['@class.outer'] = '<c-v>', -- blockwise
                        ['@class.outer'] = 'v',     -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true or false
                    include_surrounding_whitespace = true,
                },
            },
        })
    end,
}
