return {
  'pmizio/typescript-tools.nvim',
  event = 'VeryLazy',
  disable = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
  },
  opts = {
    settings = {
      expose_as_code_actions = {
        'none',
      },
      tsserver_plugins = {
        '@styled/typescript-styled-plugin',
      },
      tsserver_file_preferences = {
        jsx = 'react-jsx',
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeAutomaticOptionalChainCompletions = true,
        includeCompletionsWithClassMemberSnippets = true,
        allowIncompleteCompletions = true,
        includeInlayParameterNameHints = 'all',
        importModuleSpecifierPreference = 'relative',
        quotePreference = 'single',
      },
    },
  },
  keys = {},
}
