local settings = require("lsp.server_config")
settings.lsp.pylsp.setup {
  on_attach = settings.on_attach,
  capabilities = settings.capabilities,
}

