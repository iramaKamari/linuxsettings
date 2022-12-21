local settings = require("lsp.server_config")
settings.lsp.sumneko_lua.setup {
  on_attach = settings.on_attach,
  capabilities = settings.capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "5.4.4",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

