local ok, _ = pcall(require, "impatient")
require "plugins"
-------------------------------------------
-- mason --> mason-lspconfig --> lspconfig
-- must be setup in this order
-------------------------------------------
require "plugins/configs/mason"
require "plugins/configs/mason-lspconfig"
require "plugins/configs/lspconfig"
require "plugins/configs/cmp"
require "plugins/configs/dap"
----------------------------------
-- all settings
----------------------------------
require "settings/keymaps"
require "settings/options"
require "settings/styles"
require "snippets"
if not ok then
  return
end
