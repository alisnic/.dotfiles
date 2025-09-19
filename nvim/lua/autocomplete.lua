local cmp = require "cmp"
local lspkind = require "lspkind"
-- local luasnip = require "luasnip"

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match "%s"
      == nil
end

return {
  setup = function()
    cmp.setup.filetype("markdown", { sources = { { name = "buffer" } } })

    cmp.setup {
      -- snippet = {
      --   expand = function(args)
      --     luasnip.lsp_expand(args.body)
      --   end,
      -- },
      window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = "text_icon",
        },
      },
      performance = {
        -- max_view_entries = 10,
        debounce = 200,
      },
      completion = {
        keyword_length = 2,
      },
      mapping = {
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- elseif luasnip.expand_or_locally_jumpable() then
          --   luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = function(fallback)
          -- Don't block <CR> if signature help is active
          -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
          if
            not cmp.visible()
            or not cmp.get_selected_entry()
            or cmp.get_selected_entry().source.name
              == "nvim_lsp_signature_help"
          then
            fallback()
          else
            cmp.confirm {
              -- Replace word if completing in the middle of a word
              -- https://github.com/hrsh7th/nvim-cmp/issues/664
              behavior = cmp.ConfirmBehavior.Replace,
              -- Don't select first item on CR if nothing was selected
              select = false,
            }
          end
        end,
      },
      sources = cmp.config.sources({
        -- { name = "luasnip" },
        { name = "copilot" },
        { name = "nvim_lsp" },
      }, {
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
      }),
      experimental = { ghost_text = true },
    }

    -- cmp.setup.cmdline("/", {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = "buffer" },
    --   },
    -- })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
      sources = cmp.config.sources {
        { name = "buffer" },
      },
    })
  end,
}
