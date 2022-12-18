local load_lsp = function(pattern, server)
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = pattern,
        callback = function() server() end,
    })
end

local server = function(server)
    require(server)
end

local ServerTable = {
    { { "c", "cpp", "objc", "objcpp", "cuda", "proto" }, "lsp.clangd_server" },
    { { "go", "gomod", "gowork", "gotmpl" }, "lsp.gopls_server" },
    { { "python" }, "lsp.pylsp_server" },
    { { "rust" }, "lsp.rust_server" },
    { { "lua" }, "lsp.sumneko_lua_server" },
}

for _, t in pairs(ServerTable) do
    local pattern, lsp = table.unpack(t)
    load_lsp(pattern, server(lsp))
end
