return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- Configure only what you need:
    -- Set up handy keybindings to invoke various snacks pickers:
    opts = {
        picker = {
            enabled = true,
            layout = {
                preset = "ivy",
            },
        },
    },
    keys = {
        { "<leader>sf", function() Snacks.picker.files() end,   desc = "Find Files" },
        {
            "<leader>sF",
            function()
                Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
            end,
            desc = "Find Files from current file's directory"
        },
        { "<leader>sr", function() Snacks.picker.recent() end,  desc = "Recent Files" },
        { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end,    desc = "Grep (Ripgrep)" },
        {
            "<leader>sG",
            function()
                Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") })
            end,
            desc = "Grep from current file's directory"
        },

        { "<leader>sh", function() Snacks.picker.command_history() end, desc = "Cmd History" },
        { "<leader>sn", function() Snacks.picker.notifications() end,   desc = "Notifications" },
        { "<leader>sn", function() Snacks.picker.notifications() end,   desc = "Notifications" },
        { "<leader>gd", function() Snacks.picker.git_diff() end,        desc = "Git Diff (Hunks)" },
    },
}
