local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if (not ok) then return end

treesitter.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "rust", "lua", "javascript", "typescript", "tsx", "html", "css", "json" },
  -- Automatically install missing parsers when entering buffer
  ignore_install = { "help" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    disable = {},
  },
}

