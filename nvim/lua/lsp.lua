local border = "rounded"

vim.keymap.set("n", "<leader>k", function()
  vim.lsp.buf.hover()
end)
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { focus = false, scope = "cursor", border = border })
end)

vim.keymap.set("n", "gd", vim.lsp.buf.definition)

vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gD", ":vsplit<cr>:lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("i", "<C-k>", function()
  vim.lsp.buf.signature_help()
end)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gR", ":vsplit<cr>:lua vim.lsp.buf.references()<cr>")
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, severity = { min = vim.diagnostic.severity.WARN } })
end)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, severity = { min = vim.diagnostic.severity.WARN } })
end)
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end)
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>lT", ":vsplit<cr>:lua vim.lsp.buf.type_definition()<cr>")

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local tsgo_diagnostics_group = vim.api.nvim_create_augroup("TsgoPullDiagnostics", { clear = true })

local function refresh_tsgo_diagnostics(bufnr, client_id, only_visible)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not client or client.name ~= "tsgo" then
    return
  end

  if not client:supports_method("textDocument/diagnostic") then
    return
  end

  vim.lsp.diagnostic._refresh(bufnr, client_id, only_visible)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end

    if client and client.name == "tsgo" then
      refresh_tsgo_diagnostics(args.buf, client.id, true)
      vim.api.nvim_clear_autocmds({ buffer = args.buf, group = tsgo_diagnostics_group })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        buffer = args.buf,
        group = tsgo_diagnostics_group,
        callback = function()
          refresh_tsgo_diagnostics(args.buf, client.id, true)
        end,
      })
    end
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.lsp.config("oxlint", {
  settings = {
    -- In pull-diagnostics mode, oxlint expects the client to decide when to
    -- request diagnostics. VS Code can limit pulls to saves; Neovim currently
    -- pulls on change, so `onSave` leaves diagnostics stale.
    run = "onType",
  },
})

vim.lsp.enable({ "jsonls" })
