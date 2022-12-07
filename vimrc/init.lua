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
--paq 'rktjmp/lush.nvim' colortheme creator
-- }}}
-- Editor mappings and settings
-- Remap leader to space {{{
vim.api.nvim_set_keymap('', '<space>', '<nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- }}}
-- Whitespace {{{
-- Highlight leading whitespace
vim.api.nvim_set_keymap('n', '<leader>i', '/^\\s\\+/<CR>', { noremap = true, silent = true })
-- Highlight trailing whitespace
vim.api.nvim_command('hi ExtraWhitespace ctermbg=124 guibg=#cc241d')
vim.api.nvim_exec([[
match ExtraWhitespace /\s\+$/
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufLeave * call clearmatches()
]], false)
-- Trim trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>T', ':call TrimWhitespace()<CR>', { noremap = true, silent = false })
vim.api.nvim_exec([[
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
]], false)
-- }}}
-- Global
vim.api.nvim_command([[set noswapfile nobackup noshowmode]])
vim.api.nvim_command([[set cursorline]])
vim.api.nvim_command([[set mouse=]])
-- Extend MatchParen list
vim.api.nvim_command([[set mps+=<:>]])
vim.api.nvim_exec([[autocmd FileType c,cpp set mps+==:;]], false)
vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('autoread', true)
vim.api.nvim_set_option('guicursor', "")
vim.api.nvim_set_option('lazyredraw', true)
vim.api.nvim_set_option('showmatch', true)
vim.api.nvim_set_option('complete', '.,w,b,u,t')
vim.api.nvim_set_option('completeopt', 'menu,menuone,noinsert,noselect')
vim.api.nvim_set_option('wildmode', 'longest:full,full')
-- Omnicomple in insert mode
vim.api.nvim_exec([[
autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
]], false)
vim.api.nvim_command([[set path+=**]])

-- Window {{{
-- Split
vim.api.nvim_command([[set splitbelow splitright]])
vim.api.nvim_exec([[autocmd VimResized * wincmd =]], false)
vim.api.nvim_set_keymap('n', '<leader>w', ':split<CR>', { noremap = true, silent = true })
-- Vertical split
vim.api.nvim_set_keymap('n', '<leader>v', ':vs<CR>', { noremap = true, silent = true })
-- Change split layout
--vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>J', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>K', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>L', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>H', { noremap = true, silent = true })
---- Change split dimensions
--vim.api.nvim_set_keymap('n', '<A-Up>', '<C-w><C-+>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Down>', '<C-w><C-->', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Left>', '<C-w><C->>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<A-Right>', '<C-w><C-<>', { noremap = true, silent = true })
-- }}}

-- Navigation {{{
vim.api.nvim_command([[set number relativenumber]])
vim.api.nvim_exec([[
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
]], false)
-- Go to last used buffer
--vim.api.nvim_set_keymap('n', '<leader>b', '<C-^>', { noremap = true, silent = true })
-- Display active buffers and prep for :buffer<COMMAND>
vim.api.nvim_set_keymap('n', '§', ':ls<CR>:b<space>', { noremap = true, silent = true })
-- Between splits
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w><C-j>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w><C-k>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w><C-l>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w><C-h>', { noremap = true, silent = true })
-- Don't skip wrapped lines
--vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
--vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
-- }}}
-- Zoom/Restore window {{{
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
vim.api.nvim_set_keymap('n', '<leader>z', ':call ZoomToggle()<CR>', { noremap = true, silent = true })
-- }}}

-- Editing {{{
-- Buffer settings
vim.api.nvim_buf_set_option(0, 'textwidth', 0)
vim.api.nvim_buf_set_option(0, 'tabstop', 2)
vim.api.nvim_buf_set_option(0, 'softtabstop', 2)
vim.cmd([[set shiftwidth=2]])
vim.api.nvim_buf_set_option(0, 'expandtab', true)
vim.api.nvim_set_option('hidden', true)

-- Keep yanked text in visual mode for pasting
--vim.api.nvim_set_keymap('x', 'p', '"_dP"', { noremap = true, silent = true })
-- Move lines up and down in normal/insert/visual mode
vim.api.nvim_set_keymap('n', '<S-Down>', ':m +1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>', ':m -2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Down>', '<Esc>:m +1<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Up>', '<Esc>:m -2<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Down>', '<Esc>:m +1<CR>gv=gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Up>', '<Esc>:m -2<CR>gv=gv', { noremap = true, silent = true })

-- Tryout normal command
vim.api.nvim_set_keymap('n', '<leader>n', ':normal ', { noremap = true, silent = false })
-- Quicksave current buffer
vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', { noremap = true, silent = true })
-- Escape as kk
vim.api.nvim_set_keymap('i', 'kk', '<esc>', { noremap = true, silent = true })
-- To open new file
vim.api.nvim_set_keymap('n', '<leader>e', ':e ', { noremap = true, silent = false })
-- Replace local/global
vim.api.nvim_set_keymap('n', '<leader>r', ':s/<C-r><C-w>//g<Left><Left>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>R', ':%s/<C-r><C-w>//gc<Left><Left><Left>', { noremap = true, silent = false })
-- Searching
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<CR>', { noremap = true, silent = true })
-- Range commands for incsearch
vim.api.nvim_set_keymap('c', '$t', '<CR>:t\'\'<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '$m', '<CR>:m\'\'<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '$d', '<CR>:d<CR>``', { noremap = true, silent = true })

-- Python
vim.api.nvim_set_var('python2_host_prog', "/usr/bin/python")
vim.api.nvim_set_var('python3_host_prog', "/usr/bin/python3")
vim.api.nvim_set_var('python_recommended_style', 1)
vim.api.nvim_set_var('python_highlight_all', 1)

-- Code formatting
vim.api.nvim_set_var('clang_format#code_style', "chromium")
vim.api.nvim_exec([[autocmd BufWritePre *.go lua Go_org_imports()]], false)
-- }}}

-- Omnifunc
vim.api.nvim_exec([[autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc]], false)
-- }}}

-- GIT
vim.api.nvim_set_keymap('', '<leader>l', ':-tab split<CR> :terminal tig %<Return>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>B', ':-tab split<CR> :terminal tig blame +<C-r>=line(\'.\')<Return> %<Return>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>V', ':-tab split<CR> :terminal git checkout -p %<Return>i', { noremap = true, silent = true })

-- Mundo settings
--vim.api.nvim_set_var('mundo_preview_bottom', 1)
--vim.api.nvim_set_var('mundo_preview_height', 50)
--vim.api.nvim_set_var('mundo_close_on_revert', 1)
--vim.api.nvim_set_keymap('n', '<leader>u', ':MundoToggle<CR>', { noremap = true, silent = true })

-- Terminal mode mappings<C-\><C-n>:file<space>
vim.api.nvim_set_keymap('n', '<leader>t', ':terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>:b#<CR>', { noremap = true, silent = true })
vim.api.nvim_exec([[
autocmd BufEnter,WinEnter,TermOpen,FocusGained term://* startinsert
autocmd BufLeave term://* stopinsert
]], false)
-- Quit
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })

-- Syntax, color and highlight {{{
vim.api.nvim_command([[syntax enable]])
vim.api.nvim_exec([[
let g:rainbow_active = 1
let g:gruvbox_sign_column = "none"
let g:gruvbox_contrast_dark = 'hard'
]], false)
vim.api.nvim_command([[silent! colorscheme gruvbox_modified]])

require('nvim-treesitter.configs').setup {
  auto_install = true,
  highlight = {
    additional_vim_regex_highlighting = false,
    enable = true,
    disable = function(lang, buf)
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
-- }}}
-- Snippets {{{
--vim.api.nvim_exec([[
--let g:UltiSnipsExpandTrigger = "<C-n>"
--]], false)
-- }}}

-- Better quickfix {{{
require('bqf').setup{
  auto_resize_height = true,
  preview = {
    win_height = 999,
    win_vheight = 999,
  },
}
-- }}}

-- Openbrowser {{{
vim.api.nvim_exec([[
let g:openbrowser_browser_commands = [
\{'name': '/usr/bin/firefox',
\'args': ['start', '{browser}', '{uri}']}
\]
]], false)

-- }}}

-- Highlight for odd files {{{
vim.api.nvim_exec([[autocmd BufEnter *.ifx setlocal filetype=bash]], false)
-- }}}
-- Border for floating windows {{{
--function Floating_border()
--  if vim.api.nvim_win_get_config(vim.api.nvim_win_getid()).relative ~= '' then
--    vim.api.nvim_exec([[echo "Hi"]], false)
--    vim.api.nvim_win_set_config(0, { border = "rounded" })
--  end
--end
--vim.api.nvim_exec([[autocmd BufWinEnter lua Floating_border()]], false)
--vim.api.nvim_exec([[autocmd BufWinEnter echo "Hi"]], false)
-- }}}
