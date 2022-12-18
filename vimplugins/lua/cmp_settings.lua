-- Set up nvim-cmp.
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require 'cmp'
local lspkind = require("lspkind")
local menu = ({ buffer = "[BUFFER]",
	nvim_lsp = "[LSP]",
	nvim_lsp_signature_help = "[LSP SIG]",
	luasnip = "[SNIPPET]",
	nvim_lua = "[LUA]",
	path = "[PATH]",
	crates = "[CRATES]",
	treesitter = "[TREE]", })

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		--completion = cmp.config.window.bordered(),
		--documentation = cmp.config.window.bordered(),
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
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip' }, -- For luasnip users.
		--{ name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'crates' },
	}, {
	}),
	performance = {
		throttle = 100,
		debounce = 500,
		fetching_timeout = 200,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 35 })(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. strings[1] .. " "
			kind.menu = "[" .. strings[2] .. "]"
				--vim_item.kind = "=>"--menu[entry.source_name]
				--vim_item.menu = "=>"-- .. menu[entry.source_name]
			vim_item.abbr = vim_item.abbr:match("[^(]+")
			--vim_item.abbr = vim_item.abbr:gsub("%((.-)%)", "()")
			return vim_item
			end,
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
