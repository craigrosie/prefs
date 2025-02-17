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
      <a> = append(<a>, <b>)
      ]],
      {
        a = i(1, 'slice'),
        b = i(2, 'val'),
      },
      { repeat_duplicates = true }
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
        i(1, 'fmt string'),
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
      <a>, <b> := <c>[<d>]
      if !<b> {
        <e>
      }
      ]],
      {
        a = i(1, 'val'),
        b = i(2, 'ok'),
        c = i(3, 'm'),
        d = i(4, 'key'),
        e = i(5, '// code'),
      },
      { repeat_duplicates = true }
    ),
    {
      desc = 'Check if map access is ok',
    }
  ),
  -- Conditionals
  s(
    'if',
    fmt(
      [[
      if <a> <b> <c> {
        <d>
      }
      ]],
      {
        a = i(1, 'a'),
        b = c(2, { t('=='), t('!=') }),
        c = i(3, 'b'),
        d = i(4),
      },
      {
        delimiters = '<>',
      }
    ),
    {
      desc = 'if',
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
      }
    ),
    {
      desc = 'switch',
    }
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
      }
    ),
    {
      desc = 'case',
    }
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
      }
    ),
    {
      desc = 'default case',
    }
  ),
  -- Loops
  s(
    'for',
    fmta(
      [[
      for <a> := <b>; <a> <c> <d>; <a><e> {
        <f>
      }
      ]],
      {
        a = i(1, 'i'),
        b = i(2, '0'),
        c = c(3, { t('<'), t('>'), t('<='), t('>=') }),
        d = i(4, '10'),
        e = c(5, { t('++'), t('--') }),
        f = i(6),
      },
      {
        repeat_duplicates = true,
      }
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
        i(1, 'idx'),
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
  s(
    'while',
    fmta(
      [[
      for <1> <2> <3> {
        <4>
      }
      ]],
      {
        i(1, 'i'),
        c(2, { t('>'), t('<'), t('>='), t('<=') }),
        i(3, '0'),
        i(4),
      },
      {}
    ),
    {
      desc = 'for "while" loop',
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
  s(
    'new',
    fmta(
      [[
      func New<1>() *<1> {
        return &<1>{<2>}
      }
      ]],
      {
        i(1, 'Type'),
        i(2),
      },
      {
        repeat_duplicates = true,
      }
    ),
    {
      desc = 'constructor',
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
        c(3, {
          sn(nil, { r(1, 'returnType') }),
          sn(nil, { t('('), r(1, 'returnType'), t(')') }),
        }),
        i(4),
      },
      {
        stored = {
          -- key passed to restoreNodes.
          ['returnType'] = i(1),
        },
      }
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
        c(2, {
          sn(nil, { r(1, 'returnType') }),
          sn(nil, { t('('), r(1, 'returnType'), t(')') }),
        }),
        i(3),
      },
      {
        stored = {
          -- key passed to restoreNodes.
          ['returnType'] = i(1),
        },
      }
    ),
    {
      desc = 'function inline',
    }
  ),
  s(
    'm',
    fmta(
      [[
      func (<a> <b>) <c>(<d>) <e> {
        <f>
      }
      ]],
      {
        a = d(1, function(args)
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
        b = i(2, 'Type'),
        c = i(3, 'method'),
        d = i(4, 'args'),
        e = c(5, {
          sn(nil, { r(1, 'returnType') }),
          sn(nil, { t('('), r(1, 'returnType'), t(')') }),
        }),
        f = i(6),
      },
      {}
    ),
    {
      desc = 'method',
    }
  ),
  s(
    'main',
    fmta(
      [[
      func main() {
        <1>
      }
      ]],
      {
        i(1),
      },
      {
        desc = 'main',
      }
    )
  ),
  -- Channels
  s(
    'rec',
    fmta(
      [[
      <<-<1>
      ]],
      {
        i(1, 'ch'),
      },
      {}
    ),
    {
      desc = 'channel receive',
    }
  ),
  s(
    'send',
    fmta(
      [[
      <1> <<- <2>
      ]],
      {
        i(1, 'ch'),
        i(2, 'val'),
      }
    ),
    {
      desc = 'send into channel',
    }
  ),
  -- Goroutines
  s(
    'goi',
    fmta(
      [[
      go func() {
        <1>
      }()
      ]],
      {
        i(1),
      },
      {
        desc = 'go inline func',
      }
    )
  ),
  s(
    'sel',
    fmta(
      [[
      select {
      <1>
      }
      ]],
      {
        i(1),
      },
      {}
    ),
    {
      desc = 'select',
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
      t.Errorf("<1> <2> <3> <4>", <5>, <6>)
      ]],
      {
        i(1, 'got'),
        i(2, '%q'),
        i(3, 'want'),
        i(4, '%q'),
        i(5, 'got'),
        i(6, 'want'),
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
        t.Errorf("got %<3> want %<4>", <1>, <2>)
      }
      ]],
      {
        i(1, 'got'),
        i(2, 'want'),
        i(3, 'q'),
        i(4, 'q'),
      },
      { repeat_duplicates = true }
    ),
    {
      desc = 'got want check',
    }
  ),
  s(
    'refl',
    fmta(
      [[
      if !reflect.DeepEqual(<1>, <2>) {
        t.Errorf("<3> %<4> <5> %<6>", <1>, <2>)
      }
      ]],
      {
        i(1, 'got'),
        i(2, 'want'),
        i(3, 'got'),
        i(4, 'q'),
        i(5, 'want'),
        i(6, 'q'),
      },
      { repeat_duplicates = true }
    ),
    {
      desc = 'reflect.DeepEqual check',
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

      for <4>, <5> := range <1> {
        <6>
      }
      ]],
      {
        i(1, 'tests'),
        i(2, 'types'),
        i(3, 'values'),
        i(4, '_'),
        i(5, 'tt'),
        i(6, '// Test code'),
      },
      { repeat_duplicates = true }
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
        <2>
        for i := 0; i << b.N; i++ {
          <3>
        }
      }
      ]],
      {
        i(1, 'Name'),
        i(2),
        i(3, 'UnderTest()'),
      },
      {}
    ),
    {
      desc = 'benchmark',
    }
  ),
  -- Locks
  s(
    'mulu',
    fmta(
      [[
      <1>.Lock()
      defer <1>.Unlock()
      ]],
      {
        i(1, 'mu'),
      },
      {
        repeat_duplicates = true,
      }
    ),
    {
      desc = 'description',
    }
  ),
  -- Comments
  s(
    'todo',
    fmta(
      [[
      // TODO: <1>
      ]],
      {
        i(1, 'description'),
      },
      {}
    ),
    {
      desc = 'todo comment',
    }
  ),
  s(
    'note',
    fmta(
      [[
      // NOTE: <1>
      ]],
      {
        i(1, 'description'),
      },
      {}
    ),
    {
      desc = 'note comment',
    }
  ),
}
