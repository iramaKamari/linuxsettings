local fzf = require("fzf-lua")
local actions = require "fzf-lua.actions"
local keymap_opts = { noremap = true, silent = false }
vim.keymap.set('n', '§', function() fzf.buffers() end, keymap_opts)
vim.keymap.set('n', '<leader>g', function() fzf.grep() end, keymap_opts)
vim.keymap.set('n', '<leader>G', function() fzf.grep_cword() end, keymap_opts)
vim.keymap.set("n", "<leader>e", ':FzfLua<space>', keymap_opts)
keymap_opts.silent = true
vim.keymap.set("n", "<leader>f",
    function() fzf.files({ cmd = "rg --files", cwd = vim.fn.fnamemodify(vim.fn.bufname(), ':p:h') .. "/",
        actions = { ["default"] = actions.file_edit } }) end,
    keymap_opts)
vim.keymap.set("n", "<leader>F",
    function() fzf.files({ cmd = "rg --files", actions = { ["default"] = actions.file_edit } }) end, keymap_opts)

--vim.api.nvim_set_var('g:fzf_colors', "{'fg': ['fg', 'Normal'], 'bg': ['bg', 'Normal'], 'hl': ['fg', 'Comment'], 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+': ['bg', 'CursorLine', 'CursorColumn'], 'hl+': ['fg', 'Statement'], 'info': ['fg', 'PreProc'], 'border': ['fg', 'Ignore'], 'prompt': ['fg', 'Identifier'], 'pointer': ['fg', 'Exception'], 'marker': ['fg', 'Identifier'], 'spinner': ['fg', 'Label'], 'header': ['fg', 'Comment'] }")
fzf.setup {
    winopts = {
        hl = {
            border = "Normal",
        },
        preview = {
            wrap = 'wrap',
            vertical = 'down:70%',
            layout = 'vertical',
        },
        previewers = {
            builtin = {
                syntax = true,
                syntax_limit_l = 0,
                syntax_limit_b = 0,
                limit_b = 0,
            },
        },
        actions = {
            -- These override the default tables completely
            -- no need to set to `false` to disable an action
            -- delete or modify is sufficient
            files = {
                -- providers that inherit these actions:
                --   files, git_files, git_status, grep, lsp
                --   oldfiles, quickfix, loclist, tags, btags
                --   args
                -- default action opens a single selection
                -- or sends multiple selection to quickfix
                -- replace the default action with the below
                -- to open all files whether single or multiple
                ["default"] = actions.file_edit,
                --["default"]     = actions.file_edit_or_qf,
                ["ctrl-s"]  = actions.file_split,
                ["ctrl-v"]  = actions.file_vsplit,
                ["ctrl-t"]  = actions.file_tabedit,
                ["alt-q"]   = actions.file_sel_to_qf,
                ["alt-l"]   = actions.file_sel_to_ll,
            },
            buffers = {
                -- providers that inherit these actions:
                --   buffers, tabs, lines, blines
                ["default"] = actions.buf_edit,
                ["ctrl-s"]  = actions.buf_split,
                ["ctrl-v"]  = actions.buf_vsplit,
                ["ctrl-t"]  = actions.buf_tabedit,
            }
        },
        files = {
            -- previewer      = "bat",          -- uncomment to override previewer
            -- (name from 'previewers' table)
            -- set to 'false' to disable
            prompt       = 'Files❯ ',
            multiprocess = true, -- run command in a separate process
            git_icons    = true, -- show git icons?
            file_icons   = true, -- show file icons?
            color_icons  = true, -- colorize file|git icons
            path_shorten = 1, -- 'true' or number, shorten path?
            -- executed command priority is 'cmd' (if exists)
            -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
            -- default options are controlled by 'fd|rg|find|_opts'
            -- NOTE: 'find -printf' requires GNU find
            rg_opts      = "--color=always --files --hidden --follow -g '!.git'",
            fd_opts      = "--color=always --type f --hidden --follow --exclude .git",
            actions      = {
                -- inherits from 'actions.files', here we can override
                -- or set bind to 'false' to disable a default action
                ["default"] = actions.file_edit,
                -- custom actions are available too
                ["ctrl-y"]  = function(selected) print(selected[1]) end,
            }
        },
        grep = {
            prompt       = 'Rg❯ ',
            input_prompt = 'Grep For❯ ',
            multiprocess = true, -- run command in a separate process
            git_icons    = true, -- show git icons?
            file_icons   = true, -- show file icons?
            color_icons  = true, -- colorize file|git icons
            -- executed command priority is 'cmd' (if exists)
            -- otherwise auto-detect prioritizes `rg` over `grep`
            -- default options are controlled by 'rg|grep_opts'
            -- cmd            = "rg --vimgrep",
            grep_opts    = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
            rg_opts      = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
        },
    },
}
