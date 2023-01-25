-- For Lualine
local colors = {
    darkgray = "#16161d",
    gray = "#888169",
    innerbg = "#16161d",
    outerbg = "#16161d",
    gruvStatusText = "#ebdbb2",
    defaultGruvLine = "#504945",
    darkStatusLine = "#303030",
    normal = "#cca066",
    insert = "#98bb6c",
    visual = "#7e9cd8",
    replace = "#e46876",
    command = "#e6c384",
}

require("lualine").setup({
  options = {
    theme = {
      inactive = {
        a = { fg = colors.gray, bg = colors.darkStatusLine, nil },
        b = { fg = colors.gray, bg = colors.darkStatusLine},
        c = { fg = colors.gray, bg = colors.darkStatusLine },
      },
      visual = {
        a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
        b = { fg = colors.f, bg = colors.outerbg},
        c = { fg = colors.gray, bg = colors.darkStatusLine },
      },
      replace = {
        a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg},
        c = { fg = colors.gruvStatusText, bg = colors.darkStatusLine },
      },
      normal = {
        a = { fg = colors.innerbg, bg = colors.normal, gui = "bold" },
        b = { fg = colors.gruvStatusText, bg = colors.darkStatusLine},
        c = { fg = colors.gruvStatusT, bg = colors.darkStatusLine },
      },
      insert = {
        a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerb},
        c = { fg = colors.gray, bg = colors.darkStatusLine },
      },
      command = {
        a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg},
        c = { fg = colors.gray, bg = colors.darkStatusLine },
      },
    },
  },
  tabline = {
    lualine_a = {'buffers'}
  },
})
