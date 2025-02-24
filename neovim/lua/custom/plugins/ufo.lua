return {
  'kevinhwang91/nvim-ufo',
  enabled = true,
  dependencies = {
    'kevinhwang91/promise-async',
  },
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set('n', '<leader>uR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', '<leader>uM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', '<leader>ur', require('ufo').openFoldsExceptKinds, { desc = 'Open all folds except kinds' })
    vim.keymap.set('n', '<leader>um', require('ufo').closeFoldsWith, { desc = 'Close all folds with' }) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set(
      'n',
      '<leader>uk',
      require('ufo').peekFoldedLinesUnderCursor,
      { desc = 'Peek folded lines under cursor' }
    )
    vim.keymap.set('n', '<leader>ua', 'za', { desc = 'Toggle fold under cursor' })
    vim.keymap.set('n', '<leader>uA', 'zA', { desc = 'Toggle all folds under cursor' })
    vim.keymap.set({ 'n', 'v' }, '<leader>uf', 'zf', { desc = 'Create fold' })
    vim.keymap.set('n', '<leader>ud', 'zd', { desc = 'Delete fold' })

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
