local M = {}

function M.setup()
  require("noice").setup({
    lsp = {
      signature = {
        enabled = true,
        auto_open = { enabled = false },
      },
      progress = { enabled = false },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      lsp_doc_border = true,
    },
  })
end

return M
