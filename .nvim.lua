local null_ls = require "null-ls"

require("neodev").setup()

null_ls.setup {
  on_attach = function(client)
    require("lsp-format").on_attach(client)
  end,
  sources = {
    null_ls.builtins.formatting.stylua.with {
      extra_args = {
        "--config-path",
        vim.fn.expand "~/.config/stylua.toml",
      },
    },
  },
}
