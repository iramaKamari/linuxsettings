vim.api.nvim_command([[syntax on]])
vim.api.nvim_exec([[
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
let g:rainbow_active = 1
let g:nvcode_termcolors = 256
]], false)
vim.api.nvim_command([[silent! colorscheme gruvbox_modified]])
