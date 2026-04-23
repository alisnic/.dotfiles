local M = {}

function M.setup()
  require("conform").setup({
    formatters_by_ft = {
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      typescript = { "oxfmt" },
      typescriptreact = { "oxfmt" },
      lua = { "stylua" },
      sh = { "shfmt" },
    },
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci", "-bn" },
      },
      oxfmt = {
        args = function(_, ctx)
          local cfg = vim.fs.find(
            { ".oxfmtrc.json", ".oxfmtrc.jsonc" },
            { path = ctx.dirname, upward = true }
          )[1]

          if cfg then
            return { "--stdin-filepath", ctx.filename }
          end

          return {
            "--config",
            vim.fn.expand("~/.config/oxfmt/default.json"),
            "--stdin-filepath",
            ctx.filename,
          }
        end,
      },
      stylua = {
        prepend_args = {
          "--config-path",
          vim.fn.expand("~/.config/stylua.toml"),
        },
      },
    },
    format_after_save = {
      lsp_format = "fallback",
    },
  })
end

return M
