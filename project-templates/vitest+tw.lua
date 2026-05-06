local group = vim.api.nvim_create_augroup("planable_makeprg", { clear = true })
local testing = require("plugins.test")

local function set_makeprg(buf, command)
  vim.bo[buf].makeprg = command
  vim.b[buf].makeprg_at_line = nil
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  group = group,
  pattern = {
    "*.tests.ts",
    "*.tests.tsx",
    "*.test.ts",
    "*.test.tsx",
  },
  callback = function(args)
    set_makeprg(args.buf, "npm t -- %:p")
    vim.b[args.buf].makeprg_at_line = testing.nearest_vitest_test
  end,
})

local playwright_cmd = "meteor npx playwright test --headed --reporter=line"

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  group = group,
  pattern = { "*_spec.ts" },
  callback = function(args)
    local buf = args.buf
    local file = vim.api.nvim_buf_get_name(buf)

    if
      not file:match("/tests/playwright/") or file:match("/tests/playwright/integration/smoke/")
    then
      return
    end

    set_makeprg(buf, playwright_cmd .. " --config playwright.config.ts %:p")
    vim.b[buf].makeprg_at_line = testing.nearest_playwright_test
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  group = group,
  pattern = { "*_spec.ts" },
  callback = function(args)
    local buf = args.buf
    local file = vim.api.nvim_buf_get_name(buf)

    if not file:match("/tests/playwright/integration/smoke/") then
      return
    end

    set_makeprg(buf, playwright_cmd .. " --config playwright-smoke.config.ts %:p")
    vim.b[buf].makeprg_at_line = testing.nearest_playwright_test
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  group = group,
  pattern = { "*_views.ts" },
  callback = function(args)
    local buf = args.buf
    local file = vim.api.nvim_buf_get_name(buf)

    if not file:match("/tests/playwright/") then
      return
    end

    set_makeprg(buf, playwright_cmd .. " --config playwright-visual.config.ts %:p")
    vim.b[buf].makeprg_at_line = testing.nearest_playwright_test
  end,
})

vim.api.nvim_exec_autocmds("BufEnter", {
  group = group,
  buffer = 0,
  modeline = false,
})
