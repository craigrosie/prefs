local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.conditions')
local conds_expand = require('luasnip.extras.conditions.expand')

return {
  s(
    'skill',
    fmta(
      [[
      ---
      name: <1>
      description: <2>
      ---

      <3>
      ]],
      {
        i(1, 'skill name'),
        i(2, 'skill description'),
        i(3, 'skill implementation details'),
      },
      {}
    ),
    {
      desc = 'skill',
    }
  ),
  s(
    'agent',
    fmta(
      [[
      ---
      name: <1>
      description: <2>
      model: <3>
      tools: [<4>]
      ---
      
      <5>
      ]],
      {
        i(1, 'name'),
        i(2, 'description'),
        i(3, 'model name'),
        i(4, 'tool1, tool2, ...'),
        i(5, 'agent implementation details'),
      },
      {}
    ),
    {
      desc = 'agent',
    }
  ),
}
