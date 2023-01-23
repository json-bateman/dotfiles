local find_map = function(maps, lhs)
  for _, map in ipairs(maps) do
    if lhs == map.lhs then
      return map
    end
  end
end

describe("c_tourna", function()
  it("can be required", function()
    require("c_tourna")
  end)

  it("can push a single mapping", function()
    require('c_tourna').push("test1", "n", {
      asdfasdf = "echo 'this is a test'"
    })

    local maps = vim.api.nvim_get_keymap('n')
    local found = find_map(maps, "asdfasdf")
    assert.are.same("echo 'this is a test'", found.rhs)
  end)
end)
