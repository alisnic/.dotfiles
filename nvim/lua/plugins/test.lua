local M = {}

local last_command
local terminal
local follow_timer

local function node_text(node, bufnr)
  return vim.treesitter.get_node_text(node, bufnr)
end

local function call_name(node, bufnr)
  local fn = node:field("function")[1]

  if fn then
    return node_text(fn, bufnr)
  end
end

local function first_string_arg(node, bufnr)
  local arguments = node:field("arguments")[1]

  if not arguments then
    return
  end

  for child in arguments:iter_children() do
    local child_type = child:type()

    if child_type == "string" or child_type == "template_string" then
      return node_text(child, bufnr):sub(2, -2)
    end
  end
end

local function is_test_call(name)
  return name == "it"
    or name == "test"
    or name == "it.only"
    or name == "test.only"
    or name == "it.skip"
    or name == "test.skip"
    or name == "it.fixme"
    or name == "test.fixme"
    or name == "it.concurrent"
    or name == "test.concurrent"
end

local function nearest_test_title()
  local bufnr = vim.api.nvim_get_current_buf()
  pcall(vim.treesitter.start, bufnr)

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)

  if not ok or not parser then
    return
  end

  local tree = parser:parse()[1]

  if not tree then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  local node = tree:root():descendant_for_range(row, col, row, col)

  while node do
    if node:type() == "call_expression" then
      local name = call_name(node, bufnr)

      if name and is_test_call(name) then
        return first_string_arg(node, bufnr)
      end
    end

    node = node:parent()
  end
end

local function regex_escape(text)
  return vim.fn.escape(text, "\\^$.*+?()[]{}|")
end

local function append_nearest_test(command, flag)
  local title = nearest_test_title()

  if not title then
    vim.notify("Could not find nearest test title", vim.log.levels.WARN)
    return
  end

  return command .. " " .. flag .. " " .. vim.fn.shellescape(regex_escape(title))
end

function M.nearest_playwright_test(command)
  return append_nearest_test(command, "--grep")
end

function M.nearest_vitest_test(command)
  return append_nearest_test(command, "--testNamePattern")
end

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
  if follow_timer then
    follow_timer:stop()
    follow_timer:close()
    follow_timer = nil
  end

  if terminal and terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    pcall(terminal.close, terminal)
    pcall(vim.api.nvim_buf_delete, terminal.buf, { force = true })
  end
end

local function follow_terminal_output()
  if not terminal or not terminal.buf or not terminal.win then
    return
  end

  follow_timer = vim.uv.new_timer()
  follow_timer:start(
    100,
    100,
    vim.schedule_wrap(function()
      if
        not terminal
        or not vim.api.nvim_buf_is_valid(terminal.buf)
        or not vim.api.nvim_win_is_valid(terminal.win)
      then
        close_terminal()
        return
      end

      local line_count = vim.api.nvim_buf_line_count(terminal.buf)
      pcall(vim.api.nvim_win_set_cursor, terminal.win, { line_count, 0 })
    end)
  )

  terminal:on("TermClose", function()
    if follow_timer then
      follow_timer:stop()
      follow_timer:close()
      follow_timer = nil
    end
  end, { buf = true })
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
  follow_terminal_output()
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
    local builder = vim.b.makeprg_at_line

    if type(builder) == "function" then
      local line_command = builder(command)

      if line_command then
        run(line_command)
      end

      return
    end

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
