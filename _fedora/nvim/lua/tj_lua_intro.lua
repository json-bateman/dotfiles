local M = {}

M.setup = function(opts)
  print('Options: ', opts)
end

-- functions we need
-- vim.keymap.set() -> add new keymaps for popup window
-- vim.api.nvim_get_keymap() -> see all the current keymaps so we don't overwrite

local find_mapping = function(maps, lhs)
  -- pairs
  --    iterates over EVERY key in table, order not guaranteed.
  -- ipairs
  --    iterates over ONLY numberic keys in table, order IS guaranteed.

  for _, value in ipairs(maps) do
    if lhs == value.lhs then
      return value
    end
  end
end

M._stack = {}

M.push = function(name, mode, mappings)
  local maps = vim.api.nvim_get_keymap(mode)
  local existing_maps = {}
  for lhs, rhs in pairs(mappings) do
    local existing = find_mapping(maps, lhs)
    if existing then
      table.insert(existing_maps, existing)
    end
  end
  -- P(existing_maps)
  M._stack[name] = existing_maps

  for lhs, rhs in pairs(mappings) do
    vim.keymap.set(mode, lhs, rhs)
  end
end

M.pop = function(name)
  local state = M._stack[name]
  M._stack[name] = nil
end

M.push("debug_mode", "n", {
  [" rg"] = ":echo 'remapped'",
  [" ff"] = ":echo 'found it'",
  [" s"] = ":echo 'sup'",
})
-- lua.require("mapstack").push("debug_mode, {
-- })
-- lua.require("mapstack").pop("debug_mode, {
-- })

return M
