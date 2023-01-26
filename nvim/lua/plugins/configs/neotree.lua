local ok, neotree = pcall(require, 'neo-tree')
if (not ok) then return end

neotree.setup({
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  window = {
    position = "left",
    width = 35,
  },
})
