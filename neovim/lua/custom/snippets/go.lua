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
  -- Utils
  s(
    'sv',
    fmta(
      [[
      <1> := <2>
      ]],
      {
        i(1, 'name'),
        i(2, 'val'),
      },
      {}
    ),
    {
      desc = 'short variable declaration',
    }
  ),
  s(
    'app',
    fmta(
      [[
      <1> = append(<2>, <3>)
      ]],
      {
        i(1, 'slice'),
        rep(1),
        i(2, 'val'),
      },
      {}
    ),
    {
      desc = 'append',
    }
  ),
  -- Strings
  s(
    'spf',
    fmta(
      [[
      fmt.Sprintf("<1>", <2>)
      ]],
      {
        i(1, 'format string'),
        i(2, 'args'),
      }
    ),
    {
      desc = 'fmt.Sprintf',
    }
  ),
  --Maps
  s(
    'mok',
    fmta(
      [[
      <1>, <2> := <3>[<4>]
      if !<6> {
        <5>
      }
      ]],
      {
        i(1, 'val'),
        i(2, 'ok'),
        i(3, 'm'),
        i(4, 'key'),
        -- Have to put these out of order for some unknown reason
        -- If the rep() node comes before the last i(), the snippet raises an error
        -- when being saved
        i(5, '// code'),
        rep(2),
      }
    ),
    {
      desc = 'Check if map access is ok',
    }
  ),
  -- Conditionals
  s(
    'ife',
    fmt(
      [[
      if <1> == <2> {
        <3>
      }
      ]],
      {
        i(1, 'a'),
        i(2, 'b'),
        i(3),
      },
      {
        delimiters = '<>',
      }
    ),
    {
      desc = 'if equal',
    }
  ),
  s(
    'ifne',
    fmt(
      [[
      if <1> != <2> {
        <3>
      }
      ]],
      {
        i(1, 'a'),
        i(2, 'b'),
        i(3),
      },
      {
        delimiters = '<>',
      }
    ),
    {
      desc = 'if not equal',
    }
  ),
  -- Switch
  s(
    'swi',
    fmta(
      [[
      switch <1> {
      case <2>:
        <3>
      }
      ]],
      {
        i(1, 'val'),
        i(2, 'case'),
        i(3, '// code'),
      },
      {
        desc = 'switch',
      }
    )
  ),
  s(
    'case',
    fmta(
      [[
      case <1>:
        <2>
      ]],
      {
        i(1, 'case'),
        i(2, '// code'),
      },
      {
        desc = 'case',
      }
    )
  ),
  s(
    'def',
    fmta(
      [[
      default:
        <1>
      ]],
      {
        i(1, '// code'),
      },
      {
        desc = 'default case',
      }
    )
  ),
  -- Loops
  s(
    'for',
    fmta(
      [[
      for <1> := <2>; <3>; <4> {
        <5>
      }
      ]],
      {
        i(1, 'i'),
        i(2, '0'),
        i(3, 'i < 10'),
        i(4, 'i++'),
        i(5),
      },
      {}
    ),
    {
      desc = 'for loop',
    }
  ),
  s(
    'forr',
    fmta(
      [[
      for <1>, <2> := range <3> {
        <4>
      }
      ]],
      {
        i(1, '_'),
        i(2, 'el'),
        i(3, 'obj'),
        i(4, '// body'),
      },
      {}
    ),
    {
      desc = 'for range',
    }
  ),
  -- Structs
  s(
    'st',
    fmta(
      [[
      type <1> struct {
        <2>
      }
      ]],
      {
        i(1, 'Name'),
        i(2),
      },
      {}
    ),
    {
      desc = 'struct',
    }
  ),
  -- Interfaces
  s(
    'it',
    fmta(
      [[
      type <1> interface {
        <2>
      }
      ]],
      {
        i(1, 'Name'),
        i(2),
      },
      {}
    ),
    {
      desc = 'interface',
    }
  ),
  -- Functions
  s(
    'f',
    fmta(
      [[
      func <1>(<2>) <3> {
        <4>
      }
      ]],
      {
        i(1, 'Name'),
        i(2, 'args'),
        i(3, 'returnType'),
        i(4),
      },
      {}
    ),
    {
      desc = 'function',
    }
  ),
  s(
    'fi',
    fmta(
      [[
      func(<1>) <2> {
        <3>
      }
      ]],
      {
        i(1, 'args'),
        i(2, 'returnType'),
        i(3),
      },
      {}
    ),
    {
      desc = 'function inline',
    }
  ),
  s(
    'm',
    fmta(
      [[
      func (<1> <2>) <3>(<4>) <5> {
        <6>
      }
      ]],
      {
        d(1, function(args)
          local receiver_type = args[1][1]

          local idx = 1
          local first_char = receiver_type:sub(1, 1)
          if first_char == '*' then
            idx = 2
          end

          if receiver_type then
            return ls.sn(nil, t(receiver_type:sub(idx, idx):lower()))
          end
          return ls.sn(nil, t('r'))
        end, { 2 }),
        i(2, 'Type'),
        i(3, 'method'),
        i(4, 'args'),
        i(5, 'returnType'),
        i(6),
      },
      {}
    ),
    {
      desc = 'method',
    }
  ),
  -- Errors
  s(
    'errn',
    fmta(
      [[
      errors.New("<1>")
      ]],
      {
        i(1, 'message'),
      },
      {}
    ),
    {
      desc = 'errors.New',
    }
  ),
  -- Testing
  s(
    'terrf',
    fmta(
      [[
      t.Errorf("got %q want %q", <1>, <2>)
      ]],
      {
        i(1, 'got'),
        i(2, 'want'),
      },
      {}
    ),
    {
      desc = 'test error format string',
    }
  ),
  s(
    'test',
    fmta(
      [[
    func Test<1>(t *testing.T) {
      <2>
      got := <3>
      want := <4>

      if <5> {
        t.Errorf("got %<6> want %<7>", got, want<8>)
      }
    }
    ]],
      {
        i(1, 'Name'),
        i(2),
        i(3, 'UnderTest()'),
        i(4, 'expected'),
        c(5, { t('got != want'), t('!reflect.DeepEqual(got, want)') }), -- Choice node
        i(6, 'q'),
        i(7, 'q'),
        i(8),
      },
      {}
    ),
    {
      desc = 'test func',
    }
  ),
  s(
    'thelp',
    fmta(
      [[
      func <1>(t testing.TB, <2>) {
        t.Helper()

        <3>
      }
      ]],
      {
        i(1, 'helperName'),
        i(2),
        d(3, function(_, snip)
          local selected_text = snip.env.SELECT_RAW
          if selected_text and #selected_text > 0 then
            -- If there is selected text, insert it directly
            return ls.sn(nil, t(selected_text))
          else
            -- If no selected text, provide a placeholder insert node
            return ls.sn(nil, i(1, '\t// Helper code'))
          end
        end, {}),
      },
      {}
    ),
    {
      desc = 'test helper',
    }
  ),
  s(
    'thelpi',
    fmta(
      [[
      <1> := func(t testing.TB, <2>) {
        t.Helper()

        <3>
      }
      ]],
      {
        i(1, 'helperName'),
        i(2),
        i(3),
      },
      {}
    ),
    {
      desc = 'test helper inline',
    }
  ),
  s(
    'gw',
    fmta(
      [[
      if <1> != <2> {
        t.Errorf("got %<3> want %<4>", <5>, <6>)
      }
      ]],
      {
        i(1, 'got'),
        i(2, 'want'),
        i(3, 'q'),
        i(4, 'q'),
        rep(1),
        rep(2),
      },
      {}
    ),
    {
      desc = 'got want check',
    }
  ),
  s(
    'testt',
    fmta(
      [[
      <1> := []struct {
        <2>
      }{
        <3>
      }

      for <4>, <5> := range <6> {
        <7>
      }
      ]],
      {
        i(1, 'tests'),
        i(2, 'types'),
        i(3, 'values'),
        i(4, '_'),
        i(5, 'tt'),
        rep(1),
        i(7, '// Test code'),
      },
      {}
    ),
    {
      desc = 'table driven test',
    }
  ),
  s(
    'subtest',
    fmta(
      [[
      t.Run("<1>", func(t *testing.T) {
        <2>
      })
      ]],
      {
        i(1, 'description'),
        d(2, function(_, snip)
          local selected_text = snip.env.SELECT_RAW
          if selected_text and #selected_text > 0 then
            -- If there is selected text, insert it directly
            return ls.sn(nil, t(selected_text))
          else
            -- If no selected text, provide a placeholder insert node
            return ls.sn(nil, i(1, '\t// Test code'))
          end
        end, {}),
      },
      {}
    ),
    {
      desc = 'subtest',
    }
  ),
  s(
    'bench',
    fmta(
      [[
      func Benchmark<1>(b *testing.B) {
        for i := 0; i << b.N; i++ {
          <2>
        }
      }
      ]],
      {
        i(1, 'Name'),
        i(2, 'UnderTest()'),
      },
      {}
    ),
    {
      desc = 'test func',
    }
  ),
}
