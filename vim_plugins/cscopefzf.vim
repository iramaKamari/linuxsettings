function! Cscope(option, query)
  let color = '{ path = $1; $1 = ""; functionName = $2; $2 = ""; linenum = $3; $3 = "";
        \ printf "\033[35m%s\033[0m:\033[31m%s\033[0m \033[93m%s\033[0m\033[92m%s\033[0m\n",
        \ path,linenum,functionName,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all'],
  \ 'down': '40%'
  \ }
  function! opts.sink(lines)
    let data = split(a:lines)
    let file = split(data[0], ":")
    execute 'e ' . '+' . file[1] . ' ' . file[0]
  endfunction
  call fzf#run(fzf#wrap(opts))
endfunction

function! CscopeQuery(option)
  call inputsave()
  if a:option == '0'
    let query = input('Assignments to: ')
  elseif a:option == '1'
    let query = input('Functions calling: ')
  elseif a:option == '2'
    let query = input('Functions called by: ')
  elseif a:option == '3'
    let query = input('Egrep: ')
  elseif a:option == '4'
    let query = input('File: ')
  elseif a:option == '6'
    let query = input('Definition: ')
  elseif a:option == '7'
    let query = input('Files #including: ')
  elseif a:option == '8'
    let query = input('C Symbol: ')
  elseif a:option == '9'
    let query = input('Text: ')
  else
    echo "Invalid option!"
    return
  endif
  call inputrestore()
  if query != ""
    call Cscope(a:option, query)
  else
    echom "Cancelled Search!"
  endif
endfunction

nnoremap <silent> <Leader>ca :call Cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :call Cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call Cscope('2', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call Cscope('3', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call Cscope('4', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call Cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call Cscope('7', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cs :call Cscope('8', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call Cscope('9', expand('<cword>'))<CR>

nnoremap <silent> <Leader>Ca :call CscopeQuery('0')<CR>
nnoremap <silent> <Leader>Cc :call CscopeQuery('1')<CR>
nnoremap <silent> <Leader>Cd :call CscopeQuery('2')<CR>
nnoremap <silent> <Leader>Ce :call CscopeQuery('3')<CR>
nnoremap <silent> <Leader>Cf :call CscopeQuery('4')<CR>
nnoremap <silent> <Leader>Cg :call CscopeQuery('6')<CR>
nnoremap <silent> <Leader>Ci :call CscopeQuery('7')<CR>
nnoremap <silent> <Leader>Cs :call CscopeQuery('8')<CR>
nnoremap <silent> <Leader>Ct :call CscopeQuery('9')<CR>
