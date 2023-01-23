local present, ls = pcall(require, "luasnip")
if (not present) then return end

local snip = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local func = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local fmt = require("luasnip.extras.fmt").fmt
-- local extras = require("luasnip.extras")
-- local m = extras.m
-- local l = extras.l
-- local rep = extras.rep
-- local postfix = require("luasnip.extras.postfix").postfix
local date = function() return { os.date('%Y-%m-%d') } end

ls.add_snippets(nil, {
  all = {
    snip({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      func(date, {}),
    }),
    snip({ trig = "trigger" }, {
      t({ "After expanding, the cursor is here ->" }), i(1),
      t({ "", "After jumping forward once, cursor is here ->" }), i(2),
      t({ "", "After jumping once more, the snippet is exited there ->" }), i(0),
    }),
    snip({
      trig = "tsc",
      name = "tsc",
      dscr = "TypeScript Component",
    }, {
      t({
        "import { ReactElement } from 'react'",
        "",
        "export default function "
      }),
      i(1, "name"),
      t({
        "(): ReactElement {",
        "  return (",
        "    <div>",
        "      ",
      }), i(0),
      t({
        "",
        "    </div>",
        "  )",
        "}",
      })
    }),
  },
})
