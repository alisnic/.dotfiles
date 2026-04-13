local M = {}

function M.setup()
  vim.o.autoread = true

  local oc = require("opencode")

  local function find_opencode_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" then
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match("opencode %-%-port") then
          return win
        end
      end
    end
  end

  local function toggle_opencode_focus()
    local win = find_opencode_win()
    if win then
      if vim.api.nvim_get_current_win() == win then
        oc.toggle()
      else
        vim.api.nvim_set_current_win(win)
        vim.cmd("startinsert")
      end
      return
    end

    oc.toggle()
    vim.schedule(function()
      local opened_win = find_opencode_win()
      if opened_win then
        vim.api.nvim_set_current_win(opened_win)
        vim.cmd("startinsert")
      end
    end)
  end

  vim.keymap.set({ "n", "x" }, "<C-a>", function()
    oc.ask("@this: ", { submit = true })
  end, { desc = "Ask opencode…" })

  vim.keymap.set({ "n", "x" }, "<C-x>", function()
    oc.select()
  end, { desc = "Execute opencode action…" })

  vim.keymap.set({ "n", "t" }, "<F13>", toggle_opencode_focus, { desc = "Toggle opencode" })

  vim.keymap.set({ "n", "x" }, "go", function()
    return oc.operator("@this ")
  end, { desc = "Add range to opencode", expr = true })

  vim.keymap.set("n", "goo", function()
    return oc.operator("@this ") .. "_"
  end, { desc = "Add line to opencode", expr = true })

  vim.keymap.set("n", "<S-C-u>", function()
    oc.command("session.half.page.up")
  end, { desc = "Scroll opencode up" })

  vim.keymap.set("n", "<S-C-d>", function()
    oc.command("session.half.page.down")
  end, { desc = "Scroll opencode down" })
end

return M
