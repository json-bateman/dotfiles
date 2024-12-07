--[[
 ________
| |____| |
| plugin |
|  (__)  |
|________|

]]

return {
    -- "EdenEast/nightfox.nvim",                      -- Foxy
    -- "navarasu/onedark.nvim",                       -- The darkest one
    -- "rebelot/kanagawa.nvim",       -- The colors of a famous painting Katsushika Hokusai
    "ellisonleao/gruvbox.nvim",    -- To get groovy
    "nanotee/luv-vimdocs",         -- puts lua docs into vim docs
    "nvim-tree/nvim-web-devicons", -- icons for files, etc.
    "nvim-lua/plenary.nvim",       -- Useful helper functions written by TJ
    -----------------------------
    -- plugins with extra options
    -----------------------------
    -- Trying to make a custom plugin
    { dir = "/Users/jack/Coding/plugins/dockerino" },
    {
        'echasnovski/mini.nvim', -- A nice lil statusline
        config = function()
            require('mini.statusline').setup()
            require('mini.git').setup()
        end,
        version = false
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            vim.keymap.set('n', '<leader>/', '<CMD>Neotree toggle<CR>', { desc = '[N]eo [T]ree' })
        end
    },
    {
        "nvim-telescope/telescope.nvim", -- TJ's fuzzy finder
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sG',
                "<CMD>lua require('telescope.builtin').live_grep({search_dirs={vim.fn.expand('%.h')}})<CR>",
                { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
        end
    },
    {
        "NeogitOrg/neogit",           -- Git wrapper to stay in vim
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
        },
        keys = {
            { "<leader>ng", "<CMD>:Neogit<CR>", desc = "Neogit" },
        },
        config = true
    },

    {
        "chrisgrieser/nvim-early-retirement",
        config = true,
        event = "VeryLazy",
    },
    {
        "alexghergh/nvim-tmux-navigation", -- Move in Neovim and Tmux
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },
    {
        "leath-dub/snipe.nvim",
        keys = {
            { "gb", function() require("snipe").open_buffer_menu() end, desc = "Open snipe buffer menu" }
        },
        opts = {},
    },
    {
        "nvim-pack/nvim-spectre", -- Find and Replace
        event = "VeryLazy",
        config = function()
            -- https://github.com/nvim-pack/nvim-spectre/issues/118
            -- Sed after replacing makes a backup file, an empty arg fixes the issue
            require("spectre").setup({
                replace_engine = {
                    ["sed"] = {
                        cmd = "sed",
                        args = {
                            "-i",
                            "",
                            "-E",
                        },
                    },
                },
            })
            -- Spectre
            vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
        end
    },
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    {
        "stevearc/oil.nvim", -- File system access easier
        event = "VeryLazy",
        config = function()
            require("oil").setup {
                cleanup_delay_ms = 100,
                columns = { "icon" },
                view_options = {
                    show_hidden = true
                },
                keymaps = {
                    ["<C-h>"] = false, -- Off to move between splits
                    ["<C-l>"] = false, -- Off to move between splits
                },
            }
            -- Open parent directory in current window
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
            -- Open parent directory in floating window
            vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
        end
    },
    -- {
    --   "Exafunction/codeium.nvim", -- Copilot alternative for Neovim
    --   config = function()
    --     require("codeium").setup({
    --       -- Optionally disable cmp source if using virtual text only
    --       enable_cmp_source = false,
    --       virtual_text = {
    --         enabled = true,
    --
    --         -- These are the defaults
    --
    --         -- Set to true if you never want completions to be shown automatically.
    --         manual = false,
    --         -- A mapping of filetype to true or false, to enable virtual text.
    --         filetypes = {},
    --         -- Whether to enable virtual text of not for filetypes not specifically listed above.
    --         default_filetype_enabled = true,
    --         -- How long to wait (in ms) before requesting completions after typing stops.
    --         idle_delay = 75,
    --         -- Priority of the virtual text. This usually ensures that the completions appear on top of
    --         -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
    --         -- desired.
    --         virtual_text_priority = 65535,
    --         -- Set to false to disable all key bindings for managing completions.
    --         map_keys = true,
    --         -- The key to press when hitting the accept keybinding but no completion is showing.
    --         -- Defaults to \t normally or <c-n> when a popup is showing.
    --         accept_fallback = nil,
    --         -- Key bindings for managing completions in virtual text mode.
    --         key_bindings = {
    --           -- Accept the current completion.
    --           accept = "<Tab>",
    --           -- Accept the next word.
    --           accept_word = false,
    --           -- Accept the next line.
    --           accept_line = false,
    --           -- Clear the virtual text.
    --           clear = false,
    --           -- Cycle to the next completion.
    --           next = "<M-]>",
    --           -- Cycle to the previous completion.
    --           prev = "<M-[>",
    --         }
    --       }
    --     })
    --   end
    -- },
}
