-- Set up nvim-cmp.
local has_words_before = function()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require 'cmp'
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	completion = {
		keyword_length = 2,
		--autocomplete = false,
	},
	view = {
		entries = {
			name = "custom",
			selection_order = "near_cursor",
		}
	},
	mapping = {
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-s>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
				--elseif luasnip.jumpable(-1) then
				--    luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-l>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				return cmp.complete_common_string()
			end
			fallback()
		end, { 'i', 'c' }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'treesitter' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'crates' },
	}, {
	}),
	performance = {
		throttle = 100,
		debounce = 25,
		fetching_timeout = 200,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			lspkind.cmp_format({
				mode = "text",
				menu = ({
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					nvim_lsp_signature_help = "[LSP]",
					treesitter = "[Tree]",
					path = "[Path]",
					crates = "[Crates]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[Lua]",
					latex_symbols = "[Latex]",
				}),
				maxwidth = 35
			})(entry, vim_item)
			vim_item.abbr = vim_item.abbr:match("[^(]+")
			return vim_item
		end,
	},
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
			require("clangd_extensions.cmp_scores"),
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})
--})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	},
	view = {
		entries = { name = 'wildmenu', separator = '|' }
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})
