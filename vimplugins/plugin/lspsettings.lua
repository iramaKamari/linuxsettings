-- Lsp settings
vim.api.nvim_exec([[
autocmd FileType c nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
autocmd FileType cpp nnoremap <buffer> <leader>h :ClangdSwitchSourceHeader<CR>
]], false)
local nvim_lsp = require('lspconfig')
local nvim_lsp_util = require('lspconfig/util')
local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	vim.diagnostic.config({ virtual_text = false })

	local fzf = require('fzf-lua')
	-- Mappings.
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', fzf.lsp_declarations, opts)
	vim.keymap.set('n', 'gd', fzf.lsp_definitions, opts)
	vim.keymap.set('n', 'gr', fzf.lsp_references, opts)
	vim.keymap.set('n', 'gi', fzf.lsp_implementations, opts)
	vim.keymap.set('n', 'gic', fzf.lsp_incoming_calls, opts)
	vim.keymap.set('n', 'goc', fzf.lsp_outgoing_calls, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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

nvim_lsp.pylsp.setup {
	on_attach = on_attach
}
nvim_lsp.clangd.setup {
	cmd = { 'clangd', '-j=12', '--all-scopes-completion=true', '--background-index=true', '--fallback-style=chromium',
		'--header-insertion=iwyu', '--suggest-missing-includes=true' };
	on_attach = on_attach
}
nvim_lsp.gopls.setup {
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
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

nvim_lsp.julials.setup { on_attach = on_attach }
