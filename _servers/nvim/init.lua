local ok, impatient = pcall(require, "impatient")
require "plugins"
require "plugins.configs.neo-tree"
require "plugins.configs.lualine"
----------------------------------
-- all settings
----------------------------------
require "settings/keymaps"
require "settings/options"
require "settings/styles"
if (not ok) then return end
