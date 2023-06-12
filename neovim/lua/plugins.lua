-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }

  use { 'navarasu/onedark.nvim' }

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/playground' }
  use { 'nvim-treesitter/nvim-treesitter-context' }
  use { 'jose-elias-alvarez/null-ls.nvim' }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {
    'ibhagwan/fzf-lua',
    requires = {
      'kyazdani42/nvim-web-devicons' -- optional, for file icons
    }
  }
  use {
    "hrsh7th/nvim-cmp",
    -- https://github.com/hrsh7th/nvim-cmp/issues/1565
    commit = "1cad30fcffa282c0a9199c524c821eadc24bf939",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-path',
      'f3fora/cmp-spell',
      'octaltree/cmp-look',
      'quangnguyen30192/cmp-nvim-ultisnips',
      'onsails/lspkind.nvim',
    }
  }
  use { 'SirVer/ultisnips' }
  use { "ray-x/lsp_signature.nvim" }
  use { "mfussenegger/nvim-dap" }
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
  use { 'mfussenegger/nvim-dap-python' }
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    }
  }
  -- https://github.com/junegunn/fzf.vim/issues/1388#issuecomment-1114371227
  use { 'junegunn/fzf', run = ":call fzf#install()" }
  use { 'junegunn/fzf.vim' }
  use { 'voldikss/fzf-floaterm' }
  use { 'voldikss/vim-floaterm' }
  use { 'tpope/vim-surround' }
  use { 'simrat39/symbols-outline.nvim' }
  use { 'lewis6991/gitsigns.nvim' }
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
  }
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
  }
  use {
    "utilyre/barbecue.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "smiteshp/nvim-navic",
      "kyazdani42/nvim-web-devicons", -- optional
    },
  }
  use { "almo7aya/openingh.nvim" }
  use { 'yssl/QFEnter' }
  use { 'rmagatti/goto-preview' }
  use { 'ojroques/nvim-osc52' }
  use { 'karb94/neoscroll.nvim' }
  use { 'stevearc/dressing.nvim' }
  use { "lukas-reineke/indent-blankline.nvim" }
  use { "ofirgall/cmp-lspkind-priority" }
  use { 'AckslD/nvim-pytrize.lua' }
  use { 'echasnovski/mini.nvim', branch = 'stable' }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'theHamsta/nvim-dap-virtual-text' }
  use { 'tzachar/local-highlight.nvim' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  -- use { 'VidocqH/lsp-lens.nvim' }
  use { 'dnlhc/glance.nvim' }
  use { 'petertriho/nvim-scrollbar' }
  use { 'ethanholz/nvim-lastplace' }
  use { 'ray-x/cmp-treesitter' }
  -- https://github.com/ray-x/guihua.lua/issues/16
  -- use({
  --   'ray-x/navigator.lua',
  --   requires = {
  --       { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
  --       { 'neovim/nvim-lspconfig' },
  --   },
  -- })
  use { 'LiadOz/nvim-dap-repl-highlights' }
  use { 'kazhala/close-buffers.nvim' }
  use {
    "zbirenbaum/copilot.lua",
  }
  use {
    "zbirenbaum/copilot-cmp",
  }
  use { 'm-demare/hlargs.nvim' }
end)
