-- Openbrowser {{{
vim.api.nvim_exec([[
let g:openbrowser_browser_commands = [
\{'name': '/usr/bin/firefox',
\'args': ['start', '{browser}', '{uri}']}
\]
]], false)

