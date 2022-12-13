-- Lsp settings
local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
---@diagnostic disable-next-line: unused-function
local on_attach = function(_, bufnr)
  local fzf = require('fzf-lua'),
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.diagnostic.config({ virtual_text = false })

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>gD', fzf.lsp_declarations, opts)
  vim.keymap.set('n', '<leader>gd', fzf.lsp_definitions, opts)
  vim.keymap.set('n', '<leader>gr', fzf.lsp_references, opts)
  vim.keymap.set('n', '<leader>gi', fzf.lsp_implementations, opts)
  vim.keymap.set('n', '<leader>gic', fzf.lsp_incoming_calls, opts)
  vim.keymap.set('n', '<leader>goc', fzf.lsp_outgoing_calls, opts)
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

vim.api.nvim_exec([[
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
]], false)

lsp.clangd.setup {
  cmd = { 'clangd', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium',
    '--header-insertion=iwyu', '--suggest-missing-includes=true' };
  on_attach = on_attach,
  capabilities = capabilities,
}

lsp.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lsp.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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

vim.api.nvim_exec([[autocmd BufWritePre *.go lua Go_org_imports()]], false)
-- Omnifunc
vim.api.nvim_exec([[autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc]], false)
lsp.gopls.setup {
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  root_dir = lsp.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,
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

-- all the opts to send to nvim-lspconfig
-- these override the defaults set by rust-tools.nvim
-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
local opts = {
  tools = { -- rust-tools options
    executor = require("rust-tools.executors").termopen,
    autoSetHints = true,
    --hover_with_actions = true,
    reload_workspace_from_cargo_toml = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      highlight = "Comment",
    },
    hover_actions = {
      -- the border that is used for the hover window
      -- see vim.api.nvim_open_win()
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },
    },
    -- settings for showing the crate graph based on graphviz and the dot
    -- command
    crate_graph = {
      -- Backend used for displaying the graph
      -- see: https://graphviz.org/docs/outputs/
      -- default: x11
      backend = "x11",
      -- where to store the output, nil for no output stored (relative
      -- path from pwd)
      -- default: nil
      output = nil,
      -- true for all crates.io and external crates, false only the local
      -- crates
      -- default: true
      full = true,

      -- List of backends found on: https://graphviz.org/docs/outputs/
      -- Is used for input validation and autocompletion
      -- Last updated: 2021-08-26
      enabled_graphviz_backends = {
        "bmp",
        "cgimage",
        "canon",
        "dot",
        "gv",
        "xdot",
        "xdot1.2",
        "xdot1.4",
        "eps",
        "exr",
        "fig",
        "gd",
        "gd2",
        "gif",
        "gtk",
        "ico",
        "cmap",
        "ismap",
        "imap",
        "cmapx",
        "imap_np",
        "cmapx_np",
        "jpg",
        "jpeg",
        "jpe",
        "jp2",
        "json",
        "json0",
        "dot_json",
        "xdot_json",
        "pdf",
        "pic",
        "pct",
        "pict",
        "plain",
        "plain-ext",
        "png",
        "pov",
        "ps",
        "ps2",
        "psd",
        "sgi",
        "svg",
        "svgz",
        "tga",
        "tiff",
        "tif",
        "tk",
        "vml",
        "vmlz",
        "wbmp",
        "webp",
        "xlib",
        "x11",
      },
    },
  },
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    capabilities = capabilities,
    standalone = true,
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
