return {
  'mawkler/refjump.nvim',
  keys = { ']r', '[r' },
  opts = {
    keymaps = {
      enable = true,
      next = ']r', -- Keymap to jump to next LSP reference
      prev = '[r', -- Keymap to jump to previous LSP reference
    },
    highlights = {
      enable = true, -- Highlight the LSP references on jump
      auto_clear = true, -- Automatically clear highlights when cursor moves
    },
    integrations = {
      demicolon = {
        enable = true, -- Make `]r`/`[r` repeatable with `;`/`,` using demicolon.nvim
      },
    },
    verbose = true, -- Print message if no reference is found
  },
}
