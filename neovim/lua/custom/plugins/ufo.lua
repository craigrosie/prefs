return {
  'kevinhwang91/nvim-ufo',
  enabled = true,
  dependencies = {
    'kevinhwang91/promise-async',
  },
  config = function()
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set('n', ';R', require('ufo').openAllFolds)
    vim.keymap.set('n', ';M', require('ufo').closeAllFolds)
    vim.keymap.set('n', ';r', require('ufo').openFoldsExceptKinds)
    vim.keymap.set('n', ';m', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set('n', ';k', require('ufo').peekFoldedLinesUnderCursor)
    vim.keymap.set('n', ';a', 'za', { desc = 'Toggle fold under cursor' })
    vim.keymap.set('n', ';A', 'zA', { desc = 'Toggle all folds under cursor' })
    vim.keymap.set({ 'n', 'v' }, ';f', 'zf', { desc = 'Create fold' })

    local filetypeMap = {
      lua = { 'indent' },
    }

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    require('ufo').setup({
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype)
        return filetypeMap[filetype]
      end,
    })
  end,
}
