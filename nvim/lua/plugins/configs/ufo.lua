local ok, ufo = pcall(require, "ufo")
if not ok then return end

ufo.setup({
   open_fold_hl_timeout = 0,
   provider_selector = function()
      return { "treesitter", "indent" }
   end
})
