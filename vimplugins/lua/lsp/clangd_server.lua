local settings = require("lsp.server_config")
vim.api.nvim_exec([[
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
]], false)

settings.lsp.clangd.setup {
  cmd = { 'clangd', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium',
    '--header-insertion=iwyu', '--suggest-missing-includes=true' };
  capabilities = settings.capabilities,
  on_attach = settings.on_attach,
}
