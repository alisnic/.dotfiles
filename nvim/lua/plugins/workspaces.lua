local M = {}

local list_workspaces
local switch_workspace

function M.setup()
  vim.keymap.set("n", "<leader>w", M.open, { silent = true, desc = "Switch git workspace" })
end

function M.open()
  local workspaces, err = list_workspaces()

  if not workspaces then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local name_width = 20

  for _, workspace in ipairs(workspaces) do
    name_width = math.max(name_width, #workspace.name)
  end

  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = math.min(name_width, 60) },
      { remaining = true },
    },
  })

  pickers
    .new({}, {
      prompt_title = "Git workspaces",
      previewer = false,
      sorter = conf.generic_sorter({}),
      finder = finders.new_table({
        results = workspaces,
        entry_maker = function(workspace)
          return {
            value = workspace,
            ordinal = workspace.name .. " " .. workspace.branch .. " " .. workspace.path,
            display = function(entry)
              return displayer({
                entry.value.name,
                { entry.value.branch, "Comment" },
              })
            end,
          }
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if not selection then
            return
          end

          switch_workspace(selection.value.path)
        end)

        return true
      end,
    })
    :find()
end

switch_workspace = function(path)
  local ok, neogit = pcall(require, "neogit")
  local status = ok and neogit.status and neogit.status.instance()

  if status and status.buffer then
    status:chdir(path)
  else
    vim.api.nvim_set_current_dir(path)
  end

  vim.notify(path)
end

local function git_dir()
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()

  if result.code == 0 then
    return vim.trim(result.stdout)
  end

  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    return nil
  end

  result = vim.system({
    "git",
    "-C",
    vim.fs.dirname(file),
    "rev-parse",
    "--show-toplevel",
  }, { text = true }):wait()

  if result.code == 0 then
    return vim.trim(result.stdout)
  end
end

list_workspaces = function()
  local root = git_dir()

  if not root then
    return nil, "Not in a git repository"
  end

  local result = vim.system({
    "git",
    "-C",
    root,
    "worktree",
    "list",
    "--porcelain",
  }, { text = true }):wait()

  if result.code ~= 0 then
    return nil, vim.trim(result.stderr or "git worktree list failed")
  end

  local workspaces = {}
  local path
  local branch = ""

  local function flush()
    if not path or not vim.uv.fs_stat(path) then
      path = nil
      branch = ""
      return
    end

    table.insert(workspaces, {
      path = vim.fs.normalize(path),
      name = vim.fs.basename(path),
      branch = branch,
    })

    path = nil
    branch = ""
  end

  for line in vim.gsplit(result.stdout or "", "\n", { trimempty = true }) do
    local worktree_path = line:match("^worktree (.+)$")

    if worktree_path then
      flush()
      path = worktree_path
    elseif line:match("^branch refs/heads/") then
      branch = line:match("^branch refs/heads/(.+)$") or ""
    elseif line == "detached" then
      branch = "detached"
    end
  end

  flush()

  if vim.tbl_isempty(workspaces) then
    return nil, "No git workspaces found"
  end

  local cwd = vim.fs.normalize(vim.fn.getcwd())

  table.sort(workspaces, function(a, b)
    if a.path == cwd then
      return true
    end

    if b.path == cwd then
      return false
    end

    return a.name < b.name
  end)

  return workspaces
end

return M
