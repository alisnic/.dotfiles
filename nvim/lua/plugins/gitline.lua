local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

local function system(args, opts)
  local result = vim.system(args, vim.tbl_extend("force", { text = true }, opts or {})):wait()

  if result.code ~= 0 then
    local message = vim.trim(result.stderr or result.stdout or "")
    return nil, message
  end

  return vim.trim(result.stdout or "")
end

local function current_file()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return nil, "Current buffer has no file"
  end

  local root, root_err =
    system({ "git", "-C", vim.fs.dirname(path), "rev-parse", "--show-toplevel" })

  if not root then
    return nil, root_err
  end

  local relative_path = vim.fs.relpath(root, path)

  if not relative_path then
    return nil, "Current file is outside the git repository"
  end

  return {
    path = relative_path,
    root = root,
    line = math.max(1, vim.api.nvim_win_get_cursor(0)[1]),
  }
end

local function blame_current_line()
  local file, file_err = current_file()

  if not file then
    return nil, file_err
  end

  local range = string.format("%d,%d", file.line, file.line)
  local output, blame_err = system({
    "git",
    "-C",
    file.root,
    "blame",
    "--line-porcelain",
    "-L",
    range,
    "--",
    file.path,
  })

  if not output then
    return nil, blame_err
  end

  local commit = output:match("^(%S+)")

  if not commit or commit:match("^0+$") then
    return nil, "Current line is not committed yet"
  end

  return {
    commit = commit,
    root = file.root,
    summary = output:match("\nsummary (.-)\n") or "",
    author = output:match("\nauthor (.-)\n") or "",
    author_time = tonumber(output:match("\nauthor%-time (%d+)\n")),
  }
end

function M.open_commit()
  local blame, err = blame_current_line()

  if not blame then
    notify(err, vim.log.levels.ERROR)
    return
  end

  local ok, commit_view = pcall(require, "neogit.buffers.commit_view")

  if not ok then
    vim.cmd.packadd("neogit")
    commit_view = require("neogit.buffers.commit_view")
  end

  commit_view.new(blame.commit):open("floating")
end

function M.open_pr()
  local blame, blame_err = blame_current_line()

  if not blame then
    notify(blame_err, vim.log.levels.ERROR)
    return
  end

  local url, pr_err = system({
    "gh",
    "api",
    "-H",
    "Accept: application/vnd.github+json",
    "repos/{owner}/{repo}/commits/" .. blame.commit .. "/pulls",
    "--jq",
    ".[0].html_url",
  }, { cwd = blame.root })

  if not url or url == "" then
    notify(
      pr_err ~= "" and pr_err or "No PR found for " .. blame.commit:sub(1, 12),
      vim.log.levels.ERROR
    )
    return
  end

  if vim.ui.open then
    vim.ui.open(url)
  else
    vim.fn.jobstart({ "open", url }, { detach = true })
  end

  notify("Opened " .. url)
end

function M.setup()
  vim.api.nvim_create_user_command("GitLineCommit", M.open_commit, {})
  vim.api.nvim_create_user_command("GitLinePR", M.open_pr, {})

  vim.keymap.set("n", "<leader>gb", M.open_commit, { desc = "Open commit for current line" })
  vim.keymap.set("n", "<leader>go", M.open_pr, { desc = "Open PR for current line" })
end

return M
