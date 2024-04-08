vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(
    nil,
    { focus = false, scope = "cursor", border = "rounded" }
  )
end)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gD", ":vsplit<cr>:lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gR", ":vsplit<cr>:lua vim.lsp.buf.references()<cr>")
vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } }
end)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } }
end)
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require "lspconfig"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
    require("lsp-format").on_attach(client)
  end,
})

require("neodev").setup()

require("lspconfig.configs").vtsls = require("vtsls").lspconfig
-- vim.cmd "command! RemoveUnusedImports :VtsExec remove_unused_imports"

vim.keymap.set("n", "gs", ":VtsExec goto_source_definition<cr>")

-- lspconfig.vtsls.setup {
--   capabilities = capabilities,
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--     client.server_capabilities.semanticTokensProvider = false
--   end,
--   settings = {
--     typescript = { preferences = { includePackageJsonAutoImports = "off" } },
--     vtsls = { experimental = { completion = { entriesLimit = 50 } } },
--   },
-- }
require("typescript-tools").setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    tsserver_path = "node_modules/typescript/bin/tsserver",
    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = false,
  },
}

require("lspconfig").jsonls.setup {
  capabilities = capabilities,
}

local util = require "lspconfig.util"
local configs = require "lspconfig.configs"

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      workspace = { checkThirdParty = false },
    },
  },
}

configs.oxc_language_server = {
  default_config = {
    cmd = {
      "/Users/andreilisnic/Work/oxc/editors/vscode/target/release/oxc_language_server",
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
        or util.find_node_modules_ancestor(fname)
        or util.find_git_ancestor(fname)
    end,
    settings = {
      ["enable"] = true,
      -- ["run"] = "onType",
    },
  },
}

lspconfig.oxc_language_server.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

require("lspconfig").rust_analyzer.setup {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        experimental = { enable = true },
      },
    },
  },
}

capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").cssls.setup {
  capabilities = capabilities,
}

local null_ls = require "null-ls"

null_ls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
}

if
  vim.fn.filereadable ".prettierrc" or vim.fn.filereadable ".prettierrc.js"
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

if vim.fn.filereadable "cspell.json" then
  null_ls.register {
    null_ls.builtins.diagnostics.cspell.with {
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
