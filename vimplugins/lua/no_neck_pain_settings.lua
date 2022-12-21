local nnp = require("no-neck-pain")
nnp.setup()
vim.api.nvim_create_augroup("OnVimEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = "OnVimEnter",
	pattern = "*",
	callback = function()
        vim.schedule(function() nnp.enable() end)
	end,
})
