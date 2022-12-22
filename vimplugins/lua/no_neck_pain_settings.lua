local nnp = require("no-neck-pain")
local keymap_opts = { noremap = true, silent = false }
nnp.setup()
vim.api.nvim_create_augroup("OnVimEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = "OnVimEnter",
	pattern = "*",
	callback = function()
		vim.keymap.set('n', '<leader>N', function() nnp.toggle() end, keymap_opts)
	end,
})
