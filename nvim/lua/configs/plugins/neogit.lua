return {
    "NeogitOrg/neogit",           -- Git wrapper to stay in vim
    dependencies = {
        "nvim-lua/plenary.nvim",  -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
    },
    keys = {
        { "<leader>ng", "<CMD>:Neogit<CR>", desc = "Neogit" },
    },
    config = true
}
