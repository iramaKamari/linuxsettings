vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('autoread', true)
vim.api.nvim_set_option('guicursor', "")
vim.api.nvim_set_option('lazyredraw', true)
vim.api.nvim_set_option('showmatch', true)
vim.api.nvim_set_option('complete', '.,w,b,u,t')
vim.api.nvim_set_option('completeopt', 'menu,menuone,noinsert,noselect')
vim.api.nvim_set_option('wildmode', 'longest:full,full')
vim.api.nvim_command([[set signcolumn=number]])

vim.api.nvim_command([[set noswapfile nobackup noshowmode]])
vim.api.nvim_command([[set cursorline]])
vim.api.nvim_command([[set mouse=]])
vim.api.nvim_command([[set path+=**]])
-- Extend MatchParen list
vim.api.nvim_command([[set mps+=<:>]])

vim.api.nvim_command([[set splitbelow splitright]])
vim.api.nvim_exec([[autocmd VimResized * wincmd =]], false)

-- Buffer settings
vim.api.nvim_buf_set_option(0, 'textwidth', 0)
vim.api.nvim_buf_set_option(0, 'tabstop', 4)
vim.api.nvim_buf_set_option(0, 'shiftwidth', 4)
vim.api.nvim_buf_set_option(0, 'expandtab', false)
vim.api.nvim_buf_set_option(0, 'smartindent', true)
vim.api.nvim_buf_set_option(0, 'autoindent', true)

vim.api.nvim_command([[set number relativenumber]])
vim.api.nvim_exec([[
augroup buffer_number_toggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave * setlocal relativenumber
autocmd BufLeave,FocusLost,InsertEnter   * setlocal norelativenumber
augroup END
]], false)

vim.api.nvim_exec([[
augroup terminal_number_toggle
autocmd!
autocmd TermOpen,TermEnter term://* startinsert
autocmd TermLeave,TermClose term://* stopinsert
autocmd TermOpen,TermEnter term://* :setlocal nonumber norelativenumber
autocmd TermLeave,TermClose term://* :setlocal nonumber norelativenumber
augroup END
]], false)

-- Omnicomple in insert mode
vim.api.nvim_exec([[
autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
]], false)
