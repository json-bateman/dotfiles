local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
-- local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key

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
            virt_text = { { "<-", "Error" } },
         },
      },
   },
}

local i = ls.insert_node -- takes a position and optional default text

ls.add_snippets("lua", {
   parse("lf", "local $1 = function($2)\n   $0\nend"),
   s(
      "req",
      fmt("local {} = require('{}')", {
         i(1, "default"),
         rep(1),
      })
   ),
})

local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
for _, value in ipairs(filetypes) do
   ls.add_snippets(value, {
      parse(
         "fcep",
         "type Props = {\n  $3\n}\nexport default function $1(${2:props}: Props) {\nreturn (${4:<></>})$0\n}"
      ),
      parse(
         "fce",
         "export default function $1() {\n  return (\n    ${2:<></>}\n  )$0\n}"
      ),
      parse(
         "imp",
         "import $1 from '$2'"
      ),
      parse(
         "ev",
         "{$1ChangeEvent}<HTML$2Element>$0"
      ),
      s(
         "useS",
         fmt("const [{}, set{setter}] = useState({})", {
            i(1, "state"),
            i(2, "initialValue"),
            setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1)
         })
      ),
      parse(
         "useE",
         "useEffect(() => {\n  $0\n},[])"
      ),
      parse(
         "useC",
         "const {$1context} = useContext($2)$0"
      ),
      parse(
         "useCB",
         "const {$1callback} = useCallback(($2) => {\n  $0\n},[])"
      ),
      parse(
         "useM",
         "const {$1memo} = useMemo(() => {\n  $0\n},[])"
      ),
      parse(
         "useLE",
         "useLayoutEffect(() => {\n  $0\n},[])"
      ),
   })
end
