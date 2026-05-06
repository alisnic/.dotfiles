local M = {}

local last_command
local terminal

local function make_command()
  local makeprg = vim.bo.makeprg

  if makeprg == "" then
    vim.cmd("doautocmd BufEnter")
    makeprg = vim.bo.makeprg
  end

  if makeprg == "" then
    vim.notify("'makeprg' is not set for this buffer", vim.log.levels.WARN)
    return
  end

  return vim.fn.expandcmd(makeprg)
end

local function close_terminal()
  if terminal and terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    pcall(terminal.close, terminal)
    pcall(vim.api.nvim_buf_delete, terminal.buf, { force = true })
  end
end

local function run(command)
  close_terminal()
  last_command = command
  terminal = Snacks.terminal.open(command, {
    interactive = false,
    auto_close = false,
    win = {
      position = "bottom",
      height = 0.35,
    },
  })
end

local function run_makeprg()
  local command = make_command()

  if command then
    run(command)
  end
end

local function run_makeprg_at_line()
  local command = make_command()

  if command then
    run(command .. ":" .. vim.fn.line("."))
  end
end

local function rerun_last()
  if not last_command then
    vim.notify("No test command has been run yet", vim.log.levels.WARN)
    return
  end

  run(last_command)
end

function M.setup()
  vim.keymap.set("n", "<leader>T", run_makeprg, { desc = "Run makeprg" })
  vim.keymap.set("n", "<leader>u", run_makeprg_at_line, { desc = "Run makeprg at line" })
  vim.keymap.set("n", "<leader>t", rerun_last, { desc = "Rerun last test" })
end

return M
