set nocompatible              " be iMproved, required
filetype off                  " required <<========== We can turn it on later

let FirstTime = 0
if (empty(glob('~/.vim/bundle/Vundle.vim')))
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let FirstTime = 1
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if FirstTime == 1
  au VimEnter * PluginInstall
  au VimEnter * source ~/.vimrc
endif
" <============================================>
" Specify the plugins you want to install here.
Plugin 'Chiel92/vim-autoformat'
Plugin 'mileszs/ack.vim'
Plugin 'sjl/gundo.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'iramaKamari/vimcolors'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
" <============================================>
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put non-Plugin stuff after this

syntax enable
set tw=0
set tabstop=2
set softtabstop=2
set sw=2
set expandtab
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
au WinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline
set showcmd
set noshowmode
set cursorline
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
set hlsearch
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
set foldmethod=indent
" Find ctags file in project/system
set tags=./tags,tags;
" Autoload gtags and set it to be used with cscope
set cscopetag
set csprg=gtags-cscope
function! LoadScope()
  let db = findfile("GTAGS", ".;")
  if (!empty(db) && filereadable(db))
    let path = matchstr(db, ".*/")
    set nocscopeverbose " supress 'duplicate connection' error
    exe 'silent !' "cs add" db path
    set cscopeverbose
  elseif $GTAGS_DB != ""
    cs add $GTAGS_DB
  endif
endfunction
au BufEnter /* call LoadScope()
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
set splitbelow
set splitright
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
inoremap jk <esc>
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
" Open Gundo for visual change tree
nnoremap <leader>u :GundoToggle<CR>
" Quick save current buffer
nnoremap <leader>s :w<CR>
" Automatically re-read a file changed outside of VIM
set autoread
" Search for files with CtrlP
let g:ctrlp_working_path_mode = 'ra'

" Search for code with Ag
if executable('ag')
  " Use Ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  "let g:ackprg='ag --nogroup --nocolor --column'
endif
"cnoreabbrev Ack Ack!
"nnoremap <Leader>a :Ack!<Space>
" Bind Ag and open a quick fix window with the results
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap <Leader>a :Ag<Space>
" Grep word under cursor
nnoremap <leader>A :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" Display active buffers and prep for :buffer<COMMAND>
nnoremap § :ls<CR>:b<space>
" Go back to last used buffer
nnoremap <leader>b :e#<CR>
" Change split dimensions
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-
nnoremap <C-Left> <C-w>>
nnoremap <C-Right> <C-w><
" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Trim trailing whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <Leader>t :call TrimWhitespace()<CR>
" Statusline configuration
" Status bar always enabled
set laststatus=2

let g:currentmode={
      \ 'n'  : 'N ',
      \ 'no' : 'N·Operator Pending ',
      \ 'v'  : 'V ',
      \ 'V'  : 'V·Line ',
      \ '' : 'V·Block ',
      \ 's'  : 'Select ',
      \ 'S'  : 'S·Line ',
      \ '' : 'S·Block ',
      \ 'i'  : 'I ',
      \ 'R'  : 'R ',
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

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

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
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=\                                                         " Escape one space for alignment
set statusline+=%0*\%{toupper(g:currentmode[mode()])}»                    " Current mode
set statusline+=%#identifier#\ [%n]                                       " buffernr
set statusline+=%#preproc#\ %{GitInfo()}                                  " Git Branch name
set statusline+=%#identifier#\ %f\%#statement#\%{ReadOnly()}\%m\%w\       " File+path
set statusline+=%#identifier#\%3p%%\ \ %l:\%c\                           " Rownumber/total (%)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}                              " Syntastic errors
set statusline+=%0*
set statusline+=\ %=                                                      " Space
set statusline+=%0*\ %y\                                                  " FileType
set statusline+=\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ " Encoding & Fileformat
set statusline+=\ %-3(%{FileSize()}%)                                     " File size
set statusline+=%<                                                        " Truncate line

" Syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_checkers = ['cppcheck']
" Colorscheme
colorscheme molokai
