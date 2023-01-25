local ok, colorizer = pcall(require, 'colorizer')
if (not ok) then return end

colorizer.setup {
  'css'; 'lua'; 'tsx'; 'js'; 'ts';
  lua = {
    mode = 'foreground';
  }; -- Enable parsing rgb(...) functions in css.
  css = {
    css = true,
    css_fn = true,
    mode = 'foreground';
  }; -- Enable parsing rgb(...) functions in css.
}
