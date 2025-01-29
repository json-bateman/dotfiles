--[[
 ________
| |____| |
| styles |
|  (__)  |
|________|

]]

require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = {    -- :h background
        light = "frappe",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
    term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false,            -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,          -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,              -- Force no italic
    no_bold = false,                -- Force no bold
    no_underline = false,           -- Force no underline
    styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },    -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- Check system preferences
---@type table
local query_command
---@type "Linux" | "Darwin" | "Windows_NT" | "WSL"
local system
---@type "Dark" | "Light"
local fallback
---@type boolean
local is_dark_mode

local function parse_res(res)
    if system == "Linux" then
        -- https://github.com/flatpak/xdg-desktop-portal/blob/c0f0eb103effdcf3701a1bf53f12fe953fbf0b75/data/org.freedesktop.impl.portal.Settings.xml#L32-L46
        -- 0: no preference
        -- 1: dark
        -- 2: light
        if string.match(res[1], "uint32 1") ~= nil then
            return true
        elseif string.match(res[1], "uint32 2") ~= nil then
            return false
        else
            return fallback == "dark"
        end
    elseif system == "Darwin" then
        return res[1] == "Dark"
    elseif system == "Windows_NT" or system == "WSL" then
        -- AppsUseLightTheme REG_DWORD 0x0 : dark
        -- AppsUseLightTheme REG_DWORD 0x1 : light
        return string.match(res[3], "0x1") == nil
    end
    return false
end

local function fetch_vars()
    if string.match(vim.loop.os_uname().release, "WSL") then
        system = "WSL"
    else
        system = vim.loop.os_uname().sysname
    end

    if system == "Darwin" then
        query_command = { "defaults", "read", "-g", "AppleInterfaceStyle" }
    elseif system == "Linux" then
        if not vim.fn.executable("dbus-send") then
            error([[
		`dbus-send` is not available. The Linux implementation of
		auto-dark-mode.nvim relies on `dbus-send` being on the `$PATH`.
		]])
        end

        query_command = {
            "dbus-send",
            "--session",
            "--print-reply=literal",
            "--reply-timeout=1000",
            "--dest=org.freedesktop.portal.Desktop",
            "/org/freedesktop/portal/desktop",
            "org.freedesktop.portal.Settings.Read",
            "string:org.freedesktop.appearance",
            "string:color-scheme",
        }
    elseif system == "WSL" then
        -- Don't swap the quotes; it breaks the code
        query_command = {
            "/mnt/c/Windows/system32/reg.exe",
            "Query",
            "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "/v",
            "AppsUseLightTheme",
        }
    elseif system == "Windows_NT" then
        -- Don't swap the quotes; it breaks the code
        query_command = {
            "reg.exe",
            "Query",
            "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "/v",
            "AppsUseLightTheme",
        }
    else
        return
    end

    if vim.fn.has("unix") ~= 0 then
        if vim.loop.getuid() == 0 then
            local sudo_user = vim.env.SUDO_USER

            if sudo_user ~= nil then
                query_command = vim.tbl_extend("keep", { "su", "-", sudo_user, "-c" }, query_command)
            else
                error([[
				auto-dark-mode.nvim:
				Running as `root`, but `$SUDO_USER` is not set.
				Please open an issue to add support for your system.
				]])
            end
        end
    end
end

fetch_vars()
vim.fn.jobstart(query_command, {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
        is_dark_mode = parse_res(data)
        if is_dark_mode then
            vim.o.background = "dark"
        else
            vim.o.background = "light"
        end
        vim.cmd.colorscheme("catppuccin")
    end
})

-- Fallback before vim.fn.jobstart completes async to determine light or dark mode
vim.cmd.colorscheme("catppuccin")

-- built in highlight groups
vim.cmd [[
  highlight CursorLineNR guifg=orange gui=NONE
  highlight LineNr guifg=#1e3f2a guibg=NONE
  highlight clear SignColumn
]]

-- Define highlight groups for custom elements
vim.cmd [[
  highlight MyJSXElement guifg=#f5d784
  highlight MyReactComponent guifg=#f5d784
]]

-- Link JSX tags to the highlight group
vim.api.nvim_set_hl(0, '@tag', { link = 'MyJSXElement' })
