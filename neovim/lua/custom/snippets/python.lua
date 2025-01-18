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
    'init',
    fmt(
      [[
      def __init__(self{1}):
        {2}
      ]],
      {
        i(1, ', '),
        i(2, 'pass'),
      }
    ),
    {
      desc = '__init__',
    }
  ),
  s(
    'repr',
    fmt(
      [[
      def __repr__(self):
        return f"{{{1}}}{2}"
      ]],
      {
        i(1, 'type(self).__name__'),
        i(2),
      }
    ),
    {
      desc = '__init__',
    }
  ),
  s(
    'def',
    fmt(
      [[
      def {1}({2}) -> {3}:
        {4}
      ]],
      {
        i(1, 'func_name'),
        i(2, 'args'),
        i(3, 'ReturnType'),
        i(4, 'pass'),
      }
    ),
    {
      desc = 'def',
    }
  ),
  s(
    'adef',
    fmt(
      [[
      async def {1}({2}) -> {3}:
        {4}
      ]],
      {
        i(1, 'func_name'),
        i(2, 'args'),
        i(3, 'ReturnType'),
        i(4, 'pass'),
      }
    ),
    {
      desc = 'async def',
    }
  ),
  s(
    'deft',
    fmt(
      [[
      def test_{1}({2}) -> None:
        {3}
      ]],
      {
        i(1),
        i(2, 'args'),
        i(3),
      }
    ),
    {
      desc = 'test function',
    }
  ),
  s(
    'adeft',
    fmt(
      [[
      @pytest.mark.asyncio
      async def test_{1}({2}) -> None:
        {3}
      ]],
      {
        i(1),
        i(2, 'args'),
        i(3),
      }
    ),
    {
      desc = 'test function',
    }
  ),
  s(
    'param',
    fmt(
      [[
      @pytest.mark.parametrize(
        ("{1}", "expected"),
        [
          ({2}, {3}),
        ]
      )
      ]],
      {
        i(1),
        i(2),
        i(3),
      }
    ),
    {
      desc = 'parametrized test',
    }
  ),
  s(
    'ptest',
    fmt(
      [[
      @pytest.mark.parametrize(
        ("{1}", "expected"),
        [
          ({2}, {3}),
        ]
      )
      def test_{4}({5}, expected: {6}) -> None:
        result = {7}({8})

        assert result {9} expected
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6, 'ExpectedType'),
        i(7, 'test_func'),
        i(8, 'args'),
        i(9, '=='),
      }
    ),
    {
      desc = 'parametrized test',
    }
  ),
  s(
    'todo',
    fmt(
      [[
      # TODO: 
      ]],
      {}
    ),
    {
      desc = 'todo comment',
    }
  ),
  s(
    'note',
    fmt(
      [[
      # NOTE: 
      ]],
      {}
    ),
    {
      desc = 'note comment',
    }
  ),
  s('ev', {
    f(function(args)
      local input = args[1][1] or ''
      local transformed = input:upper():gsub(' ', '_'):gsub('-', '_')
      return transformed .. ' = '
    end, { 1 }), -- The function node depends on the first input node
    t('"'),
    i(1, 'value'),
    t('"'),
  }, { desc = 'enum value' }),
  s(
    'kv',
    fmt(
      [[
      {1} = {2}
      ]],
      { i(1), i(2) }
    ),
    {
      desc = 'note comment',
    }
  ),
}
