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
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
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
  use { 'tpope/vim-commentary' }
  use { 'mileszs/ack.vim' }
  use { 'tpope/vim-surround' }
  use { 'simrat39/symbols-outline.nvim' }
  use { 'lewis6991/gitsigns.nvim' }
   
end)
