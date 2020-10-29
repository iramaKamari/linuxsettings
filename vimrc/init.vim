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
" Specify the plugins you want to install here.
Plug 'Chiel92/vim-autoformat'
Plug 'simnalamburt/vim-mundo'
"Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'
Plug 'iramaKamari/vimcolors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'bfrg/vim-cpp-modern'
Plug 'sheerun/vim-polyglot'
" <============================================>
call plug#end()            " required

syntax enable
set tw=0
set tabstop=2
set softtabstop=2
set sw=2
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
set complete=.,w,b,u,t,i
set wildmode=full
set completeopt=menu,preview
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
" Find ctags file in project/system
set tags=./tags,tags;
let g:ycm_key_list_previous_completion = ['<Up>']
inoremap <expr><S-Tab> pumvisible() ? "<C-p>" : "<C-d>"
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
" Make recovery option from accidental deletion in insert mode
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" For local replace
nnoremap <Leader>r :s/\<<C-r><C-w>\>//g<Left><Left>
" For global replace
nnoremap <Leader>R :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" Open Mundo for visual change tree
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

" Search for code with Rg or Ag if available
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
    let grepPrgFound = 1
  endif

  if executable('rg')
    nnoremap <Leader>g :Rg<CR>
    " Grep word under cursor
    nnoremap <leader>G :Rg <C-R><C-W><CR>
    let g:rg_command = '
      \ rg --column --line-number --color="always" '
    command! -bang -nargs=* Rg call fzf#vim#grep(g:rg_command . shellescape(<q-args>), 0,
    \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
    inoremap <expr> <c-l> fzf#vim#complete(fzf#wrap({
      \ 'prefix': '^.*$',
      \ 'source': 'rg -n ^ --color always',
      \ 'options': '--ansi --delimiter : --nth 3..',
      \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

    let grepPrgFound = 1
  endif

  if executable('ag') && grepPrgFound == 0
    " Use Ag over grep
    nnoremap <Leader>g :Ag<CR>
    " Grep word under cursor
    nnoremap <leader>G :Ag <C-R><C-W><CR>>
    let g:ag_command = '
      \ ag --column --color="always" '
    command! -bang -nargs=* Ag call fzf#vim#grep(g:ag_command . shellescape(<q-args>), 0,
    \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
    inoremap <expr> <c-l> fzf#vim#complete(fzf#wrap({
      \ 'prefix': '^.*$',
      \ 'source': 'ag -n ^ --color always',
      \ 'options': '--ansi --delimiter : --nth 3..',
      \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

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
nnoremap <leader>b :e#<CR>
" Highlight leading whitespace
nnoremap <leader>i /^\s\+/<CR>
" Highlight trailing whitespace
" autocmd BufWritePre * %s/\s\+$//e
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufLeave * call clearmatches()
" Trim trailing whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <Leader>T :call TrimWhitespace()<CR>
" Fzf configuration
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

set statusline=
set statusline+=%#statement#
set statusline+=%{toupper(g:currentmode[mode()])}                         " Current mode
set statusline+=%#macro#\[%n]                                             " buffernr
set statusline+=%#macro#\ %f\%#Statement#\%{ReadOnly()}\%m\%w\            " Relative path + file
set statusline+=%#string#\Lines\ %L\ Col\ %c                              " Total lines and column number
set statusline+=%#macro#\ %y                                              " FileType
set statusline+=\ [%{(&fenc!=''?&fenc:&enc)}\ %{&ff}]                     " Encoding & Fileformat
set statusline+=\ [%(%{FileSize()}%)]                                     " File size
set statusline+=%#string#\ %{GitInfo()}                                   " Git Branch name
set statusline+=%#statement#\ %{LinterStatus()}                           " Show number of errors/warnings
set statusline+=\ %=                                                      " Space
set statusline+=%<                                                        " Truncate line

" Syntastic settings
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_cpp_checkers = ['cppcheck']
"function Py2()
"  let g:syntastic_python_python_exec = '/usr/local/bin/python2.7'
"endfunction
"
"function Py3()
"  let g:syntastic_python_python_exec = '/usr/local/bin/python3.7'
"endfunction
"
"call Py3()   " default to Py3

" Ale settings
"let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    let l:checkMark = ''
    "if strlen(s:FindGitRoot()) > 0
    "  let l:checkMark = '✓'
    "endif

    return l:counts.total == 0 ? l:checkMark : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" Mundo settings
let g:mundo_preview_bottom = 1
let g:mundo_preview_height = 50
let g:mundo_close_on_revert = 1

" Modern c++ highlight
let c_no_curly_error = 1

" Goyo/Limelight
let g:goyo_height = 100
let g:goyo_width = 125
nnoremap <Leader>o :Goyo<CR>
let g:limelight_conceal_ctermfg = 240
nnoremap <Leader>L :Limelight!!<CR>
vnoremap <Leader>L :Limelight!!<CR>

" GIT
map <Leader>l :te tig %<Return>i
map <Leader>B :te tig blame +<C-r>=line('.')<Return> %<Return>i
map <Leader>D :te git diff %<Return>i
map <Leader>Z :!codemapper map %<Return>
map <Leader>V :te git checkout -p %<Return>i

" Colorscheme
let g:gruvbox_termcolors=256
silent! colorscheme gruvbox
