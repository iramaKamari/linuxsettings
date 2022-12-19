require('nvim-treesitter.configs').setup {
  auto_install = true,
  highlight = {
    additional_vim_regex_highlighting = true,
    enable = true,
    disable = function(_, buf)
      local max_filesize = 50000
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    custom_captures = {
      ["TSError"] = "Normal",
    },
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

