set nocompatible              " be iMproved, required
filetype off                  " required <<========== We can turn it on later

if (empty(glob('~/.config/nvim/autoload/plug.vim')))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * source ~/.config/nvim/init.vim
endif

set rtp+=~/.config/nvim/autoload/plug.vim
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')
" <============================================>
" Undo graphical tree
Plug 'simnalamburt/vim-mundo'
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'ojroques/nvim-lspfuzzy'
" Code formatting (until LSP formatting takes custom mode)
Plug 'rhysd/vim-clang-format'
" Fuzzy finding of files/buffers etc
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'nvim-lua/popup.nvim'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim' "Requries popup and plenary
" Syntax highlighters
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'iramaKamari/vimcolors'
Plug 'bfrg/vim-cpp-modern'
Plug 'vim-python/python-syntax'
" <============================================>
call plug#end()            " required

syntax enable
filetype plugin indent on
set tw=0
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber
set guicursor=
set termguicolors
" Automatically re-read a file changed outside of VIM
set autoread
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set showcmd
set noshowmode
set path+=**
" Enable autocomplete suggestions in vim
set wildmenu
set complete=.,w,b,u,t
set wildmode=full
set completeopt=menu,noinsert,noselect
" --------------------------------------
set lazyredraw
set showmatch
set incsearch
set nobackup
set noswapfile
" Be able to open a new buffer without saving/undoing current changes
set hidden
" Clear highlight search
nnoremap <leader><space> :nohlsearch<CR>
" Fold blocks of code
set foldenable
set foldlevelstart=10
set foldnestmax=10
"set foldmethod=indent
augroup folding
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END
" Make nvim use the system clipboard
set clipboard+=unnamedplus
let g:loaded_clipboard_provider = 1
" Find ctags file in project/system
set tags=./tags,tags;
" Find and load cscope database
set nocscopeverbose
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
endfunction
au BufEnter /* call LoadCscope()
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Completion-nvim, use tab for completion
"imap <tab> <Plug>(completion_smart_tab)
"imap <s-tab> <Plug>(completion_smart_s_tab)

map <space> <leader>
" Don't skip wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" Easier navigation between splits
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
" Change split layout
nnoremap <A-j> <C-w>J
nnoremap <A-k> <C-w>K
nnoremap <A-l> <C-w>L
nnoremap <A-h> <C-w>H
" Change split dimensions
nnoremap <A-Up> <C-w><C-+>
nnoremap <A-Down> <C-w><C-->
nnoremap <A-Left> <C-w><C->>
nnoremap <A-Right> <C-w><C-<>
" Split
nnoremap <leader>w :split<CR>
" Vertical split
nnoremap <leader>v :vs<CR>
set splitbelow splitright
" Zoom / Restore window.
function! s:ZoomToggle() abort
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
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>
" Terminal mode mappings<C-\><C-n>:file<space>
nnoremap <leader>t :terminal<CR>
autocmd BufEnter,WinEnter,TermOpen,FocusGained term://* startinsert
autocmd BufLeave term://* stopinsert
tnoremap <Esc> <C-\><C-n>
" Move lines up and down in normal/insert/visual mode
nnoremap <leader>j :m +1<CR>==
nnoremap <leader>k :m -2<CR>==
inoremap <leader>j <Esc>:m +1<CR>==gi
inoremap <leader>k <Esc>:m -2<CR>==gi
vnoremap <leader>j :m +1<CR>gv=gv
vnoremap <leader>k :m -2<CR>gv=gv
" Select all to last line in file
nnoremap gV `[v`]
" Move to end of beginning/end of line in normal/visual mode
nnoremap gb g^
nnoremap ge g$
vnoremap gb g^
vnoremap ge g$
inoremap kk <esc>
" Delete line behind cursor to beginning in insert mode
inoremap <C-h> <C-o>d0
" Delete line from cursor to end in insert mode
inoremap <C-l> <C-o>d$
" Delete word behind cursor in insert mode
inoremap <C-w> <C-o>db
" Delete word from cursor in insert mode
inoremap <C-d> <C-o>dw
" Omnicomple in insert mode
autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
" Make recovery option from accidental deletion in insert mode
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" For local replace
nnoremap <leader>r :s/\<<C-r><C-w>\>//g<Left><Left>
" For global replace
nnoremap <Leader>R :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" Mundo settings
let g:mundo_preview_bottom = 1
let g:mundo_preview_height = 50
let g:mundo_close_on_revert = 1
nnoremap <leader>u :MundoToggle<CR>
" Quick save current buffer
nnoremap <leader>s :w<CR>
" To open new file
nnoremap <leader>e :e<space>
" Quit
nnoremap <leader>q :q<CR>
" Search for marked text in file
vnoremap // y/<C-R>"<CR>
" Visual mode copy to system buffer
map <C-c> "*y<CR>
" allows incsearch highlighting for range commands
cnoremap $t <CR>:t''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap $d <CR>:d<CR>``

function! s:FindGitRoot()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" Search for code with Rg/git grep if available
let grepPrgFound = 0
if executable('fzf')
  command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

  nnoremap <leader>f :Files<CR>
  nnoremap <leader>F :Files<space>
  nnoremap § :Buffers<CR>

  if strlen(s:FindGitRoot()) > 0
    command! ProjectFiles execute 'GFiles' s:FindGitRoot()
    nnoremap <leader>F :Files<CR>
    nnoremap <leader>f :GFiles<CR>
    nnoremap <leader>c :BCommits<CR>
    nnoremap <leader>C :Commits<CR>
    nnoremap <leader>S :GFiles?<CR>
    command! -bang -nargs=* GGrep call fzf#vim#grep(
    \   'git grep --line-number --color="always" ' . shellescape(<q-args>), 0,
    \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
    nnoremap <Leader>g :GGrep<CR>
    " Grep word under cursor
    nnoremap <leader>G :GGrep <C-R><C-W><CR>
    vnoremap <leader>G y:GGrep <C-R>"<CR>
    let grepPrgFound = 1
  endif

  if executable('rg')
    nnoremap <Leader>g :Rg<CR>
    " Grep word under cursor
    nnoremap <leader>G :Rg <C-R><C-W><CR>
    vnoremap <leader>G y:Rg <C-R>"<CR>
    command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
          \   fzf#vim#with_preview(), <bang>0)
    function! RipgrepFzf(query, fullscreen)
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

    let grepPrgFound = 1
  endif
else
  if (grepPrgFound == 0)
    " Open quickfix window after grep
    autocmd QuickFixCmdPost *grep* cwindow|redraw!
    nnoremap <Leader>g :grep<Space>
    " Grep word under cursor
    nnoremap <leader>G :grep <C-R><C-W><CR>
  endif

  " Display active buffers and prep for :buffer<COMMAND>
  nnoremap § :ls<CR>:b<space>

  nnoremap <leader>f :files<CR>
  nnoremap <leader>F :files<space>
endif

" Go back to last used buffer
nnoremap <leader>b <C-^>
" Fzf configuration
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_buffers_jump = 1
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Identifier'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Identifier'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Statusline configuration
" Status bar always enabled
set laststatus=2

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB'
  else
    return bytes . 'B'
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ' '
  else
    return ''
endfunction

function! GitInfo()
  let git = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  if git != ''
    return ' '.git
  else
    return ''
endfunction

let g:currentmode={
      \ 'n'  : 'Normal ',
      \ 'no' : 'N·Operator Pending ',
      \ 'v'  : 'Visual ',
      \ 'V'  : 'V·Line ',
      \ '' : 'V·Block ',
      \ 's'  : 'Select ',
      \ 'S'  : 'S·Line ',
      \ '' : 'S·Block ',
      \ 'i'  : 'Insert ',
      \ 'R'  : 'Replace ',
      \ 'Rv' : 'V·Replace ',
      \ 'c'  : 'Command ',
      \ 'cv' : 'Vim Ex ',
      \ 'ce' : 'Ex ',
      \ 'r'  : 'Prompt ',
      \ 'rm' : 'More ',
      \ 'r?' : 'Confirm ',
      \ '!'  : 'Shell ',
      \ 't'  : 'Terminal '
      \}

set statusline=
"set statusline+=%#statement#
set statusline+=%{toupper(g:currentmode[mode()])}                         " Current mode
set statusline+=%#macro#\[%n]                                             " buffernr
set statusline+=%#macro#\ %f\%#Statement#\%{ReadOnly()}\%m\%w\            " Relative path + file
set statusline+=%#string#\Lines\ %L\ Col\ %c                              " Total lines and column number
set statusline+=%#macro#\ %y                                              " FileType
set statusline+=\ [%{(&fenc!=''?&fenc:&enc)}\ %{&ff}]                     " Encoding & Fileformat
set statusline+=\ [%(%{FileSize()}%)]                                     " File size
set statusline+=%#string#\ %{GitInfo()}                                   " Git Branch name
set statusline+=\ %=                                                      " Space
set statusline+=%<                                                        " Truncate line
au InsertEnter * hi statusline guifg=#fabd2f guibg=none ctermfg=none ctermbg=none
au InsertLeave * hi statusline guifg=#fb4934 guibg=none ctermfg=none ctermbg=none
" #fabd2f for visual modes
" #fe8019 for command modes
" #928374 for focus lost
" #fb4934 for normal/terminal

" Python
let g:python2_host_prog="/usr/bin/python"
let g:python3_host_prog="/usr/bin/python3"
let g:python_recommended_style=1
let g:python_highlight_all = 1

" Code formatting
let g:clang_format#code_style = 'chromium'

" GIT
map <Leader>l :te tig %<Return>i
map <Leader>B :te tig blame +<C-r>=line('.')<Return> %<Return>i
map <Leader>D :te git diff %<Return>i
map <Leader>V :te git checkout -p %<Return>i

" Colorscheme
let g:gruvbox_termcolors=256
silent! colorscheme gruvbox
" Highlight leading whitespace
nnoremap <leader>i /^\s\+/<CR>
" Trim trailing whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <Leader>T :call TrimWhitespace()<CR>
highlight ExtraWhitespace ctermbg=124 guibg=#cc241d
" Highlight trailing whitespace
match ExtraWhitespace /\s\+$/
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufLeave * call clearmatches()

" Lsp settings
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
lua << EOF
local nvim_lsp = require('lspconfig')
--require('telescope').setup{}
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  require'completion'.on_attach()
  require('lspfuzzy').setup {
    methods = 'all',         -- either 'all' or a list of LSP methods (see below)
    fzf_preview = {          -- arguments to the FZF '--preview-window' option
      'right:+{2}-/2'          -- preview on the right and centered on entry
    },
    fzf_action = {           -- FZF actions
      ['ctrl-t'] = 'tabedit',  -- go to location in a new tab
      ['ctrl-v'] = 'vsplit',   -- go to location in a vertical split
      ['ctrl-x'] = 'split',    -- go to location in a horizontal split
    },
    fzf_modifier = ':~:.',   -- format FZF entries, see |filename-modifiers|
    fzf_trim = true,         -- trim FZF entries
  }

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-K>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>L', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --buf_set_keymap('n', '<space>cf', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>', opts) Use if format on save

  -- Set some keybinds conditional on server capabilities
  local code_format_opts = { "tabSize=2", "insestSpaces=true", "trimTrailingWhitespace?=true", "insertFinalNewLine?=false", "trimFinalNewLines?=true"}
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<space>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('v', '<space>cf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  --if client.resolved_capabilities.document_highlight then
  --  vim.api.nvim_exec([[
  --    hi LspReferenceRead cterm=bold ctermbg=red guifg=black guibg=fg
  --    hi LspReferenceText cterm=bold ctermbg=red guifg=black guibg=fg
  --    hi LspReferenceWrite cterm=bold ctermbg=red guifg=black guibg=fg
  --    augroup lsp_document_highlight
  --      autocmd! * <buffer>
  --      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --    augroup END
  --  ]], false)
  --end
end

nvim_lsp.pyls.setup{
  on_attach = on_attach
}
--nvim_lsp.pyright.setup{
--  on_attach = on_attach
--}
--nvim_lsp.ccls.setup {
--  init_options = {
--    cache = {
--      directory = ".ccls-cache";
--    };
--  };
--  on_attach = on_attach
--}
nvim_lsp.clangd.setup{
  cmd = {'clangd', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium', '--header-insertion=iwyu', '--suggest-missing-includes=true'};
  on_attach = on_attach
}
EOF
