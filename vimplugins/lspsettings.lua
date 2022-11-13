-- Lsp settings
vim.api.nvim_exec([[
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
]], false)
local nvim_lsp = require('lspconfig')
local nvim_lsp_util = require('lspconfig/util')
--require('telescope').setup{}
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  require'completion'.on_attach()
  vim.diagnostic.config({virtual_text = false})

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>L', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>', opts) Use if format on save

  -- Set some keybinds conditional on server capabilities
  local code_format_opts = { "tabSize=2", "insestSpaces=true", "trimTrailingWhitespace?=true", "insertFinalNewLine?=false", "trimFinalNewLines?=true"}
  if client then
    if client.resolved_capabilities.document_formatting then
      buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end
    if client.resolved_capabilities.document_range_formatting then
      buf_set_keymap('v', '<leader>cf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    end
  end
end

nvim_lsp.pylsp.setup{
  on_attach = on_attach
}
nvim_lsp.clangd.setup{
  cmd = {'clangd-14', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium', '--header-insertion=iwyu', '--suggest-missing-includes=true'};
  on_attach = on_attach
}
nvim_lsp.gopls.setup {
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = nvim_lsp_util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
	unusedparams = true,
      },
      staticcheck = true,
    },
  },
  on_attach = on_attach
}

function Go_org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
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

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        --hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
	version = "LuaJIT",
      },
      diagnostics = {
	globals = {"vim"},
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
