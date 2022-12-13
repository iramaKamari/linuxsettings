local lsp = require("lspsettings").nvim_lsp
lsp.pylsp.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

