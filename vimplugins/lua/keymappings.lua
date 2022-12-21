vim.api.nvim_set_keymap('', '<space>', '<nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap('n', '<leader>w', ':split<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>v', ':vs<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>J', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>K', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>L', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>H', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Up>', '<C-w><C-+>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Down>', '<C-w><C-->', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Left>', '<C-w><C->>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Right>', '<C-w><C-<>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<leader>b', '<C-^>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '§', ':ls<CR>:b<space>', { noremap = true, silent = true })
-- Move between splits
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w><C-j>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w><C-k>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w><C-l>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w><C-h>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
--vim.api.nvim_set_keymap('x', 'p', '"_dP"', { noremap = true, silent = true })
-- Move lines up and down in normal/insert/visual mode
vim.api.nvim_set_keymap('n', '<S-Down>', ':m +1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>', ':m -2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Down>', '<Esc>:m +1<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Up>', '<Esc>:m -2<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Down>', '<Esc>:m +1<CR>gv=gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Up>', '<Esc>:m -2<CR>gv=gv', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>n', ':normal ', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('i', 'kk', '<esc>', { noremap = true, silent = true })
-- Replace all occurences on a line
vim.api.nvim_set_keymap('n', '<leader>r', ':s/<C-r><C-w>//g<Left><Left>', { noremap = true, silent = false })
-- Replace all occurences in a file
vim.api.nvim_set_keymap('n', '<leader>R', ':%s/<C-r><C-w>//gc<Left><Left><Left>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<CR>', { noremap = true, silent = true })
-- Range commands for incsearch
vim.api.nvim_set_keymap('c', '$t', '<CR>:t\'\'<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '$m', '<CR>:m\'\'<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '$d', '<CR>:d<CR>``', { noremap = true, silent = true })
-- Tig in own tab
vim.api.nvim_set_keymap('', '<leader>l', ':-tab split<CR> :terminal tig %<Return>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>B', ':-tab split<CR> :terminal tig blame +<C-r>=line(\'.\')<Return> %<Return>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>V', ':-tab split<CR> :terminal git checkout -p %<Return>i', { noremap = true, silent = true })
-- Open a ZSH terminal
vim.api.nvim_set_keymap('n', '<leader>t', ':terminal zsh<CR>', { noremap = true, silent = true })
-- Normal mode in terminal
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
-- Quit
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })

-- Whitespace
vim.api.nvim_command('hi ExtraWhitespace ctermbg=124 guibg=#cc241d')
-- Highlight leading whitespace
vim.api.nvim_set_keymap('n', '<leader>i', '/^\\s\\+/<CR>', { noremap = true, silent = true })
-- Highlight trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>T', ':call TrimWhitespace()<CR>', { noremap = true, silent = false })
vim.api.nvim_exec([[
match ExtraWhitespace /\s\+$/
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufLeave * call clearmatches()
]], false)
-- Trim trailing whitespace
vim.api.nvim_exec([[
fun! TrimWhitespace()
let l:save = winsaveview()
%s/\s\+$//e
call winrestview(l:save)
endfun
]], false)

-- Zoom/Restore window
vim.api.nvim_set_keymap('n', '<leader>z', ':call ZoomToggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_exec([[
function! ZoomToggle()
if exists('t:zoomed') && t:zoomed
execute t:zoom_winrestcmd
let t:zoomed = 0
else
let t:zoom_winrestcmd = winrestcmd()
resize
vertical resize
let t:zoomed = 1
endif
endfunction
]], false)
