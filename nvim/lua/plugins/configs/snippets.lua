local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config {
  -- tells luasnip to remember to keep around the last snippet
  history = true,
  -- updates dynamic snippets as you type
  updateevents = "TextChanged, TextChangedI",

  -- Autosnippets
  enable_autosnippets = true,
  -- highlights!
  -- #vid3

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = {{"<-", "Error"}},
      },
    },
  },
}

ls.add_snippets("all",  {
  ls.parser.parse_snippet("expand", "-- this is what was expanded!"),
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\nend"),
})

local i = ls.insert_node -- takes a position and optional default text
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
-- ls.s is a snippet creator
ls.add_snippets("lua", {
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\nend"),
  ls.s("try", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
})

require("luasnip.loaders.from_vscode").lazy_load()
