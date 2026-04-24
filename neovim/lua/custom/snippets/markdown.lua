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
      permission:
        <4>
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
  s(
    'perms',
    fmta(
      [[
      bash: <1>
      codesearch: <2>
      doom_loop: <3>
      edit: <4>
      external_directory: <5>
      glob: <6>
      grep: <7>
      lsp: <8>
      question: <9>
      read: <10>
      skill: <11>
      task: <12>
      webfetch: <13>
      websearch: <14>
      ]],
      {
        c(1, { t('allow'), t('ask'), t('deny'), t('') }),
        c(2, { t('allow'), t('ask'), t('deny'), t('') }),
        c(3, { t('allow'), t('ask'), t('deny'), t('') }),
        c(4, { t('allow'), t('ask'), t('deny'), t('') }),
        c(5, { t('allow'), t('ask'), t('deny'), t('') }),
        c(6, { t('allow'), t('ask'), t('deny'), t('') }),
        c(7, { t('allow'), t('ask'), t('deny'), t('') }),
        c(8, { t('allow'), t('ask'), t('deny'), t('') }),
        c(9, { t('allow'), t('ask'), t('deny'), t('') }),
        c(10, { t('allow'), t('ask'), t('deny'), t('') }),
        c(11, { t('allow'), t('ask'), t('deny'), t('') }),
        c(12, { t('allow'), t('ask'), t('deny'), t('') }),
        c(13, { t('allow'), t('ask'), t('deny'), t('') }),
        c(14, { t('allow'), t('ask'), t('deny'), t('') }),
      },
      {}
    ),
    {
      desc = 'agent permissions',
    }
  ),
}
