local no_fzf = true
-- Search for code with Rg/git grep if available
if vim.fn.executable('fzf') == 1 then
  no_fzf = false
  -- Fzf configuration
  -- Insert mode completion
  --vim.api.nvim_set_keymap('i', '<c-x><c-k>', '<plug>(fzf-complete-word)', { noremap = true, silent = false })
  --vim.api.nvim_set_keymap('i', '<c-x><c-f>', '<plug>(fzf-complete-path)', { noremap = true, silent = false })
  --vim.api.nvim_set_keymap('i', '<c-x><c-l>', '<plug>(fzf-complete-line)', { noremap = true, silent = false })
  vim.api.nvim_exec([[
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-l> <plug>(fzf-complete-line)
  ]], false)
  --vim.api.nvim_set_var('g:fzf_commits_log_options', '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"')
  --vim.api.nvim_set_var('g:fzf_buffers_jump', 1)
  --vim.api.nvim_set_var('g:fzf_colors', "{'fg': ['fg', 'Normal'], 'bg': ['bg', 'Normal'], 'hl': ['fg', 'Comment'], 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+': ['bg', 'CursorLine', 'CursorColumn'], 'hl+': ['fg', 'Statement'], 'info': ['fg', 'PreProc'], 'border': ['fg', 'Ignore'], 'prompt': ['fg', 'Identifier'], 'pointer': ['fg', 'Exception'], 'marker': ['fg', 'Identifier'], 'spinner': ['fg', 'Label'], 'header': ['fg', 'Comment'] }")
  vim.cmd([[command! -bang Colors call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)]])

  vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<leader>F', ':Files<space>', { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '§ ', ':Buffersa<CR>', { noremap = true, silent = false })
  local git_top_file = io.popen('git rev-parse --show-toplevel 2> /dev/null')
  local git_top_dir = string.match(git_top_file:read("*l"), "(%d+)/$")
  io.close(git_top_file)
  if git_top_dir ~= '' then
    vim.cmd(string.format('command! ProjectFiles execute \'GFiles\' %s', git_top_dir))
    vim.api.nvim_set_keymap('n', '<leader>F', ':Files<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<leader>f', ':GFiles<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<leader>c', ':BCommits<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<leader>C', ':Commits<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<leader>S', ':GFiles?<CR>', { noremap = true, silent = false })
    vim.cmd('command! -bang -nargs=* GGrep call fzf#vim#grep(\'git grep --line-number --color="always" \'.shellescape(<q-args>), 0, { \'dir\': systemlist(\'git rev-parse --show-toplevel\')[0] }, <bang>0)')
    vim.api.nvim_set_keymap('n', '<leader>g', ':GGrep<CR>', { noremap = true, silent = false })
    -- Grep word under cursor
    vim.api.nvim_set_keymap('n', '<leader>G', ':GGrep <C-R><C-W><CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('v', '<leader>G', 'y:GGrep <C-R>"<CR>', { noremap = true, silent = false })
  end

  if vim.fn.executable('rg') == 1 then
    vim.api.nvim_set_keymap('n', '<leader>g', ':Rg<CR>', { noremap = true, silent = false })
    -- Grep word under cursor
    vim.api.nvim_set_keymap('n', '<leader>G', ':Rg <C-R><C-W><CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('v', '<leader>G', 'y:Rg <C-R>"<CR>', { noremap = true, silent = false })
    vim.cmd('command! -bang -nargs=* Rg call fzf#vim#grep(\'rg --column --line-number --no-heading --color=always --smart-case -- \'.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)')
    vim.api.nvim_exec([[
      function! RipgrepFzf(query, fullscreen)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
      endfunction
    ]], false)

    vim.cmd('command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)')
  end
end

if no_fzf then
  -- Open quickfix window after grep
  vim.api.nvim_exec([[
  autocmd QuickFixCmdPost *grep* cwindow|redraw!
  ]], false)
  vim.api.nvim_set_keymap('n', '<leader>g', ':grep <C-R><C-W><CR', { noremap = true, silent = false })
  -- Grep word under cursor
  vim.api.nvim_set_keymap('n', '<leader>G', ':grep <C-R><C-W><CR', { noremap = true, silent = false })
  vim.api.nvim_set_keymap('v', '<leader>G', 'y:grep <C-R>"<CR>', { noremap = true, silent = false })

  -- Display active buffers and prep for :buffer<COMMAND>
  vim.api.nvim_set_keymap('n', '§', ':ls<CR>:b<space>', { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<leader>f', ':files<CR>', { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<leader>F', ':files<space>', { noremap = true, silent = false })
end
