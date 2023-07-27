local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").eslint.setup {
  capabilities = capabilities,
  flags = { debounce_text_changes = 400 },
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

local autofix_eslint_rules =
  { "simple-import-sort/imports", "curly", "prefer-destructuring" }

local skip_filetypes = { "qf" }

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local bufnr = event.buf

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function(event)
        if vim.tbl_contains(skip_filetypes, vim.bo.filetype) then
          return
        end

        local diagnostics = vim.diagnostic.get(event.buf)

        for _, value in pairs(diagnostics) do
          if
            value.source == "eslint"
            and vim.tbl_contains(autofix_eslint_rules, value.user_data.lsp.code)
          then
            vim.cmd "EslintFixAll"
            break
          end
        end

        vim.lsp.buf.format {
          bufnr = event.buf,
          filter = function(client)
            return client.name == "null-ls"
          end,
        }
      end,
    })
  end,
})
