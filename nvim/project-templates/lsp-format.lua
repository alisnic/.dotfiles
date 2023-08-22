local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").eslint.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
    require("lsp-format").on_attach(client)
  end,
  flags = { debounce_text_changes = 400 },
}

local null_ls = require "null-ls"

require("lsp-format").setup {
  order = { "eslint", "null-ls" },
}

null_ls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
    require("lsp-format").on_attach(client)
  end,
  sources = {
    null_ls.builtins.formatting.prettier.with {
      filetypes = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
      },
    },
    null_ls.builtins.diagnostics.cspell.with {
      filetypes = { "typescript", "typescriptreact" },
    },
  },
}
