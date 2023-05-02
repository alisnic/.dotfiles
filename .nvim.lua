local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require "lspconfig"

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

local null_ls = require "null-ls"

null_ls.setup {
  on_attach = function(client)
    _G.on_attach_callback(client, 1)
  end,
  sources = {
    null_ls.builtins.formatting.stylua.with {
      extra_args = {
        "--config-path",
        vim.fn.expand "~/.config/stylua.toml",
      },
    },
  },
}
