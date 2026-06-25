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

local function is_typescript_go_client(client)
  return client and (client.name == "tsgo" or client.name == "ts7")
end

local function refresh_tsgo_diagnostics(bufnr, client_id, only_visible)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not is_typescript_go_client(client) then
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

    if is_typescript_go_client(client) then
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

vim.lsp.config("ts7", {
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "none",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = false },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = false },
        enumMemberValues = { enabled = false },
      },
    },
  },
  cmd = function(dispatchers, config)
    local cmd = "tsc"
    local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/tsc"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
  end,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })

    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      return
    end

    on_dir(project_root or vim.fn.getcwd())
  end,
})

vim.lsp.enable({ "jsonls" })
