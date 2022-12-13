local lsp = require("lspsettings").nvim_lsp
lsp.sumneko_lua.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
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

