let s:insert_pos = []

function s:is_tool_available()
    if ! exists('b:tool_available')
        let args = ' --version'
        let args .= printf(' --assume-filename=%s', expand('%'))
        let cmd = printf('%s %s --', g:kreatv_clang_format_wrapper, args)
        let output = system(cmd)

        if v:shell_error != 0
            let b:tool_available = 0
        else
            let b:tool_available = 1
        endif
    endif
    return b:tool_available
endfunction

function kreatv_clang_format#format(line1, line2)
    if ! s:is_tool_available()
        return
    endif

    let buffer = join(getline(1, '$'), "\n")
    let args = printf(' --lines=%d:%d', a:line1, a:line2)
    let args .= printf(' --assume-filename=%s', expand('%'))
    let cmd = printf('%s %s --', g:kreatv_clang_format_wrapper, args)
    let output = system(cmd, buffer)
    if v:shell_error != 0
        for line in split(output, "\n")
            echoerr line
        endfor
        return
    endif

    let output_splitted = split(output, "\n", 1)
    let output_splitted_len = len(output_splitted)

    " Store old view
    let old_vim_view = winsaveview()

    silent! undojoin

    " Delete extra lines
    if line('$') > output_splitted_len
        execute output_splitted_len . ',$d'
    endif

    " Replace buffer with output from kreatv-clang-format
    call setline(1, output_splitted)

    " Restore old view
    call winrestview(old_vim_view)
endfunction

function kreatv_clang_format#enable_format_on_insert_leave()
    augroup plugin-kreatv-clang-format-on-insert-leave
        autocmd! * <buffer>
        autocmd InsertEnter <buffer> let s:insert_pos = getpos('.')
        autocmd InsertLeave <buffer> call s:format_on_insert_leave()
    augroup END
endfunction

function s:format_on_insert_leave()
    if ! s:is_tool_available()
        return
    endif

    let pos = getpos('.')
    if ! &modified || empty(s:insert_pos) || s:insert_pos[0] != pos[0]
        return
    endif

    let from_line = min([s:insert_pos[1], pos[1]])
    let to_line = max([s:insert_pos[1], pos[1]])

    call kreatv_clang_format#format(from_line, to_line)
    let s:insert_pos = []
endfunction
