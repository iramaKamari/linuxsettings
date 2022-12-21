--vim.api.nvim_set_keymap('i', '{', '<C-O>:lua Close_it()<CR>', { noremap = true, silent = false })
vim.api.nvim_exec([[inoremap <expr> ( strpart(getline('.'), col('.')-1, 1) == "" ? "()<left>" : "("]], false)
vim.api.nvim_exec([[inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"]], false)

vim.api.nvim_exec([[inoremap <expr> { strpart(getline('.'), col('.')-1, 1) == "" ? "{}<left>" : "{"]], false)
vim.api.nvim_exec([[inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"]], false)

vim.api.nvim_exec([[inoremap <expr> [ strpart(getline('.'), col('.')-1, 1) == "" ? "[]<left>" : "["]], false)
vim.api.nvim_exec([[inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "[]<left>" : "]"]], false)

vim.api.nvim_exec([[inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "" ? "''\<left>" : "'<right>"]], false)
vim.api.nvim_exec([[inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "" ? "\"\"<left>" : "\<right>" ]], false)
-- enclose a word in normal mode with "'({[
vim.api.nvim_exec([[nnoremap <leader>' mmciw''<esc>P`m<right>]], false)
vim.api.nvim_exec([[nnoremap <leader>" mmciw""<esc>P`m<right>]], false)
vim.api.nvim_exec([[nnoremap <leader>( mmciw()<esc>P`m<right>]], false)
vim.api.nvim_exec([[nnoremap <leader>{ mmciw{}<esc>P`m<right>]], false)
vim.api.nvim_exec([[nnoremap <leader>[ mmciw[]<esc>P`m<right>]], false)
--vim.api.nvim_exec([[nnoremap <leader>' mmbi'<esc>ea'<esc>`m<right>]], false)
-- enclose a selection in visual mode with "'({[
vim.api.nvim_exec([[vnoremap <leader>' <Esc>`<i'<Esc>`>a<right>'<Esc>]], false)
vim.api.nvim_exec([[vnoremap <leader>" <Esc>`<i"<Esc>`>a<right>"<Esc>]], false)
vim.api.nvim_exec([[vnoremap <leader>( <Esc>`<i(<Esc>`>a<right>)<Esc>]], false)
vim.api.nvim_exec([[vnoremap <leader>{ <Esc>`<i{<Esc>`>a<right>}<Esc>]], false)
vim.api.nvim_exec([[vnoremap <leader>[ <Esc>`<i[<Esc>`>a<right>]<Esc>]], false)
--function Close_it()
--	local line = vim.api.nvim_get_current_line()
--	local cursor = vim.api.nvim_parse_cmd("echo getcursorcharpos()", {})
--end
