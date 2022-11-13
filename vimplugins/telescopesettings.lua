local telescope = require("telescope")
local builtin = require("telescope.builtin")

local project_files = function()
	local opts = {}
	vim.fn.system("git rev-parse --is-inside-work-tree")
	if vim.v.shell_error == 0 then
		builtin.git_files(opts)
	else
		builtin.find_files(opts)
	end
end

vim.keymap.set('n', '§', function() builtin.buffers() end)
vim.keymap.set('n', '<leader>g', function() builtin.grep_string({ search = vim.fn.input("Grep for > ") }) end)
vim.keymap.set('n', '<leader>G', function() builtin.grep_string() end)
vim.keymap.set("n", "<leader>f", function() project_files() end)

telescope.setup {
	defaults = {
		vimgrep_arguments = {
			"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--smart-case", "--column", "--trim"
		}
	}
}
telescope.load_extension("fzf")
