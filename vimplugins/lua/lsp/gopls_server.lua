local settings = require("lsp.server_config")

vim.api.nvim_exec([[autocmd BufWritePre *.go lua Go_org_imports()]], false)
-- Omnifunc
vim.api.nvim_exec([[autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc]], false)
settings.lsp.gopls.setup {
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  root_dir = settings.lsp.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  on_attach = settings.on_attach,
  capabilities = settings.capabilities,
}

function Go_org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
end


