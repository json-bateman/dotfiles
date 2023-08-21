if vim.g.vscode then
   return
else
   require "plugins"
   require "plugins/configs/snippets"
   require "plugins/configs/lspconfig"
   require "plugins/configs/dap"
   require "settings/options"
   require "settings/keymaps"
   require "settings/styles"
end
