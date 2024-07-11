require "plugins"
require "settings/options"
require "settings/keymaps"
require "settings/styles"
require "plugins/configs/snippets"
-- local client = vim.lsp.start_client {
--    name = "customlsp",
--    cmd = { "/Users/jack/Coding/customlsp/main" }
-- }

-- if not client then
--    vim.notify "you didn't do client thing good"
--    return
-- end

-- vim.api.nvim_create_autocmd("FileType", {
--    pattern = "markdown",
--    callback = function()
--       vim.lsp.buf_attach_client(0, client)
--    end,
-- })
