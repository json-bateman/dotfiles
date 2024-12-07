return {
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
}
