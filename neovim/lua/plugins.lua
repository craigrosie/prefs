-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
  { "navarasu/onedark.nvim", lazy = false, priority = 1000 },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "jose-elias-alvarez/null-ls.nvim" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly", -- optional, updated every week. (see issue #1193)
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icons
    },
  },
  {
    "hrsh7th/nvim-cmp",
    -- https://github.com/hrsh7th/nvim-cmp/issues/1565
    commit = "1cad30fcffa282c0a9199c524c821eadc24bf939",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "octaltree/cmp-look",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "onsails/lspkind.nvim",
    },
  },
  { "SirVer/ultisnips" },
  { "ray-x/lsp_signature.nvim" },

  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  { "mfussenegger/nvim-dap-python" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
  }, -- https://github.com/junegunn/fzf.vim/issues/1388#issuecomment-1114371227
  { "junegunn/fzf", build = ":call fzf#install()" },
  { "junegunn/fzf.vim" },
  { "voldikss/vim-floaterm" },
  {
    "voldikss/fzf-floaterm",
    -- Pinning due to https://github.com/voldikss/fzf-floaterm/pull/5
    -- breaking showing terminal title in fzf window
    commit = "66a30db85a7adf573af9b8a4f3f8c4ce0a2d665e",
  },
  { "tpope/vim-surround" },
  { "simrat39/symbols-outline.nvim" },
  { "lewis6991/gitsigns.nvim" },
  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "kyazdani42/nvim-web-devicons" },
  },
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "smiteshp/nvim-navic",
      "kyazdani42/nvim-web-devicons", -- optional
    },
  },
  { "almo7aya/openingh.nvim" },
  { "yssl/QFEnter" },
  { "rmagatti/goto-preview" },
  { "ojroques/nvim-osc52" },
  { "karb94/neoscroll.nvim" },
  { "stevearc/dressing.nvim" },
  { "lukas-reineke/indent-blankline.nvim", tag = "v2.20.8" },
  { "ofirgall/cmp-lspkind-priority" },
  { "AckslD/nvim-pytrize.lua" },
  { "echasnovski/mini.nvim", branch = "stable" },
  { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "tzachar/local-highlight.nvim" },
  { "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons", lazy = true } },
  { "VidocqH/lsp-lens.nvim" },
  { "dnlhc/glance.nvim" },
  { "petertriho/nvim-scrollbar" },
  { "ethanholz/nvim-lastplace" },
  { "ray-x/cmp-treesitter" }, -- https://github.com/ray-x/guihua.lua/issues/16
  -- use({
  --   'ray-x/navigator.lua',
  --   dependencies = {
  --       { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
  --       { 'neovim/nvim-lspconfig' },
  --   },
  -- })
  { "LiadOz/nvim-dap-repl-highlights" },
  { "kazhala/close-buffers.nvim" },
  { "zbirenbaum/copilot.lua" },
  { "zbirenbaum/copilot-cmp" },
  { "m-demare/hlargs.nvim" },
  { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end },
  { "MunifTanjim/prettier.nvim" },
  { "stevearc/overseer.nvim" },
  { "rcarriga/nvim-notify" },
  { "Glench/Vim-Jinja2-Syntax" },
  {
    "RRethy/vim-hexokinase",
    build = "make hexokinase",
    ft = { "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact", "jinja2" },
  },
  { "chrisgrieser/nvim-spider" },
  { "mvllow/modes.nvim" },
  -- Too noisy
  -- use { 'andersevenrud/nvim_context_vt' }
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "rmagatti/auto-session" },
})
