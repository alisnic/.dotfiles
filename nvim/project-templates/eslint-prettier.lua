local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").eslint.setup {
  capabilities = capabilities,
  flags = { debounce_text_changes = 400 }
}

local null_ls = require "null-ls"

null_ls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local bufnr = event.buf

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function(event)
        local diagnostics = vim.diagnostic.get(event.buf)

        for _, value in pairs(diagnostics) do
          if value.source == "eslint" then
            vim.cmd "EslintFixAll"
            break
          end
        end

        vim.lsp.buf.format { bufnr = event.buf }
      end,
    })
  end,
})
