local Metatable = {}
local fn = vim.fn

local Colors = {
  dark = '#000000',
  dark_soft = '#3c3836',
  gray = '#928374',
  light = '#fbf1c7',
  red = '#fb4934',
  green = '#b8bb26',
  yellow = '#fabd2f',
  blue = '#83a598',
  purple = '#d3869b',
  aqua = '#8ec07c',
  orange = '#fe8019',
}
vim.api.nvim_command('hi DarkFg guifg=' .. Colors.dark)
vim.api.nvim_command('hi GrayFg guifg=' .. Colors.gray)
vim.api.nvim_command('hi GrayBg guifg=' .. Colors.dark .. ' guibg=' .. Colors.dark_soft)
vim.api.nvim_command('hi LightFg guifg=' .. Colors.light)
vim.api.nvim_command('hi RedFg guifg=' .. Colors.red)
vim.api.nvim_command('hi RedBg guifg=' .. Colors.dark .. ' guibg=' .. Colors.red)
vim.api.nvim_command('hi GreenFg guifg=' .. Colors.green)
vim.api.nvim_command('hi YellowFg guifg=' .. Colors.yellow)
vim.api.nvim_command('hi BlueFg guifg=' .. Colors.blue)
vim.api.nvim_command('hi PurpleFg guifg=' .. Colors.purple)
vim.api.nvim_command('hi AquaFg guifg=' .. Colors.aqua)
vim.api.nvim_command('hi OrangeFg guifg=' .. Colors.orange)
vim.api.nvim_command('hi Blank guifg=' .. 'NONE' .. ' guibg=' .. 'NONE')

Metatable.highlights = {
  darkFg = "%#DarkFg#",
  grayFg = "%#GrayFg#",
  grayBg = "%#GrayBg#",
  lightFg = "%#LightFg#",
  redFg = "%#RedFg#",
  redBg = "%#RedBg#",
  greenFg = "%#GreenFg#",
  yellowFg = "%#YellowFg#",
  purpleFg = "%#PurpleFg#",
  aquaFg = "%#AquaFg#",
  orangeFg = "%#OrangeFg#",
  blank = "%#Blank#",
}

Metatable.options = {
    show_index = true,
    show_modify = true,
    modify_indicator = ' ✗',
    no_name = '[No Name]',
}

vim.api.nvim_command('hi TabLineSel gui=' .. 'BOLD' .. ' guifg=' .. Colors.orange .. ' guibg=NONE')
vim.api.nvim_command('hi TabLine gui=' .. 'BOLD' .. ' guifg=' .. Colors.aqua .. ' guibg=NONE')
vim.api.nvim_command('hi TabLineFill gui=' .. 'BOLD' .. ' guifg=NONE guibg=NONE')
local function tabline(options)
    local s = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, '&mod')

        s = s .. '%' .. index .. 'T'
        if index == fn.tabpagenr() then
            s = s .. '%#TabLineSel#'
        else
            s = s .. '%#TabLine#'
        end
        -- tab index
        s = s .. ' '
        -- index
        if options.show_index then
            s = s .. index .. ':'
        end
        -- buf name
        if bufname ~= '' then
            s = s .. fn.fnamemodify(bufname, ':p:h:t')
        else
            s = s .. options.no_name .. ' '
        end
        -- modify indicator
        if
            bufmodified == 1
            and options.show_modify
            and options.modify_indicator ~= nil
        then
            s = s .. options.modify_indicator
        end
    end

    s = s .. '%#TabLineFill#'
    return s
end

function Metatable.setup(user_options)
    Metatable.options = vim.tbl_extend('force', Metatable.options, user_options)

    function _G.nvim_tabline()
        return tabline(Metatable.options)
    end
    vim.o.showtabline = 1
    vim.o.tabline = '%!v:lua.nvim_tabline()'

    vim.g.loaded_nvim_tabline = 1
end

Metatable.setup(Metatable.options)
