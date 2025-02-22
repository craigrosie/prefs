return {
  'luukvbaal/statuscol.nvim',
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({
      -- config from https://www.reddit.com/r/neovim/comments/1hsyu1a/comment/m59ripb/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      setopt = true,
      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        { text = { '%s' }, click = 'v:lua.ScSa' },
        {
          text = { builtin.lnumfunc, ' ' },
          condition = { true, builtin.not_empty },
          click = 'v:lua.ScLa',
        },
      },
    })
  end,
}
