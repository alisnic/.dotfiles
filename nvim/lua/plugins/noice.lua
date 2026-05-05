local M = {}

function M.setup()
  require("noice").setup({
    lsp = {
      signature = {
        enabled = true,
        auto_open = { enabled = false },
      },
      hover = { enabled = true },
      progress = { enabled = false },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    messages = {
      view_search = false,
    },
    views = {
      hover = {
        border = {
          style = "rounded",
        },
      },
    },
    presets = {
      lsp_doc_border = true,
    },
  })
end

return M
