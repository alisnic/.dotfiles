function config()
  local cmp = require "cmp"
  local lspkind = require "lspkind"

  cmp.setup {
    snippet = {
      expand = function(args)
        require("snippy").expand_snippet(args.body)
      end,
    },
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        menu = {
          buffer = "[Buf]",
          tags = "[Tag]",
          nvim_lsp = "[LSP]",
        },
      },
    },
    completion = {
      keyword_length = 2,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm { select = false },
    },
    sources = cmp.config.sources({
      { name = "buffer" },
      { name = "nvim_lsp" },
    }, {
      { name = "tags" },
    }),
  }

  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "emoji" },
      { name = "spell" },
    }, {
      { name = "buffer" },
    }),
  })
end

local M = {}

M.setup = function(use)
  use {
    "dcampos/nvim-snippy",
    config = function()
      require("snippy").setup {
        mappings = {
          is = {
            ["<Tab>"] = "expand_or_advance",
            ["<S-Tab>"] = "previous",
          },
        },
      }
    end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "onsails/lspkind-nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "f3fora/cmp-spell" },
      { "quangnguyen30192/cmp-nvim-tags" },
    },
    config = config,
  }
end

return M
