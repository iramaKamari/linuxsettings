require("load_plugins")

vim.api.nvim_exec([[autocmd BufEnter *.ifx setlocal filetype=bash]], false)
