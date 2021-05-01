-- Lsp settings
vim.api.nvim_exec([[
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
]], false)
local nvim_lsp = require('lspconfig')
--require('telescope').setup{}
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  require'completion'.on_attach()
  require('lspfuzzy').setup {
    methods = 'all',         -- either 'all' or a list of LSP methods (see below)
    fzf_preview = {          -- arguments to the FZF '--preview-window' option
      'right:+{2}-/2'          -- preview on the right and centered on entry
    },
    fzf_action = {           -- FZF actions
      ['ctrl-t'] = 'tabedit',  -- go to location in a new tab
      ['ctrl-v'] = 'vsplit',   -- go to location in a vertical split
      ['ctrl-x'] = 'split',    -- go to location in a horizontal split
    },
    fzf_modifier = ':~:.',   -- format FZF entries, see |filename-modifiers|
    fzf_trim = true,         -- trim FZF entries
  }

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-K>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>L', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --buf_set_keymap('n', '<space>cf', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>', opts) Use if format on save

  -- Set some keybinds conditional on server capabilities
  local code_format_opts = { "tabSize=2", "insestSpaces=true", "trimTrailingWhitespace?=true", "insertFinalNewLine?=false", "trimFinalNewLines?=true"}
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<space>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('v', '<space>cf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  --if client.resolved_capabilities.document_highlight then
  --  vim.api.nvim_exec([[
  --    hi LspReferenceRead cterm=bold ctermbg=red guifg=black guibg=fg
  --    hi LspReferenceText cterm=bold ctermbg=red guifg=black guibg=fg
  --    hi LspReferenceWrite cterm=bold ctermbg=red guifg=black guibg=fg
  --    augroup lsp_document_highlight
  --      autocmd! * <buffer>
  --      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --    augroup END
  --  ]], false)
  --end
end

nvim_lsp.pyls.setup{
  on_attach = on_attach
}
--nvim_lsp.pyright.setup{
--  on_attach = on_attach
--}
--nvim_lsp.ccls.setup {
--  init_options = {
--    cache = {
--      directory = ".ccls-cache";
--    };
--  };
--  on_attach = on_attach
--}
nvim_lsp.clangd.setup{
  cmd = {'clangd', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium', '--header-insertion=iwyu', '--suggest-missing-includes=true'};
  on_attach = on_attach
}
