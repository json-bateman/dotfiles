local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if (not ok) then return end

treesitter.setup {
   -- A list of parser names, or "all"
   ensure_installed = {
      "bash",
      "markdown_inline",
      "markdown",
      "rust",
      "java",
      "lua",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "python",
      "ruby",
      "go",
      "c",
      "vimdoc",
   },
   -- auto_install = true,
   ignore_install = { "help" },
   highlight = {
      -- `false` will disable the whole extension
      enable = true,
      disable = {},
   },
}
