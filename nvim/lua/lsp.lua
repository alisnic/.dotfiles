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

local enabled_servers = { "jsonls", "lua_ls" }
local tsgo_root_markers =
  { "tsconfig.json", "jsconfig.json", "package.json", ".git", "tsconfig.base.json" }

local function executable(path)
  return path and path ~= "" and vim.fn.executable(path) == 1
end

local function resolve_tsgo_bin(root_dir)
  local bin = vim.fs.joinpath(root_dir or vim.fn.getcwd(), "node_modules/.bin/tsgo")
  if executable(bin) then
    return bin
  end

  return nil
end

local function tsgo_cmd(dispatchers, config)
  local bin = resolve_tsgo_bin(config.root_dir)
  if not bin then
    error("tsgo not found in node_modules/.bin")
  end

  local cmd = {
    bin,
    "--lsp",
    "--stdio",
  }

  config._resolved_cmd = cmd

  return vim.lsp.rpc.start(cmd, dispatchers, {
    cwd = config.cmd_cwd,
  })
end

local function tsgo_root_dir(bufnr, on_dir)
  local root_dir = vim.fs.root(bufnr, tsgo_root_markers)
  if not root_dir then
    return
  end

  if not resolve_tsgo_bin(root_dir) then
    vim.notify("tsgo not found in node_modules/.bin; not starting tsgo LSP", vim.log.levels.WARN)
    return
  end

  on_dir(root_dir)
end

local function format_list(items)
  if not items or #items == 0 then
    return "-"
  end

  return table.concat(items, ", ")
end

local function client_root(client)
  if client.workspace_folders and #client.workspace_folders > 0 then
    local roots = {}
    for _, folder in ipairs(client.workspace_folders) do
      roots[#roots + 1] = vim.uri_to_fname(folder.uri)
    end

    return format_list(roots)
  end

  return client.config.root_dir or "-"
end

local function diagnostic_summary(bufnr)
  local counts = vim.diagnostic.count(bufnr)
  local severity = vim.diagnostic.severity

  return string.format(
    "errors: %d, warnings: %d, info: %d, hints: %d",
    counts[severity.ERROR] or 0,
    counts[severity.WARN] or 0,
    counts[severity.INFO] or 0,
    counts[severity.HINT] or 0
  )
end

local function show_lsp_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local lines = {
    "# LSP Info",
    "",
    "## Buffer",
    string.format("- buffer: %d", bufnr),
    string.format("- path: %s", vim.fn.expand("%:p")),
    string.format("- filetype: %s", vim.bo[bufnr].filetype),
    string.format("- diagnostics: %s", diagnostic_summary(bufnr)),
    "",
    "## Configured Servers",
    string.format("- %s", format_list(enabled_servers)),
    "",
    "## Attached Clients",
  }

  if #clients == 0 then
    lines[#lines + 1] = "- none"
  else
    for _, client in ipairs(clients) do
      local cmd = client.config._resolved_cmd or client.config.cmd

      lines[#lines + 1] = string.format("- %s (id: %d)", client.name, client.id)
      lines[#lines + 1] = string.format("  - root: %s", client_root(client))
      lines[#lines + 1] =
        string.format("  - cmd: %s", type(cmd) == "table" and format_list(cmd) or "-")
    end
  end

  local info_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(info_buf, 0, -1, false, lines)
  vim.bo[info_buf].bufhidden = "wipe"
  vim.bo[info_buf].buftype = "nofile"
  vim.bo[info_buf].filetype = "markdown"
  vim.bo[info_buf].modifiable = false
  vim.bo[info_buf].swapfile = false

  vim.cmd("botright 16split")
  vim.api.nvim_win_set_buf(0, info_buf)
end

vim.api.nvim_create_user_command("LspInfo", show_lsp_info, { desc = "Show LSP client information" })

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

vim.lsp.enable(enabled_servers)
