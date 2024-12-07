return {
    'echasnovski/mini.nvim', -- A nice lil statusline
    config = function()
        require('mini.statusline').setup()
        require('mini.git').setup()
    end,
    version = false
}
