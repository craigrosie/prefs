return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme('tokyonight-night')

      -- You can configure highlights by doing something like:
      vim.cmd.hi('Comment gui=none')
    end,
    opts = {
      -- Make tokyonight colours a bit more vibrant
      on_colors = function(colors)
        local hsluv = require('tokyonight.hsluv')
        local multiplier = 2.0

        for k, v in pairs(colors) do
          if type(v) == 'string' and v ~= 'NONE' then
            local hsv = hsluv.hex_to_hsluv(v)
            hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
            colors[k] = hsluv.hsluv_to_hex(hsv)
          elseif type(v) == 'table' then
            if vim.islist(v) then
              for kk, vv in ipairs(v) do
                if type(vv) == 'string' and vv ~= 'NONE' then
                  local hsv = hsluv.hex_to_hsluv(vv)
                  hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                  colors[k][kk] = hsluv.hsluv_to_hex(hsv)
                end
              end
            else
              for kk, vv in pairs(v) do
                if type(vv) == 'string' and vv ~= 'NONE' then
                  local hsv = hsluv.hex_to_hsluv(vv)
                  hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                  colors[k][kk] = hsluv.hsluv_to_hex(hsv)
                end
              end
            end
          end
        end
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
