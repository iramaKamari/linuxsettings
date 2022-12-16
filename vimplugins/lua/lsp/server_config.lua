local M = {}
-- Lsp settings
M.lsp = require('lspconfig')
M.capabilities = require('cmp_nvim_lsp').default_capabilities()
---@diagnostic disable-next-line: unused-function
M.on_attach = function(_, bufnr)
  local fzf = require('fzf-lua'),
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.diagnostic.config({ virtual_text = false })

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>lD', fzf.lsp_declarations, opts)
  vim.keymap.set('n', '<leader>ld', fzf.lsp_definitions, opts)
  vim.keymap.set('n', '<leader>lr', fzf.lsp_references, opts)
  vim.keymap.set('n', '<leader>li', fzf.lsp_implementations, opts)
  vim.keymap.set('n', '<leader>lic', fzf.lsp_incoming_calls, opts)
  vim.keymap.set('n', '<leader>loc', fzf.lsp_outgoing_calls, opts)
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(fzf.lsp.buf.list_workspace_folders())) end, opts)
  --vim.keymap.set('n', '<leader>d', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>d', fzf.lsp_typedefs, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>ca', fzf.lsp_code_actions, opts)
  vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, opts)
end
return M
