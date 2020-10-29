" This plugin sets up automatic source code formatting using
" kreatv-clang-format.

if exists('g:kreatv_clang_format_plugin_loaded')
    finish
endif
let g:kreatv_clang_format_plugin_loaded = 1

let g:kreatv_clang_format_enabled = get(g:, 'kreatv_clang_format_enabled', 1)
if ! g:kreatv_clang_format_enabled
    finish
endif

function s:err(msg)
    echoe 'KreatvClangFormat: ' . a:msg
endfunction

if v:version < 704
    call s:err('Plugin not tested on vim < 7.4, please update vim')
    finish
endif

let s:dev_tools_dir = expand('<sfile>:p:h:h:h:h')
let s:wrapper = printf("%s/bin/kreatv-clang-format", s:dev_tools_dir)

let g:kreatv_clang_format_wrapper = get(
    \ g:,
    \ 'kreatv_clang_format_wrapper',
    \ s:wrapper)
let g:kreatv_clang_format_on_insert_leave = get(
    \ g:,
    \ 'kreatv_clang_format_on_insert_leave',
    \ 0)
let g:kreatv_clang_format_on_write = get(g:, 'kreatv_clang_format_on_write', 1)

if ! executable(g:kreatv_clang_format_wrapper)
    let msg = printf('Unable to find [%s]', g:kreatv_clang_format_wrapper)
    call s:err(msg)
    finish
endif

augroup plugin-kreatv-clang-format
    autocmd FileType c,cpp
        \ if g:kreatv_clang_format_on_insert_leave |
        \     call kreatv_clang_format#enable_format_on_insert_leave() |
        \ endif
    autocmd BufWrite *
        \ if &filetype =~# '^\%(c\|cpp\)$' && g:kreatv_clang_format_on_write |
        \     call kreatv_clang_format#format(1, line('$')) |
        \ endif
augroup END

command! -range=% KreatvClangFormat
    \ call kreatv_clang_format#format(<line1>, <line2>)
