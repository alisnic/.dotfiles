vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(
    nil,
    { focus = false, scope = "cursor", border = "rounded" }
  )
end)

vim.keymap.set("n", "gd", function()
  require("nvim-treesitter.refactor.navigation").goto_definition_lsp_fallback()
end, { buffer = 0 })

vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gD", ":vsplit<cr>:lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gR", ":vsplit<cr>:lua vim.lsp.buf.references()<cr>")
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump { count = -1, severity = { min = vim.diagnostic.severity.WARN } }
end)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump { count = 1, severity = { min = vim.diagnostic.severity.WARN } }
end)
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)
vim.keymap.set(
  "n",
  "<leader>lT",
  ":vsplit<cr>:lua vim.lsp.buf.type_definition()<cr>"
)

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
      require("lsp-format").on_attach(client)
    end
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      workspace = { checkThirdParty = false },
    },
  },
})

local oxlint_bin = vim.fs.find("node_modules/.bin/oxlint", {
  path = vim.fn.getcwd(),
  upward = true,
  type = "file",
})[1] or "oxlint"

vim.lsp.config("oxlint", {
  cmd = { oxlint_bin, "--lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
})

vim.lsp.enable { "jsonls", "lua_ls", "oxlint" }

local null_ls = require "null-ls"

null_ls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
}

if
  vim.fn.filereadable ".prettierrc" == 1
  or vim.fn.filereadable ".prettierrc.js" == 1
then
  null_ls.register {
    null_ls.builtins.formatting.prettier.with {
      cmd = "node ./node_modules/prettier/bin-prettier.js",
      filetypes = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
      },
    },
  }
end

null_ls.register {
  null_ls.builtins.formatting.stylua.with {
    extra_args = {
      "--config-path",
      vim.fn.expand "~/.config/stylua.toml",
    },
  },
}
