return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
    },
    event = "VeryLazy",
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<Up>"] = cmp.mapping.scroll_docs(-4),
                ["<Down>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                ["<c-n>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<c-p>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_prev_item()
                    end
                end, { "i", "s" }),
            },
            sources = {
                -- the order you call these in determines the way they show up in completion window
                { name = "nvim_lua",               max_item_count = 20 },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "buffer",                 keyword_length = 5 },
            },
        })
        -- cmp.setup.cmdline(':', {
        --   mapping = cmp.mapping.preset.cmdline(),
        --   sources = cmp.config.sources({
        --     { name = 'path' }
        --   }, {
        --     { name = 'cmdline' }
        --   }),
        --   matching = { disallow_symbol_nonprefix_matching = false }
        -- })

        -- Setup for vim-dadbod
        cmp.setup.filetype({ "sql" }, {
            sources = {
                { name = "vim-dadbod-completion" },
                { name = "buffer" },
            },
        })
    end,

}
