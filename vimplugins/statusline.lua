local Metatable = {}

local Colors = {
  dark = '#000000',
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
vim.api.nvim_command('hi LightFg guifg=' .. Colors.light)
vim.api.nvim_command('hi RedFg guifg=' .. Colors.red)
vim.api.nvim_command('hi RedBg guifg=' .. Colors.dark .. ' guibg=' .. Colors.red)
vim.api.nvim_command('hi GreenFg guifg=' .. Colors.green)
vim.api.nvim_command('hi YellowFg guifg=' .. Colors.yellow)
vim.api.nvim_command('hi BlueFg guifg=' .. Colors.blue)
vim.api.nvim_command('hi PurpleFg guifg=' .. Colors.purple)
vim.api.nvim_command('hi AquaFg guifg=' .. Colors.aqua)
vim.api.nvim_command('hi OrangeFg guifg=' .. Colors.orange)

Metatable.highlights = {
  darkFg = "%#DarkFg#",
  grayFg = "%#GrayFg#",
  lightFg = "%#LightFg#",
  redFg = "%#RedFg#",
  redBg = "%#RedBg#",
  greenFg = "%#GreenFg#",
  yellowFg = "%#YellowFg#",
  purpleFg = "%#PurpleFg#",
  aquaFg = "%#AquaFg#",
  orangeFg = "%#OrangeFg#",
}

Metatable.trunc_width = setmetatable({
  git_status = 90,
  filename = 140,
}, {
  __index = function()
    return 80
  end,
})

Metatable.is_truncated = function(_, width)
  return vim.api.nvim_win_get_width(0) < width
end

Metatable.modes = setmetatable({
  ["n"]  = {"Normal", "redFg"},
  ["no"] = {"N·Operator Pending", "redFg"},
  ["v"]  = {"Visual", "redBg"},
  ["V"]  = {"V·Line", "redBg"},
  [""] = {"V·Block", "redBg"},
  ["s"]  = {"Select ", "purpleFg"},
  ["S"]  = {"S·Line", "purpleFg"},
  [""] = {"S·Block", "purpleFg"},
  ["i"]  = {"Insert", "yellowFg"},
  ["R"]  = {"Replace", "yellowFg"},
  ["Rv"] = {"V·Replace", "yellowFg"},
  ["c"]  = {"Command", "orangeFg"},
  ["cv"] = {"Vim Ex", "orangeFg"},
  ["ce"] = {"Ex", "orangeFg"},
  ["r"]  = {"Prompt", "aquaFg"},
  ["rm"] = {"More", "aquaFg"},
  ["r?"] = {"Confirm", "blueFg"},
  ["!"]  = {"Shell", "redFg"},
  ["t"]  = {"Terminal", "redFg"},
}, {
  __index = function()
    return {"Unkown", "grayFg"} -- edge cases
  end,
})

Metatable.get_current_mode = function(self)
  local value = self.modes[vim.api.nvim_get_mode().mode]
  return string.format("%s%s", self.highlights[value[2]], value[1]:upper())
end

Metatable.get_git_info = function(self)
  local git_branches_file = io.popen("git rev-parse --abbrev-ref HEAD", "r")
  local git = git_branches_file:read("*l")
  io.close(git_branches_file)
  return (git ~= '' or not git) and string.format(" %s", git or "") or ""
end

Metatable.get_filename_and_modifiable = function(self)
  local modifiable = ""
  local file_name = "%<%f"
  if vim.api.nvim_buf_get_option(0, 'readonly')
    or not vim.api.nvim_buf_get_option(0, 'modifiable') then
    modifiable = self.highlights.redFg .. " "
  end
  return string.format("%s%s", file_name, modifiable)
end

Metatable.get_filetype_and_size = function(self)
  local file_size = vim.fn.getfsize(vim.fn.expand('%:p'))
  local size_text = "B"
  if file_size >= 1024 then
    file_size =  file_size/1024
    size_text = "KB"
  end
  if file_size >= 1000 and size_text == "KB" then
    file_size =  file_size/1000
    size_text = "MB"
  end
  return string.format("[%s] [%.1f%s]", vim.bo.filetype:lower(), file_size, size_text)
end

Metatable.get_encoding_and_fileformat = function()
  local encoding = vim.api.nvim_buf_get_option(0, 'fenc') and
    vim.api.nvim_get_option('enc') or
    vim.api.nvim_buf_get_option(0, 'fenc')
  return  "[" .. encoding  .. " " ..
    vim.api.nvim_buf_get_option(0, 'ff') .. "]"
end

Metatable.set_active = function(self)
  local hi = self.highlights

  local git = hi.greenFg .. self:get_git_info()
  local filename = hi.aquaFg .. self:get_filename_and_modifiable()
  local filetype = hi.aquaFg .. self:get_filetype_and_size()
  local encodeff = hi.aquaFg .. self:get_encoding_and_fileformat()
  local line_col = hi.yellowFg .. "%l:%c"
  local seperator = " "
  return table.concat({
    self:get_current_mode(),
    seperator,
    git,
    seperator,
    filename,
    hi.redFg .. "%m%w",
    seperator,
    line_col,
    seperator,
    filetype,
    seperator,
    encodeff,
  })
end

Metatable.set_inactive = function(self)
  local hi = self.highlights

  local git = self:get_git_info()
  local filename = self:get_filename_and_modifiable()
  local filetype = self:get_filetype_and_size()
  local encodeff = self:get_encoding_and_fileformat()
  local line_col = "%l:%c"
  local seperator = " "
  return table.concat({
    hi.grayFg,
    seperator,
    git,
    seperator,
    filename,
    "%m%w",
    seperator,
    line_col,
    seperator,
    filetype,
    seperator,
    encodeff,
  })
end

Metatable.set_explorer = function(self)
  local title = self.colors.mode
  local title_alt = self.colors.mode_alt
  return table.concat({ self.colors.active, title, title_alt })
end

Statusline = setmetatable(Metatable, {
  __call = function(statusline, mode)
    if mode == "active" then
      return statusline:set_active()
    end
    if mode == "inactive" then
      return statusline:set_inactive()
    end
    if mode == "explorer" then
      return statusline:set_explorer()
    end
  end,
})

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]], false)
