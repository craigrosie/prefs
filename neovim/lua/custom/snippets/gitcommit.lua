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
  s('br', {
    f(function()
      local handle = io.popen('git rev-parse --abbrev-ref HEAD')
      if not handle then
        return 'Failed to get branch'
      end

      local branch = handle:read('*a'):gsub('\n', '') -- Read output and remove newline
      handle:close()

      -- Match the branch name with the pattern
      local branch_re = '^cr/(%w+)(%-?%d+)'
      local proj, issue = branch:match(branch_re)

      -- If match found, format the output
      if proj and issue then
        return string.upper(proj) .. issue .. ': '
      else
        return 'Invalid branch format'
      end
    end, {}),
  }, {
    desc = 'commit prefix from branch name',
  }),
}
