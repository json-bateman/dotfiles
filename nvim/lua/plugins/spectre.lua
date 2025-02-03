return {
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
}
