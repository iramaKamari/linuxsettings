local lsp = require("lsp.settings")
vim.api.nvim_exec([[
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
]], false)

lsp.lsp.clangd.setup {
  cmd = { 'clangd', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium',
    '--header-insertion=iwyu', '--suggest-missing-includes=true' };
  capabilities = lsp.lsp.capabilities,
  on_attach = lsp.lsp.attach(_, bufnr),
}
