local M = {}

function M.setup()
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })

  local get_option = vim.filetype.get_option
  vim.filetype.get_option = function(filetype, option)
    return option == "commentstring"
        and require("ts_context_commentstring.internal").calculate_commentstring()
      or get_option(filetype, option)
  end

  require("nvim-ts-autotag").setup()

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  local ts_context = require("treesitter-context")
  ts_context.setup({ max_lines = 3 })

  vim.keymap.set("n", "[c", function()
    ts_context.go_to_context()
  end, { silent = true })
end

return M
