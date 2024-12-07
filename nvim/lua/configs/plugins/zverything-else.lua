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
}
