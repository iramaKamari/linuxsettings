local fzf = require("fzf-lua")
local keymap_opts = { noremap = true, silent = false }
vim.keymap.set('n', '§', function() fzf.buffers() end, keymap_opts)
vim.keymap.set('n', '<leader>g', function() fzf.grep({ search = vim.fn.input("Grep for > ") }) end, keymap_opts)
vim.keymap.set('n', '<leader>G', function() fzf.grep_cword() end, keymap_opts)
vim.keymap.set("n", "<leader>f", function() fzf.files() end, keymap_opts)
vim.keymap.set("n", "<leader>F", ':FzfLua<space>', keymap_opts)
--vim.api.nvim_set_var('g:fzf_colors', "{'fg': ['fg', 'Normal'], 'bg': ['bg', 'Normal'], 'hl': ['fg', 'Comment'], 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+': ['bg', 'CursorLine', 'CursorColumn'], 'hl+': ['fg', 'Statement'], 'info': ['fg', 'PreProc'], 'border': ['fg', 'Ignore'], 'prompt': ['fg', 'Identifier'], 'pointer': ['fg', 'Exception'], 'marker': ['fg', 'Identifier'], 'spinner': ['fg', 'Label'], 'header': ['fg', 'Comment'] }")
fzf.setup{
  winopts = {
    hl = {
      border = "Normal",
    },
    preview = {
      wrap = 'wrap',
      vertical = 'down:70%',
      layout = 'vertical',
    },
  },
}
