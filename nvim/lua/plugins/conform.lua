return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            log_level = vim.log.levels.DEBUG,
            format_on_save = {
                -- Fallback to LSP autoformatting if conform formatting doesn't have the appropriate formatter
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                lua = { "stylua" },
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = { "rustfmt", lsp_format = "fallback" },
                -- Conform will run the first available formatter
                typescript = {
                    "deno_fmt",
                    "prettierd",
                    "prettier",
                    lsp_format = "fallback",
                    stop_after_first = true,
                },
                typescriptreact = {
                    "deno_fmt",
                    "prettierd",
                    "prettier",
                    lsp_format = "fallback",
                    stop_after_first = true,
                },
            },
        })
    end,
}
