-- Syntax, color and highlight {{{
vim.api.nvim_command([[syntax enable]])
vim.api.nvim_exec([[
let g:rainbow_active = 1
let g:gruvbox_sign_column = "none"
let g:gruvbox_contrast_dark = 'hard'
]], false)
vim.api.nvim_command([[silent! colorscheme gruvbox_modified]])

