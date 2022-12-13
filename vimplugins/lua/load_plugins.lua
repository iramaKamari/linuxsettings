-- Plugins {{{
require "paq" {
  "savq/paq-nvim";
  -- PlantUML
  "aklt/plantuml-syntax",
  "tyru/open-browser.vim",
  "weirongxu/plantuml-previewer.vim",
  -- LSP
  "neovim/nvim-lspconfig";
  "simrat39/rust-tools.nvim";
  -- Completion
  "hrsh7th/nvim-cmp";
  "hrsh7th/cmp-nvim-lsp";
  "hrsh7th/cmp-buffer";
  "hrsh7th/cmp-path";
  "hrsh7th/cmp-cmdline";
  "hrsh7th/cmp-nvim-lsp-signature-help";
  "ray-x/cmp-treesitter";
  ---- Rust
  "Saecki/crates.nvim";
  "nvim-lua/plenary.nvim"; -- Required by crates.nvim
  -- Snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  -- Fuzzy finding of files/buffers etc
  {"junegunn/fzf", run = "./install --bin"};
  {"ibhagwan/fzf-lua", branch = "main"};
  --{"nvim-telescope/telescope.nvim", branch = "0.1.x"},
  --'nvim-lua/plenary.nvim',
  -- Different color for selected search match
  "PeterRincker/vim-searchlight";
  -- Better quickfix list
  "kevinhwang91/nvim-bqf";
  -- Syntax highlighters
  {"nvim-treesitter/nvim-treesitter", run=function() vim.cmd "TSUpdate" end};
  "frazrepo/vim-rainbow";
}

require("load_keymappings")
require("load_nvim_treesitter")
require("load_plantuml")
require("load_better_quick_fix")
require("load_cmp")
require("load_fzf")

require("lsp.load_settings")
require("load_options")
require("load_statusline")
require("load_tabline")
