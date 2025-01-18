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
  --lua helpers
  s(
    'f',
    fmta(
      [[
      function()
        <1>
      end
      ]],
      {
        d(1, function(_, snip)
          local selected_text = snip.env.SELECT_RAW
          if selected_text and #selected_text > 0 then
            -- If there is selected text, insert it directly
            return ls.sn(nil, t(selected_text))
          else
            -- If no selected text, provide a placeholder insert node
            return ls.sn(nil, i(1, '\t-- func body'))
          end
        end, {}),
      },
      {}
    ),
    {
      desc = 'function',
    }
  ),
  s(
    'lreq',
    fmta(
      [[
      local <1> = require('<2>')
      ]],
      {
        i(1, 'var'),
        i(2, 'module'),
      },
      {}
    ),
    {
      desc = 'local require',
    }
  ),
  s(
    'km',
    fmta(
      [[
      vim.keymap.set({ '<1>' }, '<2>', function()
        <3>
      end, { desc = '<4>'})
      ]],
      {
        i(1, 'modes'),
        i(2, 'key'),
        i(3, 'action'),
        i(4, 'description'),
      },
      {}
    ),
    {
      desc = 'keymap',
    }
  ),
  -- luasnip snippets
  s(
    'snip',
    -- Use [=[ to allow [[ inside the string
    fmta(
      [=[
      s(
        '<1>',
        fmta(
          [[
          <2>
          ]],
          {
            <3>
          },
          {
            desc = '<4>',
          }
        )
      ),
      ]=],
      {
        i(1, 'trigger'),
        i(2, 'content'),
        i(3, 'nodes'),
        i(4, 'description'),
      },
      {}
    ),
    {
      desc = 'snippet',
    }
  ),
  s(
    'ch',
    fmta(
      [[
      c(<1>, {<2>})
      ]],
      {
        i(1, 'index'),
        i(2, 'choices'),
      },
      {}
    ),
    {
      desc = 'choice node',
    }
  ),
  -- lazy.nvim module
  s(
    'mod',
    fmta(
      [[
      return {
        '<1>',
        <2>,
      }
      ]],
      {
        i(1, 'module/path'),
        i(2),
      },
      {}
    ),
    {
      desc = 'lazy.nvim module',
    }
  ),
}
