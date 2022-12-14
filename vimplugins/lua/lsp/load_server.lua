local load_lsp = function(pattern, server)
   vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        pattern = pattern,
        callback = function() server() end,
    })
end
local server = function(server)
    require(server)
end

load_lsp({"c", "cpp", "objc", "objcpp", "cuda", "proto"},
    server("lsp.clangd_server"))
load_lsp({"go", "gomod", "gowork", "gotmpl"},
    server("lsp.gopls_server"))
load_lsp({"python"}, server("lsp.pylsp_server"))
load_lsp({"rust"}, server("lsp.rust_server"))
load_lsp({"lua"}, server("lsp.sumneko_lua_server"))

