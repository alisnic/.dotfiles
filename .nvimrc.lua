local luadev = require("lua-dev").setup {
  lspconfig = {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      _G.on_attach_callback(client, bufnr)
    end,
  },
}

require("lspconfig").sumneko_lua.setup(luadev)
