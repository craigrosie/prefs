return {
  'kazhala/close-buffers.nvim',
  event = 'VeryLazy',
  opts = { preserve_window_layout = { 'this' } },
  keys = {
    { '<leader>cb', ":lua require('close_buffers').delete({type = 'hidden'})<CR>", desc = '[c]lose [b]uffers' },
  },
}
