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

local function capitalise(input)
  return input:gsub('^%l', string.upper)
end

return {
  s(
    'exdf',
    fmt(
      [[
        export default function {1}({2}) {{
          {3}
        }}
      ]],
      {
        -- i(1) is at nodes[1], i(2) at nodes[2].
        i(1, 'FunctionName'),
        i(2),
        i(3),
      }
    ),
    {
      desc = 'export default function',
    }
  ),
  s('usestate', {
    t('const ['),
    i(1), -- First input node
    t(', set'),
    d(2, function(args)
      local input = args[1][1] or ''
      local capitalised = capitalise(input)
      return sn(nil, {
        t(capitalised), -- Convert the first character of the input to uppercase
      })
    end, { 1 }), -- The dynamic_node depends on the first input node
    t('] = useState('),
    i(3), -- Second input node
    t(');'),
  }, {
    desc = 'useState',
  }),
  s(
    'arr',
    fmt(
      [[
        ({1}) => (
          {2}
        )
      ]],
      {
        i(1, 'args'),
        i(2),
      }
    ),
    {
      desc = 'inline arrow function',
    }
  ),
  s(
    'arrb',
    fmt(
      [[
        ({1}) => {{
          {2}
        }}
      ]],
      {
        i(1, 'args'),
        i(2),
      }
    ),
    {
      desc = 'inline arrow function with body',
    }
  ),
  s(
    'cf',
    fmt(
      [[
      const {1} = ({2}) => {{
        {3}
      }};
      ]],
      {
        i(1, 'funcName'),
        i(2, 'args'),
        i(3),
      }
    ),
    {
      desc = 'const function',
    }
  ),
}
